import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'package:codan/core/utils/app_snackbar.dart';

class ChatDetailPage extends StatefulWidget {
  final Map<String, dynamic> chatItem;

  const ChatDetailPage({super.key, required this.chatItem});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  Timer? _pollingTimer;
  bool _isSendingImage = false;
  bool _isFirstLoad = true;
  bool _forceScrollToBottom = false;
  bool _isGettingLocation = false;

  int get produkId => int.tryParse(widget.chatItem['produk_id']?.toString() ?? '') ?? 0;
  int get partnerId => int.tryParse(widget.chatItem['partner_id']?.toString() ?? '') ?? 0;
  String get partnerName => widget.chatItem['name']?.toString() ?? 'Pengguna';
  String get avatarUrl => widget.chatItem['avatar']?.toString() ?? '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
    // Simple polling for real-time feel (every 3 seconds)
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _loadMessages();
    });
  }

  void _loadMessages() {
    context.read<ChatBloc>().add(LoadChatMessages(produkId, partnerId));
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool force = false}) {
    if (_scrollController.hasClients) {
      final pos = _scrollController.position;
      // Scroll if forced OR if user is already near the bottom (within 100px)
      final bool isNearBottom = pos.pixels >= pos.maxScrollExtent - 100;
      
      if (force || isNearBottom) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(SendMessage(
      produkId: produkId,
      receiverId: partnerId,
      message: text,
    ));
    _messageController.clear();
  }

  Future<void> _sendImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null || !mounted) return;

    setState(() => _isSendingImage = true);
    context.read<ChatBloc>().add(SendMessage(
      produkId: produkId,
      receiverId: partnerId,
      image: File(picked.path),
    ));
  }

  Future<void> _sendLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Layanan lokasi tidak aktif.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen.';
      }

      Position position = await Geolocator.getCurrentPosition();
      
      if (!mounted) return;
      
      context.read<ChatBloc>().add(SendMessage(
        produkId: produkId,
        receiverId: partnerId,
        latitude: position.latitude,
        longitude: position.longitude,
        message: '📍 Membagikan lokasi',
      ));
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _openInGoogleMaps(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Tidak dapat membuka Google Maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
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
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            CachedNetworkImage(
              imageUrl: avatarUrl,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 20,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partnerName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                final confirm = await showDialog<bool>(
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

                if (confirm == true && mounted) {
                  context.read<ChatBloc>().add(DeleteChatHistory(produkId, partnerId));
                  context.pop(); // Go back to chat list after deletion
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Hapus Chat', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              buildWhen: (previous, current) =>
                  current is ChatMessagesLoading ||
                  current is ChatMessagesLoaded ||
                  current is ChatMessagesError,
              listener: (context, state) {
                if (state is ChatMessagesLoaded) {
                  // Mark as read only if there are unread messages from the partner
                  final hasUnread = state.messages.any((msg) => !msg.isRead && msg.senderId == partnerId);
                  if (hasUnread) {
                    context.read<ChatBloc>().add(MarkMessagesAsRead(produkId, partnerId));
                  }
                  
                  // Scroll to bottom after frame renders
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom(force: _isFirstLoad || _forceScrollToBottom);
                    if (_isFirstLoad || _forceScrollToBottom) {
                      setState(() {
                        _isFirstLoad = false;
                        _forceScrollToBottom = false;
                      });
                    }
                  });
                }
                if (state is ChatMessageSent) {
                  setState(() {
                    _isSendingImage = false;
                    _forceScrollToBottom = true;
                  });
                  // No need to call _loadMessages() here as ChatBloc already triggers it
                }
                if (state is ChatMessageSendError) {
                  setState(() => _isSendingImage = false);
                  AppSnackBar.showError(context, 'Gagal mengirim pesan: ${state.message}');
                }
              },
              builder: (context, state) {
                if (state is ChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                } else if (state is ChatMessagesError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            partnerId == 0
                                ? 'Kamu adalah penjualnya, tidak bisa chat sama diri sendiri.' 
                                : 'Error: ${state.message}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is ChatMessagesLoaded) {
                  final messages = state.messages;
                  
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('Belum ada pesan. Mulai obrolan sekarang!',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId != partnerId; // If sender is not partner, it's me

                      // Parse simple time from createdAt (assuming "YYYY-MM-DD HH:MM:SS" or similar)
                      String timeStr = '';
                      try {
                        final dt = DateTime.parse(msg.createdAt).toLocal();
                        timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                      } catch (_) {
                        timeStr = '...';
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildChatBubble(
                          message: msg.message ?? '',
                          imagePath: msg.imagePath,
                          latitude: msg.latitude,
                          longitude: msg.longitude,
                          time: timeStr,
                          isMe: isMe,
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required String message,
    String? imagePath,
    double? latitude,
    double? longitude,
    required String time,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFC7C7FF) : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (imagePath != null && imagePath.isNotEmpty)
              GestureDetector(
                onTap: () => _openFullScreenImage(imagePath),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (latitude != null && longitude != null)
              GestureDetector(
                onTap: () => _openInGoogleMaps(latitude, longitude),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              // Use static map preview for efficiency or interactive map
                              // Showing a simple Interactive Map here
                              GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(latitude, longitude),
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('location'),
                                    position: LatLng(latitude, longitude),
                                  ),
                                },
                                zoomControlsEnabled: true,
                                mapToolbarEnabled: true,
                                myLocationButtonEnabled: true,
                                liteModeEnabled: false,
                                onTap: (_) => _openInGoogleMaps(latitude, longitude),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.map_outlined, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          const Text(
                            'Buka di Google Maps',
                            style: TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (message.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 10,
                    ),
                  ),
                ],
              )
            else if (imagePath != null)
              Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  time,
                  style: const TextStyle(color: Colors.black45, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openFullScreenImage(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (ctx, e, st) => const Icon(Icons.broken_image, color: Colors.white, size: 64),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isSendingImage)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Mengirim gambar...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2B37D4), width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    color: _isSendingImage ? Colors.grey[300] : const Color(0xFF2B37D4),
                  ),
                  onPressed: _isSendingImage ? null : _sendImage,
                  tooltip: 'Kirim Gambar',
                ),
                IconButton(
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: _isGettingLocation ? Colors.grey[300] : const Color(0xFF2B37D4),
                  ),
                  onPressed: _isGettingLocation ? null : _sendLocation,
                  tooltip: 'Kirim Lokasi',
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF2B37D4)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
