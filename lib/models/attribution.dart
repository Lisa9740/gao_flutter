import 'package:gao_flutter/models/customer.dart';


class Attribution {
  var customer;

  Attribution({
    required this.id,
    required this.hour,
    required this.date,
    required this.customer
  });

  final int id;
  final int hour;
  final String date;


  //creating a dart user object from the json object
  factory Attribution.fromJson(Map<String, dynamic> json) {
    return Attribution( id: json["id"], hour : json['hour'], date : json['date'], customer : json['Customer']);
  }


/* @override

  String toString() {
    return '$firstname $lastname';
  }*/
}