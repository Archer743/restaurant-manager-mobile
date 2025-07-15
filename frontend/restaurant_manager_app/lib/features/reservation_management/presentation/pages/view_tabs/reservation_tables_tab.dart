import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/shift_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/tables/tables_grid.dart';

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
      listener: (context, state) {
        if (state is ReservationTablesError) {
          SnackBarService.showFailure(context, state.failure);

          if (state.failure.requiresReauthentication) {
            context.go(AppRoutes.welcome);
          }
        }
      },
      builder: (context, state) {
        if (state is ReservationTablesLoaded) {
          final shift = state.shiftView;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildShiftInfoBlock(context, shift),
                    const SizedBox(height: 24.0),
                    TablesGrid(
                      tables: shift.tables,
                      onTableTap: (table) {
                        debugPrint("\n${table.tableNumber} was clicked!\n");
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildShiftInfoBlock(BuildContext context, ShiftView shift) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Центрираме съдържанието
      children: [
        Text(
          shift.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(width: 10.0),

        // Разделител
        // Container(
        //   width: 1, // Тънка вертикална линия
        //   height: 20, // Височина на линията
        //   color: hintTextColor.toColor().withOpacity(0.5),
        // ),
        // const SizedBox(width: 10.0),

        // Часови диапазон (по-малък, но ясен)
        Text(
          '${shift.startTime.toHHMMString()} - ${shift.endTime.toHHMMString()}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: hintTextColor.toColor(),
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
