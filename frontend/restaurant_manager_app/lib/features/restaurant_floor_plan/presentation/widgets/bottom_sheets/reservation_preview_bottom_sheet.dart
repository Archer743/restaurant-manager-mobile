import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/buttons/nav_button.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/coordinators/reservation_refresh_coordinator.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/reservation_preview.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_state.dart';

class ReservationPreviewBottomSheet extends StatelessWidget {
  final ReservationRefreshCoordinator coordinator;

  const ReservationPreviewBottomSheet({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationPreviewBloc, ReservationPreviewState>(
      builder: (context, state) {
        if (state is ReservationPreviewLoaded) {
          return _buildLoadedContent(state.reservationPreview);
        }

        return _buildLoadingContent();
      },
    );
  }

  Widget _buildLoadingContent() {
    return const SizedBox(
      height: 190,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildLoadedContent(ReservationPreview reservationPreview) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // top row
          _buildTopRow(reservationPreview),
          const SizedBox(height: 16),

          // bottom row
          _buildBottomRow(reservationPreview),
          const SizedBox(height: 24),

          // action button
          SizedBox(
            width: double.infinity,
            child: NavigationButton(
              label: 'Виж детайли',
              destination: '${AppRoutes.reservation}/${reservationPreview.id}',
              navigationType: NavigationType.push,
              extra: coordinator,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(ReservationPreview reservationPreview) {
    return Row(
      children: [
        // Tag chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            reservationPreview.tag,
            style: TextStyle(
              color: textColor.toColor(),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Name
        Expanded(
          child: Text(reservationPreview.name, style: defaultTextStyle),
        ),
        const SizedBox(width: 4),

        // Time
        Row(
          children: [
            const Icon(Icons.access_time, size: 18),
            const SizedBox(width: 4),
            Text(
              reservationPreview.time.toHHMMString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBottomRow(ReservationPreview reservationPreview) {
    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.people, size: 18, color: hintTextColor.toColor()),
            const SizedBox(width: 6),
            Text(
              reservationPreview.peopleCount == 1
                  ? '1 гост'
                  : '${reservationPreview.peopleCount} гости',
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Icon(Icons.table_restaurant_sharp,
                size: 18, color: hintTextColor.toColor()),
            const SizedBox(width: 6),
            Text(
              reservationPreview.tableCount == 1
                  ? '1 маса'
                  : '${reservationPreview.tableCount} маси',
            ),
          ],
        )
      ],
    );
  }
}
