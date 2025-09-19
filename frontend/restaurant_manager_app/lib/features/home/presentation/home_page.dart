import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/pages/confirmed_reservations_calendar_page.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/bloc/pending_inbox_bloc.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/bloc/pending_inbox_event.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/pages/pending_reservations_inbox_page.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/pages/restaurant_floor_plan_page.dart';
import 'package:restaurant_manager_app/injection_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 1);
  int _currIndex = 1;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      BlocProvider<CalendarBloc>(
        create: (_) => sl(),
        child: const ConfirmedReservationsCalendarPage(),
      ),
      BlocProvider<FloorPlanBloc>(
        create: (_) => sl(),
        child: const RestaurantFloorPlanPage(),
      ),
      BlocProvider<PendingInboxBloc>(
        create: (_) => sl()..add(GetPendingReservations()),
        child: const PendingReservationsInboxPage(),
      ),
      const Scaffold(
          body: Center(child: Text("4: Logs (Staff Activity History)"))),
      const Scaffold(body: Center(child: Text("5: Profile"))),
    ];
  }

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
          NavigationDestination(icon: Icon(Icons.event_note), label: ''),
          NavigationDestination(
              icon: Icon(Icons.table_restaurant_sharp), label: ''),
          NavigationDestination(icon: Icon(Icons.check_circle), label: ''),
          NavigationDestination(icon: Icon(Icons.history), label: ''),
          NavigationDestination(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
