import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import '../../../../domain/requests/reservation_request.dart';

class ReservationFormController {
  final name = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final peopleCount = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final comment = TextEditingController();

  void set(ReservationView reservation) {
    name.text = reservation.name;
    peopleCount.text = reservation.peopleCount.toString();
    email.text = reservation.email ?? '';
    phone.text = reservation.phone ?? '';
    comment.text = reservation.comment ?? '';

    final (localDate, localTime) =
        extractLocalComponentsFromUtc(reservation.startUtc);

    date.text = localDate.toYYYYMMDDString();
    time.text = localTime.toHHMMSSString();
  }

  void addListener(void Function() listener) {
    name.addListener(listener);
    peopleCount.addListener(listener);
    email.addListener(listener);
    phone.addListener(listener);
    comment.addListener(listener);
    date.addListener(listener);
    time.addListener(listener);
  }

  void dispose() {
    name.dispose();
    date.dispose();
    time.dispose();
    peopleCount.dispose();
    email.dispose();
    phone.dispose();
    comment.dispose();
  }

  ReservationRequest getRequest() {
    return ReservationRequest(
      name: name.text,
      email: email.text,
      phone: phone.text,
      dateString: date.text,
      timeString: time.text,
      peopleCountString: peopleCount.text,
      comment: comment.text,
    );
  }
}
