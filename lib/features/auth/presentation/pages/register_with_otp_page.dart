import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_textfield.dart';
import '../services/otp_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../../../core/api/api_client.dart';

class RegisterWithOTPPage extends StatefulWidget {
  const RegisterWithOTPPage({super.key});

  @override
  State<RegisterWithOTPPage> createState() => _RegisterWithOTPPageState();
}

class _RegisterWithOTPPageState extends State<RegisterWithOTPPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  bool _showOTPField = false;
  bool _isSendingOTP = false;
  bool _isVerifyingOTP = false;
  String _generatedOTP = '';
  String _maskedPhone = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

    final email = _emailController.text;

    setState(() {
      _isSendingOTP = true;
    });

    try {
      // Generate OTP
      final otpData = OTPService.generateOTPWithExpiry();
      _generatedOTP = otpData['otp'] as String;

      // Get API client from context
      final apiClient = context.read<ApiClient>();
      final authRemoteDataSource = AuthRemoteDataSource(apiClient);

      // Send OTP via WhatsApp using Fonnte through backend API
      final response = await authRemoteDataSource.sendOTPviaWhatsApp(
        phone: phone,
        otp: _generatedOTP,
        email: email,
        purpose: 'register',
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

    final otp = _otpController.text;
    final phone = _phoneController.text;

    if (otp != _generatedOTP) {
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

    // Simpan ref sebelum semua async gap
    final authRepository = context.read<AuthRepositoryImpl>();
    final email = _emailController.text;

    setState(() {
      _isVerifyingOTP = true;
    });

    try {
      // Verify OTP with backend
      final response = await authRepository.verifyOTP(
        phone: phone,
        otp: otp,
        email: email,
        purpose: 'register',
      );

      if (!mounted) return;

      if (response.success) {
        // OTP verified, proceed with registration
        _registerUser();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verifikasi OTP gagal: ${response.message}'),
            backgroundColor: AppColors.error,
          ),
        );
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

  void _registerUser() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthRegisterWithPhoneRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      ),
    );
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
              flex: 2,
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
                              width: 100,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text(
                                    'CODan',
                                    style: TextStyle(
                                      fontSize: 24,
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
            // Bottom Section - Form & OTP
            Expanded(
              flex: 8,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2B37D4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _showOTPField ? 'Verify OTP' : 'Register with OTP',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _showOTPField
                            ? 'Enter the code sent to your WhatsApp'
                            : 'Sign up quickly using WhatsApp verification',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      if (!_showOTPField)
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AuthTextField(
                                controller: _nameController,
                                hintText: 'Full Name',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                controller: _emailController,
                                hintText: 'Email Address',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                controller: _phoneController,
                                hintText: 'WhatsApp Number (08xxxx)',
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                controller: _passwordController,
                                hintText: 'Password',
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                controller: _confirmPasswordController,
                                hintText: 'Confirm Password',
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirm password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isSendingOTP ? null : _sendOTP,
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
                                  child: _isSendingOTP
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
                                          'Send OTP via WhatsApp',
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
                              AuthTextField(
                                controller: _otpController,
                                hintText: '6 Digit OTP',
                                keyboardType: TextInputType.number,
                                validator: OTPService.validateOTP,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      _isVerifyingOTP ? null : _verifyOTP,
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
                                  child: _isVerifyingOTP
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
                                          'Verify & Register',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _isSendingOTP ? null : _sendOTP,
                                child: const Text(
                                  'Resend OTP',
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
            ),
          ],
        ),
      ),
    );
  }
}
