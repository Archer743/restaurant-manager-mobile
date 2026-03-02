enum ReservationFormMode {
  view,
  edit,
  create;

  bool get isView => this == ReservationFormMode.view;
  bool get isEdit => this == ReservationFormMode.edit;
  bool get isCreate => this == ReservationFormMode.create;
}
