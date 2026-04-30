import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<LoadMyProducts>(_onLoadMyProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts(
        category: event.category,
        search: event.search,
        type: event.type,
      );
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductDetailLoading());
    try {
      final product = await repository.getProductDetail(event.identifier);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> _onLoadMyProducts(
    LoadMyProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getMyProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductOperationLoading());
    try {
      final product = await repository.createProduct(event.data);
      emit(ProductOperationSuccess('Produk berhasil ditambahkan', product: product));
      // Refresh list
      add(const LoadProducts());
    } catch (e) {
      emit(ProductOperationError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductOperationLoading());
    try {
      final product = await repository.updateProduct(event.id, event.data);
      emit(ProductOperationSuccess('Produk berhasil diperbarui', product: product));
      // Refresh list
      add(const LoadProducts());
    } catch (e) {
      emit(ProductOperationError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductOperationLoading());
    try {
      await repository.deleteProduct(event.id);
      emit(const ProductOperationSuccess('Produk berhasil dihapus'));
      // Refresh list
      add(const LoadProducts());
    } catch (e) {
      emit(ProductOperationError(e.toString()));
    }
  }
}
