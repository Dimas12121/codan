import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts({String? category, String? search, String? type}) async {
    return await remoteDataSource.getProducts(category: category, search: search, type: type);
  }

  @override
  Future<Product> getProductDetail(String identifier) async {
    return await remoteDataSource.getProductDetail(identifier);
  }

  @override
  Future<List<Product>> getMyProducts() async {
    return await remoteDataSource.getMyProducts();
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> data) async {
    return await remoteDataSource.createProduct(data);
  }

  @override
  Future<Product> updateProduct(int id, Map<String, dynamic> data) async {
    return await remoteDataSource.updateProduct(id, data);
  }

  @override
  Future<void> deleteProduct(int id) async {
    return await remoteDataSource.deleteProduct(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    return await remoteDataSource.getCategories();
  }
}
