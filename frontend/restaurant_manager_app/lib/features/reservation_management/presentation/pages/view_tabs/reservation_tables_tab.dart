import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_state.dart';

class ReservationTablesTab extends StatefulWidget {
  final String reservationId;

  const ReservationTablesTab({
    super.key,
    required this.reservationId,
  });

  @override
  State<ReservationTablesTab> createState() => _ReservationTablesTabState();
}

class _ReservationTablesTabState extends State<ReservationTablesTab>
    with AutomaticKeepAliveClientMixin {
  // By switching tabs unactive tabs are disposed by default.
  // AutomaticKeepAliveClientMixin prevents that
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    return BlocConsumer<ReservationTablesBloc, ReservationTablesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return const Text('Body');
      },
    );
  }
}
