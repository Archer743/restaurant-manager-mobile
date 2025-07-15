import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/tables/table_card.dart';

class TablesGrid extends StatelessWidget {
  final List<TableAvailability> tables;
  final void Function(TableAvailability) onTableTap;

  const TablesGrid({
    super.key,
    required this.tables,
    required this.onTableTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        return TableCard(table: tables[index], onTableTap: onTableTap);
      },
    );
  }
}
