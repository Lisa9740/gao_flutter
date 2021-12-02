import 'package:flutter/material.dart';

SendNotificationSnackBar(message, context) async{
  return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

SendOfflineNotificationSnackBar(context) async{
  return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Veuillez vous connectez à Internet afin d\'effectuer une modification.'),
  ));
}

SendErrorNotificationSnackBar(context) async{
  return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Une erreur est survenue.'),
  ));
}