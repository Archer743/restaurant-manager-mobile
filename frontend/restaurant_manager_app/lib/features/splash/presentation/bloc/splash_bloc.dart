import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/usecase/usecase.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/splash/domain/usecases/check_auth_status.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_event.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAuthStatusUseCase authUseCase;

  SplashBloc(this.authUseCase) : super(SplashInitial()) {
    on<CheckAuthEvent>((event, emit) async {
      emit(SplashLoading());

      final status = await minDelayRun(authUseCase(NoParams()));
      emit(SplashLoaded(status));
    });
  }
}
