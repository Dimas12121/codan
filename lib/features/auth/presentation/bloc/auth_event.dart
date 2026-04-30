import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;
  const AuthRegisterRequested(this.name, this.email, this.password, this.phone, {this.role = 'buyer'});
  @override
  List<Object?> get props => [name, email, password, phone, role];
}

class AuthRegisterWithPhoneRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  const AuthRegisterWithPhoneRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.role = 'buyer',
  });
  @override
  List<Object?> get props => [name, email, phone, password, role];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthLoginPhoneRequested extends AuthEvent {
  final String phone;
  final String otp;
  const AuthLoginPhoneRequested(this.phone, this.otp);
  @override
  List<Object?> get props => [phone, otp];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final Map<String, dynamic> data;
  const AuthUpdateProfileRequested(this.data);
  @override
  List<Object?> get props => [data];
}
