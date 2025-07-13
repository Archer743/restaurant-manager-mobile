import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/pages/view_tabs/reservation_details_tab.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

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

  /// Current mode: view or edit.
  ReservationFormMode _displayMode = ReservationFormMode.view;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTabBarView(),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      // While editing, prevent swiping away from the details tab.
      physics: (_displayMode == ReservationFormMode.edit &&
              _tabController.index == 0)
          ? const NeverScrollableScrollPhysics()
          : null,
      children: [
        ReservationDetailsTab(
          reservationId: widget.reservationId,
          controller: _detailsTabController,
          displayMode: _displayMode,
        ),
        const Scaffold(
          body: Center(child: Text("Таб 2")),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return BackLeadingAppBar(
      title: 'Резервация',
      bottom: _buildTabBar(),
      actions: [
        _buildCreatedByStaffIndicator(),
        _buildEditActionButton(),
      ],
    );
  }

  PreferredSizeWidget _buildTabBar() {
    final tabBar = TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Детайли'),
        Tab(text: 'Маси'),
      ],
    );

    // When editing, lock the tab bar so the user can’t switch tabs.
    return _displayMode == ReservationFormMode.edit
        ? PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight),
            child: AbsorbPointer(child: tabBar),
          )
        : tabBar;
  }

  Widget _buildCreatedByStaffIndicator() {
    return ValueListenableBuilder<bool>(
      valueListenable: _detailsTabController.isCreatedByStaffNotifier,
      builder: (context, isCreatedByStaff, _) {
        return isCreatedByStaff
            ? Tooltip(
                message: 'Създадена от служител',
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.verified_user, color: Colors.grey[400]),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildEditActionButton() {
    // If reservation is not loaded yet the icon button will be deactivated
    return ValueListenableBuilder<bool>(
      valueListenable: _detailsTabController.isReservationLoadedNotifier,
      builder: (context, isLoaded, _) {
        final bool isViewModeActive = _displayMode == ReservationFormMode.view;

        return IconButton(
          icon: Icon(isViewModeActive ? Icons.edit : Icons.check),
          tooltip: isViewModeActive ? 'Редакция' : 'Готово',
          onPressed: isLoaded
              ? () {
                  // Always go back to details tab before editing.
                  if (_tabController.index != 0) {
                    _tabController.animateTo(0);
                  }

                  if (isViewModeActive) {
                    setState(() => _displayMode = ReservationFormMode.edit);
                  } else {
                    final isFormValid = _detailsTabController.submit();
                    if (isFormValid) {
                      setState(() => _displayMode = ReservationFormMode.view);
                    }
                  }
                }
              : null,
        );
      },
    );
  }
}
