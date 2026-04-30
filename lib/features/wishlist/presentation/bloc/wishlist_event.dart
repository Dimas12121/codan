import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlistEvent extends WishlistEvent {
  final int produkId;

  const ToggleWishlistEvent(this.produkId);

  @override
  List<Object?> get props => [produkId];
}
