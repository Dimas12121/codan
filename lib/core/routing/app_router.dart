import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/auth.dart';
import '../../features/auth/presentation/pages/location_verification_page.dart';
import '../../features/home/home.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/chat/chat.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/splash/presentation/pages/splash2_page.dart';
import '../../features/product/product.dart';
import '../../features/wishlist/wishlist.dart';
import '../../features/notification/notification.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/profile/presentation/pages/notification_settings_page.dart';
import '../../features/profile/presentation/pages/help_center_page.dart';
import '../../features/profile/presentation/pages/language_settings_page.dart';
import '../../features/review/presentation/pages/review_page.dart';
import '../../features/review/presentation/pages/write_review_page.dart';
import '../../features/review/presentation/bloc/review_bloc.dart';
import '../../features/offer/presentation/pages/seller_offers_page.dart';
import '../../features/offer/presentation/pages/buyer_orders_page.dart';
import '../../features/offer/presentation/bloc/offer_bloc.dart';
import '../../features/auth/presentation/pages/seller_profile_page.dart';

import '../constants/app_constants.dart';

class AppRouter {
  static GoRouter router(AuthBloc authBloc) => GoRouter(
    navigatorKey: AppConstants.navigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshBloc(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final bool isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/login-email' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/login-phone' ||
          state.matchedLocation == '/register-with-otp' ||
          state.matchedLocation == '/verify-otp';
      final bool isSplashPage =
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/splash2';
      final bool isProtectedPage = !isAuthPage && !isSplashPage;

      // Jika user belum login (sudah dikonfirmasi Unauthenticated) dan mencoba akses protected page
      if (authState is Unauthenticated && isProtectedPage) {
        return '/login';
      }

      // Jika user sudah login dan mencoba akses auth page
      if (authState is Authenticated && isAuthPage) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/splash2',
        builder: (context, state) => const Splash2Page(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/login-email',
        builder: (context, state) => const LoginEmailPage(),
      ),
      GoRoute(
        path: '/login-phone',
        builder: (context, state) => const LoginPhonePage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/register-with-otp',
        builder: (context, state) => const RegisterWithOTPPage(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return VerifyOTPPage(
            destination: extras['destination'] ?? '',
            type: extras['type'] ?? 'login',
            onVerify: extras['onVerify'] as Function(String)?,
          );
        },
      ),
      GoRoute(
        path: '/location-verification',
        builder: (context, state) => const LocationVerificationPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(path: '/', builder: (context, state) => const MainPage()),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategorySelectionPage(),
      ),
      GoRoute(
        path: '/marketplace',
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return MarketplacePage(initialCategory: category);
        },
      ),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
      GoRoute(
        path: '/chat/detail',
        builder: (context, state) {
          final chatItem = state.extra as Map<String, dynamic>;
          return ChatDetailPage(chatItem: chatItem);
        },
      ),
      GoRoute(
        path: '/add-product',
        builder: (context, state) {
          final product = state.extra as Product?;
          return AddEditProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/edit-product',
        builder: (context, state) {
          final product = state.extra as Product;
          return AddEditProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/notification-settings',
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: '/help-center',
        builder: (context, state) => const HelpCenterPage(),
      ),
      GoRoute(
        path: '/language-settings',
        builder: (context, state) => const LanguageSettingsPage(),
      ),
      GoRoute(
        path: '/my-products',
        builder: (context, state) => const MyProductsPage(),
      ),
      GoRoute(
        path: '/reviews/:userId',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          final userName = state.uri.queryParameters['name'] ?? 'Penjual';
          return BlocProvider.value(
            value: context.read<ReviewBloc>(),
            child: ReviewPage(userId: userId, userName: userName),
          );
        },
      ),
      GoRoute(
        path: '/write-review',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return BlocProvider.value(
            value: context.read<ReviewBloc>(),
            child: WriteReviewPage(
              revieweeId: extras['revieweeId'] as int,
              produkId: extras['produkId'] as int,
              sellerName: extras['sellerName'] as String,
              productName: extras['productName'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: '/seller-offers',
        builder: (context, state) => BlocProvider.value(
          value: context.read<OfferBloc>(),
          child: const SellerOffersPage(),
        ),
      ),
      GoRoute(
        path: '/my-orders',
        builder: (context, state) => BlocProvider.value(
          value: context.read<OfferBloc>(),
          child: const BuyerOrdersPage(),
        ),
      ),
      GoRoute(
        path: '/seller-profile',
        builder: (context, state) {
          final seller = state.extra as Seller;
          return SellerProfilePage(seller: seller);
        },
      ),
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailPage(product: product);
        },
      ),
    ],
  );
}

class GoRouterRefreshBloc extends ChangeNotifier {
  GoRouterRefreshBloc(BlocBase<dynamic> bloc) {
    _subscription = bloc.stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
