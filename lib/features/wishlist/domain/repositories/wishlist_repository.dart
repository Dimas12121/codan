import '../../../product/domain/entities/product.dart';

abstract class WishlistRepository {
  Future<List<Product>> getWishlist();
  Future<bool> toggleWishlist(int produkId);
}
