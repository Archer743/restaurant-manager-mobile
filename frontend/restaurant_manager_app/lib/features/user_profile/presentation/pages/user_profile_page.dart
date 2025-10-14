import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/app_refresh_indicator.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/entities/user_profile_view.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/bloc/user_profile_event.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/bloc/user_profile_state.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/widgets/buttons/profile_actions_menu.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/widgets/forms/user_profile_form.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _displayMode = UserProfileFormMode.view;

  final _usernameController = TextEditingController();
  final _roleNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _roleNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  bool _isProfileAvailable(UserProfileState state) {
    return state is UserProfileLoaded ||
        (state is UserProfileError && state.hasProfile());
  }

  void _setControllers(UserProfileView profile) {
    _usernameController.text = profile.username;
    _roleNameController.text = profile.roleName;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
  }

  void _handleUserProfileStateChanges(
      BuildContext context, UserProfileState state) {
    if (state is UserProfileLoaded) {
      setState(() => _setControllers(state.profile));
    } else if (state is LogoutSuccess) {
      SnackBarService.showSuccess(context, "Излязохте от акаунта си успешно.");
      context.go(AppRoutes.welcome);
    } else if (state is UserProfileError) {
      if (state.hasProfile()) {
        setState(() => _setControllers(state.profile!));
      }

      SnackBarService.showFailure(context, state.failure);

      if (state.failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Потребителски профил')),
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: _handleUserProfileStateChanges,
        builder: (context, state) {
          return AppRefreshIndicator(
            onRefresh: () async {
              context.read<UserProfileBloc>().add(GetCurrUserProfile());
            },
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildBodyContent(state),
                  ),
                ),
                if (_isProfileAvailable(state)) ...[
                  Positioned(top: 6, right: 6, child: _buildActions()),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBodyContent(UserProfileState state) {
    if (_isProfileAvailable(state)) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(45, 0, 45, 16),
        child: UserProfileForm(
          formKey: _formKey,
          displayMode: _displayMode,
          usernameController: _usernameController,
          roleNameController: _roleNameController,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
        ),
      );
    }

    // Loading and error state
    return const CircularProgressIndicator();
  }

  Widget _buildActions() {
    return ProfileActionsMenu(
      onLogout: () {
        context.read<UserProfileBloc>().add(Logout());
      },
    );
  }
}
