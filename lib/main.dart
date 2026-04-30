import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/config/environment.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

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

  runApp(MyApp(
    authBloc: authBloc,
    apiClient: apiClient,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ApiClient apiClient;
  final AuthRepositoryImpl authRepository;

  const MyApp({
    super.key,
    required this.authBloc,
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
      child: BlocProvider.value(
        value: authBloc,
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router(authBloc),
        ),
      ),
    );
  }
}
