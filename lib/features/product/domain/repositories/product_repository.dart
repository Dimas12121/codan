import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({String? category, String? search, String? type});
  Future<Product> getProductDetail(String identifier);
  Future<List<Product>> getMyProducts();
  Future<Product> createProduct(Map<String, dynamic> data);
  Future<Product> updateProduct(int id, Map<String, dynamic> data);
  Future<void> deleteProduct(int id);
  Future<List<Map<String, dynamic>>> getCategories();
}
