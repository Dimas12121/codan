import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/models/api_response.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import 'dart:io';

abstract class ChatRemoteDataSource {
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
  Future<void> clearConversation(int produkId, int partnerId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ChatConversation>> getConversations() async {
    try {
      final response = await apiClient.dio.get('/messages');
      
      final List<dynamic> data = response.data;
      return data.map((json) => ChatConversation.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getMessages(int produkId, int partnerId) async {
    try {
      final response = await apiClient.dio.get('/messages/$produkId/$partnerId');
      
      final data = response.data;
      final produk = ChatProduk.fromJson(data['produk']);
      final partner = ChatPartner.fromJson(data['partner']);
      final List<dynamic> messagesData = data['messages'];
      final messages = messagesData.map((json) => ChatMessage.fromJson(json)).toList();

      return {
        'produk': produk,
        'partner': partner,
        'messages': messages,
      };
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
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
    try {
      FormData formData = FormData.fromMap({
        'produk_id': produkId,
        'receiver_id': receiverId,
        'message': message,
        'latitude': latitude,
        'longitude': longitude,
      }..removeWhere((_, v) => v == null));

      if (image != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(image.path),
        ));
      }

      final response = await apiClient.dio.post(
        '/messages',
        data: formData,
      );

      return ChatMessage.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<void> markAsRead(int produkId, int partnerId) async {
    try {
      await apiClient.dio.post('/messages/read/$produkId/$partnerId');
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<void> deleteMessage(int messageId) async {
    try {
      await apiClient.dio.delete('/messages/$messageId');
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }

  @override
  Future<void> clearConversation(int produkId, int partnerId) async {
    try {
      await apiClient.dio.delete('/messages/clear/$produkId/$partnerId');
    } on DioException catch (e) {
      throw ErrorResponse.fromDioException(e);
    }
  }
}
