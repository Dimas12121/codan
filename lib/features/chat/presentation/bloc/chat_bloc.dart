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
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatConversationsLoading());
    try {
      final conversations = await repository.getConversations();
      emit(ChatConversationsLoaded(conversations));
    } catch (e) {
      emit(ChatConversationsError(e.toString()));
    }
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    // If we already have loaded messages, we don't want to show a full loading screen
    // just let it update smoothly. But for simplicity, we emit loading if initial.
    if (state is! ChatMessagesLoaded) {
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
      emit(ChatMessagesError(e.toString()));
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
      await repository.sendMessage(
        produkId: event.produkId,
        receiverId: event.receiverId,
        message: event.message,
        image: event.image,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      
      // After sending, we just reload the chat messages
      // We could also append the message manually to be faster
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
      // Reload current conversations or messages if needed
      // Ideally, the UI triggers the reload event depending on where the user is
    } catch (e) {
      // Handle error
    }
  }
}
