import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Product> wishlist;

  const WishlistLoaded(this.wishlist);

  @override
  List<Object?> get props => [wishlist];
}

class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WishlistToggleSuccess extends WishlistState {
  final bool isAdded;
  final int produkId;

  const WishlistToggleSuccess({required this.isAdded, required this.produkId});

  @override
  List<Object?> get props => [isAdded, produkId];
}
