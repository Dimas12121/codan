import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_textfield.dart';
import '../services/otp_service.dart';
import '../../data/repositories/auth_repository_impl.dart';

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

  bool _isSendingOTP = false;
  String _generatedOTP = '';
  String _selectedRole = 'buyer';

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

    final phone = OTPService.formatPhoneNumber(_phoneController.text);
    if (!OTPService.isValidPhoneNumber(phone)) {
      if (mounted) {
        AppSnackBar.showError(context, 'Harap lengkapi semua data');
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

      // Get repository from context
      final authRepository = context.read<AuthRepositoryImpl>();

      // Send OTP via WhatsApp using Fonnte through backend API
      final response = await authRepository.sendOTPviaWhatsApp(
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
          context.push('/verify-otp', extra: {
            'destination': phone,
            'type': 'register',
            'onVerify': (String otp) {
              _otpController.text = otp;
              _verifyOTP();
            },
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
        AppSnackBar.showError(context, 'Error: $e');
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

    final otp = _otpController.text;
    final phone = _phoneController.text;

    // Simpan ref sebelum semua async gap
    final authRepository = context.read<AuthRepositoryImpl>();
    final email = _emailController.text;

    setState(() {
      _isSendingOTP = true;
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
        if (mounted) {
          AppSnackBar.showError(context, 'Verifikasi OTP gagal: ${response.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingOTP = false;
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
        phone: OTPService.formatPhoneNumber(_phoneController.text.trim()),
        password: _passwordController.text,
        role: _selectedRole,
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
            AppSnackBar.showError(context, state.message);
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
                        'Create Account',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Complete your details to start your journey',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
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
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedRole,
                                dropdownColor: const Color(0xFF2B37D4),
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Select Role',
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
                                items: const [
                                  DropdownMenuItem(
                                    value: 'buyer',
                                    child: Text('Buyer'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'seller',
                                    child: Text('Seller'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedRole = value;
                                    });
                                  }
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
                                          'REGISTER',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
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
