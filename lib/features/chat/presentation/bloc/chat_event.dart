import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends ChatEvent {}

class LoadChatMessages extends ChatEvent {
  final int produkId;
  final int partnerId;

  const LoadChatMessages(this.produkId, this.partnerId);

  @override
  List<Object?> get props => [produkId, partnerId];
}

class SendMessage extends ChatEvent {
  final int produkId;
  final int receiverId;
  final String? message;
  final File? image;
  final double? latitude;
  final double? longitude;

  const SendMessage({
    required this.produkId,
    required this.receiverId,
    this.message,
    this.image,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        produkId,
        receiverId,
        message,
        image?.path,
        latitude,
        longitude,
      ];
}

class MarkMessagesAsRead extends ChatEvent {
  final int produkId;
  final int partnerId;

  const MarkMessagesAsRead(this.produkId, this.partnerId);

  @override
  List<Object?> get props => [produkId, partnerId];
}

class DeleteMessage extends ChatEvent {
  final int messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class DeleteChatHistory extends ChatEvent {
  final int produkId;
  final int partnerId;

  const DeleteChatHistory(this.produkId, this.partnerId);

  @override
  List<Object?> get props => [produkId, partnerId];
}
