import '../entities/offer.dart';

abstract class OfferRepository {
  Future<List<Offer>> getOffers(String type);
  Future<Offer> createOffer({
    required int produkId,
    required double offerPrice,
    String? message,
  });
  Future<Offer> updateOfferStatus(int id, String status);
}
