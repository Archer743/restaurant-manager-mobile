import 'package:restaurant_manager_app/core/errors/failure.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final Failure failure;
  AuthFailure(this.failure);
}
