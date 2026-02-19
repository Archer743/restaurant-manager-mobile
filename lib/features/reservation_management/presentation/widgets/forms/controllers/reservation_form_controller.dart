import 'package:flutter/material.dart';
import '../../../../domain/requests/create_reservation_request.dart';

class ReservationFormController {
  final name = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final peopleCount = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final comment = TextEditingController();

  void dispose() {
    name.dispose();
    date.dispose();
    time.dispose();
    peopleCount.dispose();
    email.dispose();
    phone.dispose();
    comment.dispose();
  }

  CreateReservationRequest getRequest() {
    return CreateReservationRequest(
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
