import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  
  // Optionally support pagination/hasReachedMax if needed later
  const ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

// State for Detail
class ProductDetailLoading extends ProductState {}

class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDetailError extends ProductState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

// States for Operations (Add, Update, Delete)
class ProductOperationLoading extends ProductState {}

class ProductOperationSuccess extends ProductState {
  final String message;
  final Product? product;

  const ProductOperationSuccess(this.message, {this.product});

  @override
  List<Object?> get props => [message, product];
}

class ProductOperationError extends ProductState {
  final String message;

  const ProductOperationError(this.message);

  @override
  List<Object?> get props => [message];
}
