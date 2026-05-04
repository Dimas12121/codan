import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/app_snackbar.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check connectivity
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult.contains(ConnectivityResult.none)) {
            _showNoInternetDialog();
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No Internet Connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }

          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Handle unauthorized error - clear token and redirect to login
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('access_token');
            await prefs.remove('refresh_token');
            await prefs.remove('user_data');

            // You can add event bus or navigation logic here
            // For example: EventBus().fire(LogoutEvent());
          }

          return handler.next(e);
        },
      ),
    );
  }

  static bool _isConnectivityDialogOpen = false;

  void _showNoInternetDialog() {
    if (_isConnectivityDialogOpen) return;
    
    final context = AppConstants.navigatorKey.currentContext;
    if (context == null) return;

    _isConnectivityDialogOpen = true;
    
    AppSnackBar.showError(
      context, 
      'Mohon cek sinyal atau Wifi kamu dan coba beberapa saat lagi',
      title: 'Wah, Koneksi kamu hilang',
      buttonLabel: 'Coba lagi',
      onButtonPressed: () {
        _isConnectivityDialogOpen = false;
      },
    );
  }
}
