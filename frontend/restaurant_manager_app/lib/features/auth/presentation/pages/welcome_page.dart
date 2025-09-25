import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/buttons/nav_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/taverna-izbata-logo.png',
                height: spacingByHeight(context, 0.2),
              ),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const NavigationButton(label: 'Вход', destination: AppRoutes.login),
          SizedBox(height: spacingByHeight(context, 0.03)),
          const NavigationButton(
              label: 'Регистрация', destination: AppRoutes.register),
        ],
      );
}
