import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/api/api_client.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'package:codan/core/utils/app_snackbar.dart';

class LocationVerificationPage extends StatefulWidget {
  const LocationVerificationPage({super.key});

  @override
  State<LocationVerificationPage> createState() =>
      _LocationVerificationPageState();
}

class _LocationVerificationPageState extends State<LocationVerificationPage> {
  bool _isLoadingLocation = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      // Store references before async operations
      final authBloc = context.read<AuthBloc>();
      final apiClient = context.read<ApiClient>();

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Layanan lokasi tidak aktif.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen.';
      }

      Position position = await Geolocator.getCurrentPosition();

      // Reverse Geocoding untuk mendapatkan nama kota
      String locationName = 'Lokasi tidak diketahui';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String city = place.locality ?? '';
          String regency = place.subAdministrativeArea ?? '';

          if (city.isNotEmpty && regency.isNotEmpty) {
            locationName = "$city, $regency";
          } else {
            locationName = city.isNotEmpty
                ? city
                : (regency.isNotEmpty ? regency : 'Lokasi tidak diketahui');
          }
        }
      } catch (e) {
        debugPrint("Error geocoding fallback to Nominatim: $e");
        try {
          final response = await apiClient.dio.get(
            'https://nominatim.openstreetmap.org/reverse',
            queryParameters: {
              'format': 'json',
              'lat': position.latitude,
              'lon': position.longitude,
            },
          );
          if (response.data != null && response.data['address'] != null) {
            final address = response.data['address'];
            String city =
                address['city'] ?? address['town'] ?? address['village'] ?? '';
            String regency = address['county'] ?? address['state'] ?? '';

            if (city.isNotEmpty && regency.isNotEmpty) {
              locationName = "$city, $regency";
            } else {
              locationName = city.isNotEmpty
                  ? city
                  : (regency.isNotEmpty ? regency : 'Lokasi tidak diketahui');
            }
          }
        } catch (fallbackError) {
          debugPrint("Fallback geocoding juga gagal: $fallbackError");
        }
      }

      if (!mounted) return;

      authBloc.add(
        AuthUpdateProfileRequested({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'location': locationName,
        }),
      );

      AppSnackBar.showSuccess(context, 'Lokasi berhasil diverifikasi!');

      // Navigate back after success
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) context.pop();
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              // Location illustration and content
              Column(
                children: [
                  // Location icon with circles
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                        ),
                      ),
                      // Middle circle
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade200,
                        ),
                      ),
                      // Inner circle with pin
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.yellow,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Title
                  const Text(
                    'Where is your Location?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Enjoy a personalized selling and Buying experience by Telling us your Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
              // Buttons
              Column(
                children: [
                  // Find My Location button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoadingLocation
                          ? null
                          : _getCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D3D3D),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: _isLoadingLocation
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Find My Location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Other Location button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to manual location selection
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        'Other Location',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
