import 'package:codan/features/auth/presentation/pages/register_with_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/login_phone_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/home/presentation/pages/main_page.dart';
import '../../features/home/presentation/pages/category_selection_page.dart';
import '../../features/home/presentation/pages/marketplace_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/splash/presentation/pages/splash2_page.dart';

class AppRouter {
  static GoRouter router(AuthBloc authBloc) => GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshBloc(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final bool isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/login-phone' ||
          state.matchedLocation == '/register-otp';
      final bool isSplashPage =
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/splash2';
      final bool isProtectedPage = !isAuthPage && !isSplashPage;

      // Jika user belum login dan mencoba akses protected page
      if (authState is! Authenticated && isProtectedPage) {
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
        path: '/login-phone',
        builder: (context, state) => const LoginPhonePage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/register-otp',
        builder: (context, state) => const RegisterWithOTPPage(),
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
          final chatItem = state.extra as Map<String, String>;
          return ChatDetailPage(chatItem: chatItem);
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
