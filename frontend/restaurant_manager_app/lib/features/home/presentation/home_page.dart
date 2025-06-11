import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 1);
  int _currIndex = 1;

  final List<Widget> _pages = const [
    WelcomePage(),
    WelcomePage(),
    WelcomePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() => _currIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currIndex,
        onDestinationSelected: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(microseconds: 500),
            curve: Curves.ease,
          );
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined), label: "Library"),
          NavigationDestination(
              icon: Icon(Icons.search_outlined), label: "Search"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Profile")
        ],
      ),
    );
  }
}
