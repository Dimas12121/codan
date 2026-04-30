import 'dart:io';
import '../entities/chat_conversation.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatConversation>> getConversations();
  Future<Map<String, dynamic>> getMessages(int produkId, int partnerId);
  Future<ChatMessage> sendMessage({
    required int produkId,
    required int receiverId,
    String? message,
    File? image,
    double? latitude,
    double? longitude,
  });
  Future<void> markAsRead(int produkId, int partnerId);
  Future<void> deleteMessage(int messageId);
}
