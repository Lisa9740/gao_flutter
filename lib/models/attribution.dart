import 'package:gao_flutter/models/customer.dart';


class Attribution {

  const Attribution({
    required this.id,
    required this.hour,
    required this.date,
    required this.customer
  });

  final int id;
  final int hour;
  final String date;
  final Customer customer;

 /* @override
  String toString() {
    return '$firstname $lastname';
  }*/
}