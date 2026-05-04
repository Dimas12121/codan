import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc({required this.repository}) : super(ChatInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendMessage>(_onSendMessage);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
    on<DeleteMessage>(_onDeleteMessage);
    on<DeleteChatHistory>(_onDeleteChatHistory);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatConversationsLoaded) {
      emit(ChatConversationsLoading());
    }
    try {
      final conversations = await repository.getConversations();
      emit(ChatConversationsLoaded(conversations));
    } catch (e) {
      if (state is! ChatConversationsLoaded) {
        emit(ChatConversationsError(e.toString()));
      }
    }
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    // If we already have loaded messages, we don't want to show a full loading screen
    if (state is! ChatMessagesLoaded && state is! ChatConversationsLoaded) {
      emit(ChatMessagesLoading());
    }
    
    try {
      final data = await repository.getMessages(event.produkId, event.partnerId);
      emit(ChatMessagesLoaded(
        produk: data['produk'],
        partner: data['partner'],
        messages: data['messages'],
      ));
    } catch (e) {
      if (state is! ChatMessagesLoaded) {
        emit(ChatMessagesError(e.toString()));
      }
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    // Save current state so we can revert/update it
    final currentState = state;
    
    emit(ChatMessageSending());
    try {
      final message = await repository.sendMessage(
        produkId: event.produkId,
        receiverId: event.receiverId,
        message: event.message,
        image: event.image,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      
      emit(ChatMessageSent(message));
      // After sending, we also reload the chat messages to get the official list from server
      add(LoadChatMessages(event.produkId, event.receiverId));
    } catch (e) {
      emit(ChatMessageSendError(e.toString()));
      // Revert to previous state if needed, or reload
      if (currentState is ChatMessagesLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsRead event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await repository.markAsRead(event.produkId, event.partnerId);
    } catch (e) {
      // Background process, ignore error silently
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await repository.deleteMessage(event.messageId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onDeleteChatHistory(
    DeleteChatHistory event,
    Emitter<ChatState> emit,
  ) async {
    // Current state might be important for refreshing
    final currentState = state;
    
    emit(ChatConversationsLoading());
    try {
      await repository.clearConversation(event.produkId, event.partnerId);
      // Reload conversations after deletion
      final conversations = await repository.getConversations();
      emit(ChatConversationsLoaded(conversations));
    } catch (e) {
      emit(ChatConversationsError(e.toString()));
      // Restore previous state if it was loaded
      if (currentState is ChatConversationsLoaded) {
        emit(currentState);
      }
    }
  }
}
