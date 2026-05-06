import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/api/api_client.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:codan/core/utils/app_snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool _isUpdatingLocation = false;

  Future<void> _updateAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null && mounted) {
      context.read<AuthBloc>().add(
        AuthUpdateProfileRequested({'avatar': image.path}),
      );
    }
  }

  Future<void> _updateLocation() async {
    final authBloc = context.read<AuthBloc>();
    final apiClient = context.read<ApiClient>();

    setState(() => _isUpdatingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Layanan lokasi tidak aktif.';

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

      AppSnackBar.showSuccess(context, 'Lokasi berhasil diperbarui!');
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isUpdatingLocation = false);
    }
  }

  Future<void> _openInGoogleMaps(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _handleRoleSwitch(BuildContext context, String? currentRole) {
    final newRole = currentRole == 'seller' ? 'buyer' : 'seller';
    final roleLabel = newRole == 'seller' ? 'Penjual' : 'Pembeli';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Beralih Role'),
        content: Text('Apakah Anda yakin ingin beralih menjadi $roleLabel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(
                AuthUpdateProfileRequested({'role': newRole}),
              );
              AppSnackBar.showSuccess(
                context,
                'Berhasil beralih menjadi $roleLabel',
              );
            },
            child: const Text('Ya, Beralih'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return _buildProfileContent(context, state.user);
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildUnauthenticatedContent(context);
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Header
          Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: user.profilePhoto != null
                      ? Image.network(
                          user.profilePhoto!.startsWith('http')
                              ? user.profilePhoto!
                              : '${AppConstants.baseUrl}/storage/${user.profilePhoto}',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, e, st) =>
                              _buildPlaceholderAvatar(user),
                        )
                      : _buildPlaceholderAvatar(user),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _updateAvatar,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.role?.toUpperCase() ?? 'MEMBER',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _buildHeaderAction(
                    icon: Icons.edit_note_rounded,
                    label: 'Edit Profil',
                    onTap: () => context.push('/edit-profile'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHeaderAction(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Pesanan Saya',
                    onTap: () => context.push('/my-orders'),
                  ),
                ),
                if (user.role == 'seller') ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildHeaderAction(
                      icon: Icons.local_offer_outlined,
                      label: 'Penawaran',
                      onTap: () => context.push('/seller-offers'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Info Sections
          _buildSectionTitle('Informasi Akun'),
          _buildInfoTile(Icons.email_outlined, 'Email', user.email),
          _buildInfoTile(Icons.phone_outlined, 'Nomor HP', user.phone),
          _buildInfoTile(
            Icons.location_on_outlined,
            'Lokasi',
            user.location ?? 'Belum diatur',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.latitude != null && user.longitude != null)
                  IconButton(
                    icon: const Icon(
                      Icons.map_outlined,
                      color: Colors.green,
                      size: 20,
                    ),
                    onPressed: () =>
                        _openInGoogleMaps(user.latitude!, user.longitude!),
                    tooltip: 'Lihat di Peta',
                  ),
                _isUpdatingLocation
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.my_location,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onPressed: _updateLocation,
                        tooltip: 'Perbarui Lokasi',
                      ),
              ],
            ),
          ),

          if (user.latitude != null && user.longitude != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(user.latitude!, user.longitude!),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('current_loc'),
                            position: LatLng(user.latitude!, user.longitude!),
                          ),
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        liteModeEnabled: false,
                        onTap: (_) =>
                            _openInGoogleMaps(user.latitude!, user.longitude!),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton.small(
                          heroTag: 'map_btn',
                          onPressed: () => _openInGoogleMaps(
                            user.latitude!,
                            user.longitude!,
                          ),
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.open_in_new,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24),
          _buildSectionTitle('Lainnya'),
          _buildMenuTile(
            user.role == 'seller'
                ? Icons.person_outline
                : Icons.storefront_outlined,
            user.role == 'seller' ? 'Beralih ke Pembeli' : 'Beralih ke Penjual',
            () {
              _handleRoleSwitch(context, user.role);
            },
          ),
          _buildMenuTile(
            Icons.favorite_border,
            'Favorit Saya',
            () => context.push('/wishlist'),
          ),
          _buildMenuTile(
            Icons.star_border_rounded,
            'Ulasan Saya',
            () => context.push(
              '/reviews/${user.id}?name=${Uri.encodeComponent(user.name)}',
            ),
          ),
          if (user.role == 'seller')
            _buildMenuTile(
              Icons.store_outlined,
              'Produk Saya',
              () => context.push('/my-products'),
            ),
          _buildMenuTile(Icons.help_outline, 'Pusat Bantuan', () {}),
          _buildMenuTile(Icons.info_outline, 'Tentang CODAN', () {}),

          const SizedBox(height: 140), // Extra padding for bottom app button
        ],
      ),
    );
  }

  Widget _buildPlaceholderAvatar(User user) {
    return Container(
      color: AppColors.primaryLight,
      child: Center(
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'Masuk untuk melihat profil Anda',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              'Login / Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
