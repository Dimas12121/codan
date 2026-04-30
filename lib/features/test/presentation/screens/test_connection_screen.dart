import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/config/environment.dart';

class TestConnectionScreen extends StatefulWidget {
  const TestConnectionScreen({super.key});

  @override
  State<TestConnectionScreen> createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isTesting = false;
  String _testResult = '';
  String _errorMessage = '';

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = '';
      _errorMessage = '';
    });

    try {
      final response = await _apiClient.dio.get('/test-connection');

      setState(() {
        _testResult =
            'Connection successful!\n\n'
            'Response: ${response.data}\n\n'
            'Environment: ${EnvironmentConfig.current}\n'
            'Base URL: ${EnvironmentConfig.baseUrl}';
      });

      AppLogger.info('Connection test passed');
    } on DioException catch (e) {
      setState(() {
        _errorMessage =
            'Connection failed!\n\n'
            'Error: ${e.message}\n'
            'Status Code: ${e.response?.statusCode}\n'
            'Response: ${e.response?.data}\n\n'
            'Tips:\n'
            '1. Make sure Laravel server is running\n'
            '2. Check if port 8000 is accessible\n'
            '3. Verify CORS configuration in Laravel\n'
            '4. For Android emulator use: http://10.0.2.2:8000\n'
            '5. For iOS simulator use: http://localhost:8000';
      });

      AppLogger.error('Connection test failed', e);
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });

      AppLogger.error('Unexpected error in connection test', e);
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Laravel Connection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connection Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Environment: ${EnvironmentConfig.current}'),
                    Text('Base URL: ${EnvironmentConfig.baseUrl}'),
                    const SizedBox(height: 8),
                    const Text(
                      'Note:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('- Android Emulator: http://10.0.2.2:8000'),
                    const Text('- iOS Simulator: http://localhost:8000'),
                    const Text('- Web: http://localhost:8000'),
                    const Text('- Physical Device: http://<YOUR_IP>:8000'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isTesting ? null : _testConnection,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isTesting
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text('Testing Connection...'),
                      ],
                    )
                  : const Text('Test Connection'),
            ),
            const SizedBox(height: 20),
            if (_testResult.isNotEmpty)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Success',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_testResult),
                    ],
                  ),
                ),
              ),
            if (_errorMessage.isNotEmpty)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_errorMessage),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laravel Setup Instructions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('1. Install CORS package:'),
                    Text('   composer require fruitcake/laravel-cors'),
                    SizedBox(height: 8),
                    Text('2. Add test endpoint to routes/api.php:'),
                    Text('   Route::get(\'/test-connection\', function() {'),
                    Text('       return response()->json([...]);'),
                    Text('   });'),
                    SizedBox(height: 8),
                    Text('3. Configure CORS in config/cors.php'),
                    SizedBox(height: 8),
                    Text('4. Start Laravel server:'),
                    Text('   php artisan serve'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
