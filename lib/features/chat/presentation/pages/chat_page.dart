import 'package:codan/features/chat/domain/entities/chat_conversation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatConversation>? _lastConversations;

  @override
  void initState() {
    super.initState();
    // Load conversations when page is opened
    context.read<ChatBloc>().add(LoadConversations());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70,
        leading: context.canPop() ? Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFC7C7FF),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
              ),
            ),
          ),
        ) : null,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatConversationsLoaded) {
            _lastConversations = state.conversations;
          }

          if (state is ChatConversationsError && (_lastConversations == null || _lastConversations!.isEmpty)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Gagal memuat pesan: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ChatBloc>().add(LoadConversations()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } 
          
          final displayItems = _lastConversations;
          if (displayItems != null && displayItems.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatBloc>().add(LoadConversations());
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: displayItems.length,
                separatorBuilder: (context, index) => const Divider(
                  indent: 20,
                  endIndent: 20,
                  height: 1,
                  color: Color(0xFFEEEEEE),
                ),
                itemBuilder: (context, index) {
                  final item = displayItems[index];
                  // Determine avatar
                  final avatarUrl = item.partner.avatar ?? 
                      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(item.partner.name)}&background=random&color=fff';

                  return Dismissible(
                    key: Key('chat_${item.produk.id}_${item.partner.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Chat'),
                          content: const Text('Apakah Anda yakin ingin menghapus seluruh riwayat chat ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      context.read<ChatBloc>().add(DeleteChatHistory(item.produk.id, item.partner.id));
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 35,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.partner.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            item.timestamp,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.lastMessage,
                                style: TextStyle(
                                  color: item.unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                                  fontSize: 15,
                                  fontWeight: item.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (item.unreadCount > 0)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  item.unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      onTap: () {
                        context.push('/chat/detail', extra: {
                          'produk_id': item.produk.id,
                          'partner_id': item.partner.id,
                          'name': item.partner.name,
                          'avatar': avatarUrl,
                          'produk_title': item.produk.title,
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }

          if (state is ChatConversationsLoaded && state.conversations.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada pesan.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          
          // Default loader for ChatInitial or first-time loading
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },
      ),
    );
  }
}
