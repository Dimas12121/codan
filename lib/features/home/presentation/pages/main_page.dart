import 'package:codan/core/api/api_client.dart';
import 'package:codan/features/auth/auth.dart';
import 'package:codan/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:codan/features/chat/presentation/bloc/chat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:codan/core/utils/app_snackbar.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_page.dart';
import 'sell_page.dart';
import 'rent_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _isShowingLocationSheet = false;

  void _checkLocationEnforcement(User user) {
    if ((user.latitude == null || user.longitude == null) &&
        !_isShowingLocationSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLocationRequiredSheet(user);
      });
    }
  }

  void _showLocationRequiredSheet(User user) {
    if (!mounted) return;
    setState(() => _isShowingLocationSheet = true);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Verifikasi Lokasi Diperlukan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Untuk memberikan layanan terbaik dan keamanan transaksi, kami memerlukan lokasi Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleUpdateLocation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Verifikasi Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ).then((_) {
      if (mounted) setState(() => _isShowingLocationSheet = false);
    });
  }

  Future<void> _handleUpdateLocation(BuildContext context) async {
    try {
      // Store context before async operations
      final authBloc = context.read<AuthBloc>();
      final apiClient = context.read<ApiClient>();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
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

      if (!context.mounted) return;

      authBloc.add(
        AuthUpdateProfileRequested({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'location': locationName,
        }),
      );

      Navigator.pop(context); // Close sheet

      AppSnackBar.showSuccess(context, 'Lokasi berhasil diverifikasi!');
    } catch (e) {
      AppSnackBar.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isSeller =
        authState is Authenticated && authState.user.role == 'seller';

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            _checkLocationEnforcement(state.user);
          }
        },
        child: IndexedStack(
          index: _currentIndex == 2
              ? 0
              : _currentIndex, // For now keep home if sell clicked via FAB
          children: [
            const HomePage(),
            const RentPage(),
            const SellPage(),
            const ChatPage(),
            const ProfilePage(),
          ],
        ),
      ),
      floatingActionButton: isSeller
          ? SizedBox(
              height: 75,
              width: 75,
              child: FloatingActionButton(
                heroTag: 'main_add_fab',
                onPressed: () {
                  context.push('/add-product');
                },
                backgroundColor: AppColors.navbarActive,
                shape: const CircleBorder(),
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            )
          : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: AppBottomNav(
        isSeller: isSeller,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Refresh chat list when switching to chat tab
          if (index == 3) {
            context.read<ChatBloc>().add(LoadConversations());
          }
        },
      ),
    );
  }
}
