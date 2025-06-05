import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/auth/domain/usecases/register_user.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, AuthState> {
  final RegisterUserUseCase registerUseCase;

  RegisterBloc(this.registerUseCase) : super(AuthInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await minDelayRun(registerUseCase(event.getEntity()));

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (_) => emit(AuthSuccess()),
    );
  }
}
