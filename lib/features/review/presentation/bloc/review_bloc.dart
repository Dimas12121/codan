import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';

// ─── Events ───────────────────────────────────────────────────────────────────

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserReviews extends ReviewEvent {
  final int userId;
  const LoadUserReviews(this.userId);
  @override
  List<Object?> get props => [userId];
}

class CreateReviewEvent extends ReviewEvent {
  final int revieweeId;
  final int produkId;
  final int rating;
  final String? comment;

  const CreateReviewEvent({
    required this.revieweeId,
    required this.produkId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [revieweeId, produkId, rating, comment];
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;
  const ReviewsLoaded(this.reviews);
  @override
  List<Object?> get props => [reviews];
}

class ReviewSubmitSuccess extends ReviewState {
  final Review review;
  const ReviewSubmitSuccess(this.review);
  @override
  List<Object?> get props => [review];
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<LoadUserReviews>((event, emit) async {
      emit(ReviewLoading());
      try {
        final reviews = await repository.getUserReviews(event.userId);
        emit(ReviewsLoaded(reviews));
      } catch (e) {
        emit(ReviewError(e.toString()));
      }
    });

    on<CreateReviewEvent>((event, emit) async {
      emit(ReviewLoading());
      try {
        final review = await repository.createReview(
          revieweeId: event.revieweeId,
          produkId: event.produkId,
          rating: event.rating,
          comment: event.comment,
        );
        emit(ReviewSubmitSuccess(review));
      } catch (e) {
        emit(ReviewError(e.toString()));
      }
    });
  }
}
