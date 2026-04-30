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
      appBar: AppBar(
        title: const Text('Register dengan OTP'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Daftar dengan OTP WhatsApp',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kami akan mengirim kode OTP ke WhatsApp Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        controller: _nameController,
                        hintText: 'Nama Lengkap',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          if (value.length < 3) {
                            return 'Nama minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _phoneController,
                        hintText: 'Nomor WhatsApp (contoh: 081234567890)',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor WhatsApp tidak boleh kosong';
                          }
                          if (!OTPService.isValidPhoneNumber(value)) {
                            return 'Nomor WhatsApp tidak valid';
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
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Konfirmasi Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password tidak boleh kosong';
                          }
                          if (value != _passwordController.text) {
                            return 'Password tidak cocok';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (!_showOTPField)
                  ElevatedButton(
                    onPressed: _isSendingOTP ? null : _sendOTP,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: _isSendingOTP
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.message, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Kirim OTP via WhatsApp',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                  ),
                if (_showOTPField) ...[
                  const SizedBox(height: 24),
                  Card(
                    color: AppColors.accentGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'OTP Terkirim',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kode OTP telah dikirim ke $_maskedPhone',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.green),
                          ),
                          FutureBuilder<bool>(
                            future: OTPService.canResendOTP(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data == false) {
                                return FutureBuilder<int>(
                                  future:
                                      OTPService.getResendRemainingSeconds(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          'Dapat mengirim ulang dalam ${snapshot.data} detik',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _otpFormKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _otpController,
                          hintText: 'Masukkan 6 digit OTP',
                          keyboardType: TextInputType.number,
                          validator: OTPService.validateOTP,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isVerifyingOTP ? null : _verifyOTP,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  child: _isVerifyingOTP
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Verifikasi OTP',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            FutureBuilder<bool>(
                              future: OTPService.canResendOTP(),
                              builder: (context, snapshot) {
                                final canResend = snapshot.data ?? false;

                                return ElevatedButton(
                                  onPressed: canResend && !_isSendingOTP
                                      ? _sendOTP
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: canResend
                                        ? AppColors.primary
                                        : Colors.grey,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                    child: Icon(Icons.refresh),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun?'),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
