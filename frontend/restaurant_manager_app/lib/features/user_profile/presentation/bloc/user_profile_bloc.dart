import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/entities/user_profile_view.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/usecases/get_curr_user_profile_usecase.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/usecases/logout_usecase.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/bloc/user_profile_event.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/bloc/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetCurrUserProfileUseCase _currUserProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  UserProfileBloc(this._currUserProfileUseCase, this._logoutUseCase)
      : super(UserProfileInitial()) {
    on<GetCurrUserProfile>(_onGetCurrUserProfile);
    on<Logout>(_onLogout);
  }

  Future<void> _onGetCurrUserProfile(
      GetCurrUserProfile event, Emitter<UserProfileState> emit) async {
    final currState = state;
    UserProfileView? originalProfile;

    if (currState is UserProfileLoaded) {
      originalProfile = currState.profile;
    } else if (currState is UserProfileError) {
      originalProfile = currState.profile;
    }

    emit(UserProfileLoading());

    final result = await minDelayRun(_currUserProfileUseCase(NoParams()));

    result.fold(
      (failure) => emit(
        UserProfileError(failure: failure, profile: originalProfile),
      ),
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }

  Future<void> _onLogout(Logout event, Emitter<UserProfileState> emit) async {
    final currState = state;
    UserProfileView? originalProfile;

    if (currState is UserProfileLoaded) {
      originalProfile = currState.profile;
    } else if (currState is UserProfileError) {
      originalProfile = currState.profile;
    }

    emit(UserProfileLoading());

    final result = await minDelayRun(_logoutUseCase(NoParams()));

    result.fold(
      (failure) => emit(
        UserProfileError(failure: failure, profile: originalProfile),
      ),
      (profile) => emit(LogoutSuccess()),
    );
  }
}
