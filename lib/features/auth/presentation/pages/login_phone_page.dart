import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../services/otp_service.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginPhonePage extends StatefulWidget {
  const LoginPhonePage({super.key});

  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSendingOTP = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = OTPService.formatPhoneNumber(_phoneController.text);
    if (!OTPService.isValidPhoneNumber(phone)) {
      if (mounted) {
        AppSnackBar.showError(context, 'Nomor HP tidak valid');
      }
      return;
    }

    setState(() {
      _isSendingOTP = true;
    });

    try {
      // Get repository from context
      final authRepository = context.read<AuthRepositoryImpl>();

      // Check if phone is registered first
      final checkResponse = await authRepository.checkPhoneAvailability(phone);
      final isAvailable = checkResponse.data?['available'] ?? true;
      
      if (isAvailable) {
        if (!mounted) return;
        AppSnackBar.showError(context, 'Nomor telepon belum terdaftar. Silakan daftar terlebih dahulu.');
        setState(() {
          _isSendingOTP = false;
        });
        return;
      }

      // Generate OTP
      final otpData = OTPService.generateOTPWithExpiry();
      final otp = otpData['otp'] as String;

      // Send OTP via WhatsApp using Fonnte through backend API
      final response = await authRepository.sendOTPviaWhatsApp(
        phone: phone,
        otp: otp,
        purpose: 'login',
      );

      if (!mounted) return;

      if (response.success) {
        // Save OTP data locally for verification
        await OTPService.saveOTPData(phone, otpData);
        await OTPService.saveResendTime();

        if (mounted) {
          context.push('/verify-otp', extra: {
            'destination': phone,
            'type': 'login',
          });

          AppSnackBar.showSuccess(context, 'OTP telah dikirim ke WhatsApp ${OTPService.formatPhoneNumber(phone)}');
        }
      } else {
        if (mounted) {
          AppSnackBar.showError(context, 'Gagal mengirim OTP: ${response.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingOTP = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go('/');
          } else if (state is AuthFailure) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Column(
          children: [
            // Top Section - Branding & Back Button
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: Stack(
                    children: [
                      // Back Button
                      Positioned(
                        top: 10,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      // Logo
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/splash_logo.png',
                              width: 150,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text(
                                    'CODan',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2B37D4),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Section - Phone/OTP Form
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF2B37D4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login via WhatsApp',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masukkan nomor WhatsApp Anda untuk masuk',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Nomor WhatsApp (08xxxxxxxxxx)',
                                hintStyle: const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nomor telepon tidak boleh kosong';
                                }
                                if (!OTPService.isValidPhoneNumber(value)) {
                                  return 'Nomor telepon tidak valid';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSendingOTP ? null : _sendOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF2B37D4),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _isSendingOTP
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(0xFF2B37D4),
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Kirim OTP',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                TextButton(
                                  onPressed: () => context.push('/register-with-otp'),
                                  child: const Text(
                                    'Daftar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 40),
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
