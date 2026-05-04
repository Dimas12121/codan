import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/offer_repository.dart';

// Events
abstract class OfferEvent extends Equatable {
  const OfferEvent();
  @override
  List<Object?> get props => [];
}

class LoadOffers extends OfferEvent {
  final String type;
  const LoadOffers(this.type);
  @override
  List<Object?> get props => [type];
}

class CreateOfferEvent extends OfferEvent {
  final int produkId;
  final double offerPrice;
  final String? message;
  const CreateOfferEvent({required this.produkId, required this.offerPrice, this.message});
  @override
  List<Object?> get props => [produkId, offerPrice, message];
}

class UpdateOfferStatusEvent extends OfferEvent {
  final int id;
  final String status;
  const UpdateOfferStatusEvent(this.id, this.status);
  @override
  List<Object?> get props => [id, status];
}

// States
abstract class OfferState extends Equatable {
  const OfferState();
  @override
  List<Object?> get props => [];
}

class OfferInitial extends OfferState {}
class OfferLoading extends OfferState {}
class OffersLoaded extends OfferState {
  final List<Offer> offers;
  const OffersLoaded(this.offers);
  @override
  List<Object?> get props => [offers];
}
class OfferOperationSuccess extends OfferState {
  final String message;
  const OfferOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
class OfferError extends OfferState {
  final String message;
  const OfferError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final OfferRepository repository;

  OfferBloc({required this.repository}) : super(OfferInitial()) {
    on<LoadOffers>((event, emit) async {
      if (state is! OffersLoaded) {
        emit(OfferLoading());
      }
      try {
        final offers = await repository.getOffers(event.type);
        emit(OffersLoaded(offers));
      } catch (e) {
        emit(OfferError(e.toString()));
      }
    });

    on<CreateOfferEvent>((event, emit) async {
      emit(OfferLoading());
      try {
        await repository.createOffer(
          produkId: event.produkId,
          offerPrice: event.offerPrice,
          message: event.message,
        );
        emit(const OfferOperationSuccess('Penawaran berhasil dikirim'));
      } catch (e) {
        emit(OfferError(e.toString()));
      }
    });

    on<UpdateOfferStatusEvent>((event, emit) async {
      emit(OfferLoading());
      try {
        await repository.updateOfferStatus(event.id, event.status);
        emit(OfferOperationSuccess('Status penawaran diperbarui: ${event.status}'));
      } catch (e) {
        emit(OfferError(e.toString()));
      }
    });
  }
}
