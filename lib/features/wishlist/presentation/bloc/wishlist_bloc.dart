import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/wishlist_repository.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository repository;

  WishlistBloc({required this.repository}) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final wishlist = await repository.getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onToggleWishlist(ToggleWishlistEvent event, Emitter<WishlistState> emit) async {
    try {
      final isAdded = await repository.toggleWishlist(event.produkId);
      emit(WishlistToggleSuccess(isAdded: isAdded, produkId: event.produkId));
      
      // Refresh the list after toggle
      final wishlist = await repository.getWishlist();
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }
}
