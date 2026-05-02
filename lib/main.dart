import 'features/auth/auth.dart';
import 'features/chat/chat.dart';
import 'features/notification/notification.dart';
import 'features/offer/offer.dart';
import 'features/product/product.dart';
import 'features/wishlist/wishlist.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/config/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  // Use development by default, change to staging/production for deployment
  await EnvironmentConfig.loadEnvironment(Environment.development);

  // Log environment info
  AppLogger.info('Starting app in ${EnvironmentConfig.current} mode');
  AppLogger.info('API Base URL: ${EnvironmentConfig.baseUrl}');
  AppLogger.info('App Name: ${EnvironmentConfig.appName}');

  // Initialize Core & Features
  final apiClient = ApiClient();
  final authLocalDataSource = AuthLocalDataSource();
  final authRemoteDataSource = AuthRemoteDataSource(apiClient);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );

  final authBloc = AuthBloc(authRepository: authRepository);

  final chatRemoteDataSource = ChatRemoteDataSourceImpl(apiClient: apiClient);
  final chatRepository = ChatRepositoryImpl(remoteDataSource: chatRemoteDataSource);
  final chatBloc = ChatBloc(repository: chatRepository);

  final productRemoteDataSource = ProductRemoteDataSourceImpl(apiClient: apiClient);
  final productRepository = ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);
  final productBloc = ProductBloc(repository: productRepository);

  final wishlistRemoteDataSource = WishlistRemoteDataSourceImpl(apiClient: apiClient);
  final wishlistRepository = WishlistRepositoryImpl(remoteDataSource: wishlistRemoteDataSource);
  final wishlistBloc = WishlistBloc(repository: wishlistRepository);

  final notificationRemoteDataSource = NotificationRemoteDataSourceImpl(apiClient: apiClient);
  final notificationRepository = NotificationRepositoryImpl(remoteDataSource: notificationRemoteDataSource);
  final notificationBloc = NotificationBloc(repository: notificationRepository);

  final offerRemoteDataSource = OfferRemoteDataSourceImpl(apiClient: apiClient);
  final offerRepository = OfferRepositoryImpl(remoteDataSource: offerRemoteDataSource);
  final offerBloc = OfferBloc(repository: offerRepository);

  final searchBloc = SearchBloc(repository: productRepository);

  runApp(MyApp(
    authBloc: authBloc,
    chatBloc: chatBloc,
    productBloc: productBloc,
    wishlistBloc: wishlistBloc,
    notificationBloc: notificationBloc,
    offerBloc: offerBloc,
    searchBloc: searchBloc,
    apiClient: apiClient,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ChatBloc chatBloc;
  final ProductBloc productBloc;
  final WishlistBloc wishlistBloc;
  final NotificationBloc notificationBloc;
  final OfferBloc offerBloc;
  final SearchBloc searchBloc;
  final ApiClient apiClient;
  final AuthRepositoryImpl authRepository;

  const MyApp({
    super.key,
    required this.authBloc,
    required this.chatBloc,
    required this.productBloc,
    required this.wishlistBloc,
    required this.notificationBloc,
    required this.offerBloc,
    required this.searchBloc,
    required this.apiClient,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>.value(value: apiClient),
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authBloc),
          BlocProvider.value(value: chatBloc),
          BlocProvider.value(value: productBloc),
          BlocProvider.value(value: wishlistBloc),
          BlocProvider.value(value: notificationBloc),
          BlocProvider.value(value: offerBloc),
          BlocProvider.value(value: searchBloc),
        ],
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          scaffoldMessengerKey: AppConstants.scaffoldMessengerKey,
          routerConfig: AppRouter.router(authBloc),
          // Adding builder to support global overlays if needed, 
          // but for dialogs we usually need the key in GoRouter or MaterialApp
        ),
      ),
    );
  }
}
