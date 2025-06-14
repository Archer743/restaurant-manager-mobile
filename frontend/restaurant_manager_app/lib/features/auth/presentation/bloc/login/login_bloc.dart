import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_event.dart';

class LoginBloc extends Bloc<LoginEvent, AuthState> {
  final LoginUserUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await minDelayRun(_loginUseCase(event.getEntity()));

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (_) => emit(AuthSuccess()),
    );
  }
}
