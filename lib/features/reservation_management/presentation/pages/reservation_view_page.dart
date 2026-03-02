import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import '../../domain/entities/reservation_form_mode.dart';
import '../bloc/view/reservation_view_bloc.dart';
import '../bloc/view/reservation_view_event.dart';
import '../bloc/tables/reservation_tables_bloc.dart';
import '../bloc/tables/reservation_tables_event.dart';
import '../pages/view_tabs/reservation_details_tab.dart';
import '../pages/view_tabs/reservation_tables_tab.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: Refresh all related screens
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context
        .read<ReservationViewBloc>()
        .add(GetReservation(widget.reservationId));

    context
        .read<ReservationTablesBloc>()
        .add(GetTablesAvailability(widget.reservationId));
  }

  @override
  Widget build(BuildContext context) {
    // The scaffold will only be rebuilt if these fields are changed
    final displayMode =
        context.select((ReservationViewBloc bloc) => bloc.state.displayMode);
    final tag = context
        .select((ReservationViewBloc bloc) => bloc.state.reservation?.tag);
    final isClosed = context
        .select((ReservationViewBloc bloc) => bloc.state.reservation?.isClosed);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.read<ReservationViewBloc>().add(CommitReservationChanges());
      },
      child: Scaffold(
        appBar: _buildAppBar(tag, isClosed, displayMode),
        body: _buildTabBarView(displayMode),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      String? tag, bool? isClosed, ReservationFormMode displayMode) {
    final tabBar = TabBar(
      controller: _tabController,
      tabs: const [Tab(text: 'Детайли'), Tab(text: 'Маси')],
    );

    final tagText = tag ?? 'Резервация';
    final title = displayMode.isView ? tagText : 'Редакция';

    return BackLeadingAppBar(
      title: title,
      bottom: displayMode.isEdit
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight),
              child: AbsorbPointer(child: tabBar),
            )
          : tabBar,
      actions: [
        if (isClosed != null)
          Padding(
            // Match the default padding of the leading IconButton
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              isClosed ? "Приключена" : "Активна",
              style: TextStyle(
                color: isClosed ? successColor : actionColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
      ],
    );
  }

  Widget _buildTabBarView(ReservationFormMode displayMode) {
    return TabBarView(
      controller: _tabController,
      // While editing, prevent swiping away from the details tab.
      physics: displayMode.isEdit ? const NeverScrollableScrollPhysics() : null,
      children: [
        ReservationDetailsTab(
            reservationId: widget.reservationId, onRefresh: _handleRefresh),
        ReservationTablesTab(
            reservationId: widget.reservationId, onRefresh: _handleRefresh),
      ],
    );
  }
}
