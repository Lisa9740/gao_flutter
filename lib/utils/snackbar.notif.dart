import 'package:flutter/material.dart';

SendNotificationSnackBar(message, context) async{
  return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}