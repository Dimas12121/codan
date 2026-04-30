import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConversationsLoading extends ChatState {}

class ChatConversationsLoaded extends ChatState {
  final List<ChatConversation> conversations;

  const ChatConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ChatConversationsError extends ChatState {
  final String message;

  const ChatConversationsError(this.message);

  @override
  List<Object?> get props => [message];
}

// For detail chat room
class ChatMessagesLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final ChatProduk produk;
  final ChatPartner partner;
  final List<ChatMessage> messages;

  const ChatMessagesLoaded({
    required this.produk,
    required this.partner,
    required this.messages,
  });

  @override
  List<Object?> get props => [produk, partner, messages];
}

class ChatMessagesError extends ChatState {
  final String message;

  const ChatMessagesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageSending extends ChatState {}

class ChatMessageSent extends ChatState {
  final ChatMessage message;

  const ChatMessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageSendError extends ChatState {
  final String message;

  const ChatMessageSendError(this.message);

  @override
  List<Object?> get props => [message];
}
