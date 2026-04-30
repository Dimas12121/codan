// Auth Service untuk state management dan helper functions
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthService {
  // Check if user is authenticated
  static bool isAuthenticated(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    return state is Authenticated;
  }

  // Get current user
  static dynamic getCurrentUser(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      return state.user;
    }
    return null;
  }

  // Login helper
  static void login(BuildContext context, String email, String password) {
    context.read<AuthBloc>().add(AuthLoginRequested(email, password));
  }

  // Register helper
  static void register(
    BuildContext context,
    String name,
    String email,
    String password,
    String phone,
  ) {
    context.read<AuthBloc>().add(AuthRegisterRequested(name, email, password, phone));
  }

  // Logout helper
  static void logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  // Check auth status helper
  static void checkAuth(BuildContext context) {
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  // Show auth error dialog
  static void showAuthError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show loading dialog
  static void showLoading(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate password strength
  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Get auth state description
  static String getAuthStateDescription(AuthState state) {
    if (state is AuthInitial) return 'Initial';
    if (state is AuthLoading) return 'Loading';
    if (state is Authenticated) return 'Authenticated';
    if (state is Unauthenticated) return 'Unauthenticated';
    if (state is AuthFailure) return 'Failed: ${state.message}';
    return 'Unknown';
  }

  // Check if auth is in loading state
  static bool isLoading(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    return state is AuthLoading;
  }

  // Navigate based on auth state
  static void navigateBasedOnAuth(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      // Navigate to home
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else if (state is Unauthenticated) {
      // Navigate to login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  // Get auth token from storage (for API calls)
  static Future<String?> getAuthToken() async {
    // This would typically use SharedPreferences or secure storage
    // For now, we'll return null and the actual implementation
    // should be in AuthLocalDataSource
    return null;
  }

  // Clear auth data
  static Future<void> clearAuthData() async {
    // Clear tokens and user data from storage
    // Implementation should be in AuthLocalDataSource
  }
}
