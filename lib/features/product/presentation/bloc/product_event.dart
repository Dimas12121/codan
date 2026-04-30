import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final String? category;
  final String? search;
  final String? type;

  const LoadProducts({this.category, this.search, this.type});

  @override
  List<Object?> get props => [category, search, type];
}

class LoadProductDetail extends ProductEvent {
  final String identifier;

  const LoadProductDetail(this.identifier);

  @override
  List<Object?> get props => [identifier];
}

class LoadMyProducts extends ProductEvent {
  const LoadMyProducts();
}

class AddProduct extends ProductEvent {
  final Map<String, dynamic> data;

  const AddProduct(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateProductEvent extends ProductEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateProductEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteProductEvent extends ProductEvent {
  final int id;

  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}
