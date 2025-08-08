import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/pages/view_tabs/reservation_details_tab.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/pages/view_tabs/reservation_tables_tab.dart';

class ReservationViewPage extends StatefulWidget {
  final String reservationId;

  const ReservationViewPage({
    super.key,
    required this.reservationId,
  });

  @override
  State<ReservationViewPage> createState() => _ReservationViewPageState();
}

class _ReservationViewPageState extends State<ReservationViewPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// Controls shared state between the parent and details tab.
  final _detailsTabController = ReservationDetailsTabController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _detailsTabController.displayModeNotifier.dispose();
    _detailsTabController.isCreatedByStaffNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context
        .read<ReservationDetailsBloc>()
        .add(GetReservationDetails(widget.reservationId));

    context
        .read<ReservationTablesBloc>()
        .add(GetTablesAvailability(widget.reservationId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTabBarView(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + kTextTabBarHeight),
      child: ValueListenableBuilder<ReservationFormMode>(
        valueListenable: _detailsTabController.displayModeNotifier,
        builder: (context, displayMode, _) {
          final tabBar = TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Детайли'),
              Tab(text: 'Маси'),
            ],
          );

          // When editing, lock the tab bar so the user can’t switch tabs.
          return BackLeadingAppBar(
            title: 'Резервация',
            bottom: displayMode == ReservationFormMode.edit
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kTextTabBarHeight),
                    child: AbsorbPointer(child: tabBar),
                  )
                : tabBar,
            actions: [
              _buildCreatedByStaffIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCreatedByStaffIndicator() {
    // TODO: Fix possition
    return ValueListenableBuilder<bool>(
      valueListenable: _detailsTabController.isCreatedByStaffNotifier,
      builder: (context, isCreatedByStaff, _) {
        return isCreatedByStaff
            ? Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Tooltip(
                  message: 'Създадена от служител',
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(Icons.verified_user, color: Colors.grey[400]),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildTabBarView() {
    return ValueListenableBuilder<ReservationFormMode>(
      valueListenable: _detailsTabController.displayModeNotifier,
      builder: (context, displayMode, _) {
        return TabBarView(
          controller: _tabController,
          // While editing, prevent swiping away from the details tab.
          physics: displayMode == ReservationFormMode.edit
              ? const NeverScrollableScrollPhysics()
              : null,
          children: [
            ReservationDetailsTab(
              reservationId: widget.reservationId,
              controller: _detailsTabController,
              onRefresh: _handleRefresh,
            ),
            ReservationTablesTab(
              reservationId: widget.reservationId,
              onRefresh: _handleRefresh,
            ),
          ],
        );
      },
    );
  }
}
