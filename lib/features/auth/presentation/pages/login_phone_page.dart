import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../services/otp_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../../../core/api/api_client.dart';

class LoginPhonePage extends StatefulWidget {
  const LoginPhonePage({super.key});

  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  bool _showOTPField = false;
  bool _isSendingOTP = false;
  bool _isVerifyingOTP = false;
  String _maskedPhone = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text;
    if (!OTPService.isValidPhoneNumber(phone)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nomor telepon tidak valid'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() {
      _isSendingOTP = true;
    });

    try {
      // Generate OTP
      final otpData = OTPService.generateOTPWithExpiry();
      final otp = otpData['otp'] as String;

      // Get API client from context
      final apiClient = context.read<ApiClient>();
      final authRemoteDataSource = AuthRemoteDataSource(apiClient);

      // Send OTP via WhatsApp using Fonnte through backend API
      final response = await authRemoteDataSource.sendOTPviaWhatsApp(
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
          setState(() {
            _showOTPField = true;
            _maskedPhone = OTPService.maskPhoneNumber(phone);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'OTP telah dikirim ke WhatsApp ${OTPService.formatPhoneNumber(phone)}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim OTP: ${response.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingOTP = false;
        });
      }
    }
  }

  Future<void> _verifyOTP() async {
    if (!_otpFormKey.currentState!.validate()) return;

    setState(() {
      _isVerifyingOTP = true;
    });

    try {
      final phone = _phoneController.text;
      final otp = _otpController.text;

      // Cek OTP lokal dulu (expire check)
      final otpData = await OTPService.getOTPData();
      if (otpData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sesi OTP tidak ditemukan. Kirim ulang OTP.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      if (OTPService.isOTPExpired(otpData)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sudah kadaluarsa. Kirim ulang OTP.'),
              backgroundColor: AppColors.error,
            ),
          );
          setState(() {
            _showOTPField = false;
          });
        }
        return;
      }

      // Cek OTP lokal
      final savedOtp = otpData['otp']?.toString();
      if (savedOtp == null || savedOtp != otp) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP tidak valid'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Verifikasi OTP ke backend lalu login
      if (mounted) {
        context.read<AuthBloc>().add(AuthLoginPhoneRequested(phone, otp));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifyingOTP = false;
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
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
                    Text(
                      _showOTPField ? 'Verifikasi OTP' : 'Login via WhatsApp',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showOTPField
                          ? 'Masukkan kode yang dikirim ke $_maskedPhone'
                          : 'Masukkan nomor WhatsApp Anda untuk masuk',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    if (!_showOTPField)
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
                          ],
                        ),
                      )
                    else
                      Form(
                        key: _otpFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 8,
                              ),
                              decoration: InputDecoration(
                                hintText: '000000',
                                hintStyle: const TextStyle(
                                  color: Colors.white30,
                                  fontSize: 24,
                                  letterSpacing: 8,
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.white30),
                                ),
                              ),
                              maxLength: 6,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'OTP tidak boleh kosong';
                                }
                                if (value.length != 6) {
                                  return 'OTP harus 6 digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading =
                                    state is AuthLoading || _isVerifyingOTP;
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _verifyOTP,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF2B37D4),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2B37D4),
                                              ),
                                            ),
                                          )
                                        : const Text(
                                            'Verifikasi & Masuk',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _isSendingOTP ? null : _sendOTP,
                              child: const Text(
                                'Kirim Ulang OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
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
