import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum NavigationType { go, push }

class NavigationButton extends StatelessWidget {
  final String label;
  final NavigationType navigationType;
  final String destination;
  final Object? extra;

  const NavigationButton({
    super.key,
    required this.label,
    required this.destination,
    this.navigationType = NavigationType.go,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        switch (navigationType) {
          case NavigationType.go:
            context.go(destination, extra: extra);
            break;
          case NavigationType.push:
            context.push(destination, extra: extra);
            break;
        }
      },
      child: Text(label),
    );
  }
}
