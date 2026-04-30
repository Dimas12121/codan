import '../../../product/domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getWishlist() async {
    return await remoteDataSource.getWishlist();
  }

  @override
  Future<bool> toggleWishlist(int produkId) async {
    return await remoteDataSource.toggleWishlist(produkId);
  }
}
