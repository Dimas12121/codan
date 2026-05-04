import 'dart:io';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatConversation>> getConversations() async {
    return await remoteDataSource.getConversations();
  }

  @override
  Future<Map<String, dynamic>> getMessages(int produkId, int partnerId) async {
    return await remoteDataSource.getMessages(produkId, partnerId);
  }

  @override
  Future<ChatMessage> sendMessage({
    required int produkId,
    required int receiverId,
    String? message,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    return await remoteDataSource.sendMessage(
      produkId: produkId,
      receiverId: receiverId,
      message: message,
      image: image,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> markAsRead(int produkId, int partnerId) async {
    return await remoteDataSource.markAsRead(produkId, partnerId);
  }

  @override
  Future<void> deleteMessage(int messageId) async {
    return await remoteDataSource.deleteMessage(messageId);
  }

  @override
  Future<void> clearConversation(int produkId, int partnerId) async {
    return await remoteDataSource.clearConversation(produkId, partnerId);
  }
}
