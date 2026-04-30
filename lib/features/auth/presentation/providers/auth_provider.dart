// Auth Provider untuk dependency injection
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/api/api_client.dart';

class AuthProvider extends StatelessWidget {
  final Widget child;

  const AuthProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // API Client
        Provider<ApiClient>(create: (_) => ApiClient()),

        // Data Sources
        Provider<AuthLocalDataSource>(create: (_) => AuthLocalDataSource()),

        Provider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSource(context.read<ApiClient>()),
        ),

        // Repository
        Provider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            localDataSource: context.read<AuthLocalDataSource>(),
          ),
        ),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) =>
            AuthBloc(authRepository: context.read<AuthRepositoryImpl>())
              ..add(AuthCheckRequested()),
        lazy: false,
        child: child,
      ),
    );
  }
}

// Helper untuk mendapatkan auth instance dengan mudah
extension AuthProviderExtension on BuildContext {
  AuthBloc get authBloc => read<AuthBloc>();
  AuthRepositoryImpl get authRepository => read<AuthRepositoryImpl>();
  AuthLocalDataSource get authLocalDataSource => read<AuthLocalDataSource>();
  AuthRemoteDataSource get authRemoteDataSource => read<AuthRemoteDataSource>();
  ApiClient get apiClient => read<ApiClient>();
}

// Widget wrapper untuk auth provider
class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AuthProvider(child: child);
  }
}
