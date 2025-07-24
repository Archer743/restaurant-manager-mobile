class ReservationTablesUpdate {
  final List<String> tablesToAdd;
  final List<String> tablesToRemove;

  ReservationTablesUpdate({
    required this.tablesToAdd,
    required this.tablesToRemove,
  });
}
