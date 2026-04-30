import '../../domain/entities/offer.dart';
import '../../domain/repositories/offer_repository.dart';
import '../datasources/offer_remote_data_source.dart';

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource remoteDataSource;

  OfferRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Offer>> getOffers(String type) async {
    return await remoteDataSource.getOffers(type);
  }

  @override
  Future<Offer> createOffer({
    required int produkId,
    required double offerPrice,
    String? message,
  }) async {
    return await remoteDataSource.createOffer(
      produkId: produkId,
      offerPrice: offerPrice,
      message: message,
    );
  }

  @override
  Future<Offer> updateOfferStatus(int id, String status) async {
    return await remoteDataSource.updateOfferStatus(id, status);
  }
}
