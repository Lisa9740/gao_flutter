import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gao_flutter/models/computer.dart';
import 'package:gao_flutter/providers/api/api.conf.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:http/http.dart' as http;



class ComputerAPIProvider extends ApiConf {

  //Fetch a user with the username supplied in the form input
  Future<List<Computer>> fetchComputer(date, page) async {
    final response = await http.get(Uri.parse(apiUrl + 'computers?date='+ date.toString() +'&page=' + page.toString()), headers: {});
    if (response.statusCode == 200) {
      List<Computer> computers = <Computer>[];
      var computerList = json.decode(response.body);

      print(response.body);

     // computerList.map((data) => computers.add(Computer.fromJson(data)));
     computerList.forEach((data) async {
        computers.add(Computer.fromJson(data));
      });

      return computers;
    } else {
      throw Exception('Failed to load computers');
    }
  }

  createComputer(name, context) async{
    final response =  await http.post(Uri.parse(apiUrl + 'computer/create'), body: {'name': name});

    if (response.statusCode != 200){
      return SendNotificationSnackBar('Une erreur est survenue', context);
    }
    return SendNotificationSnackBar('Poste ajouté avec succès !', context);
  }

  updateComputer(id, name, context) async{
    final response = await http.post(Uri.parse(apiUrl + 'computer/edit'), body: {'id': id ,'name': name});
    print(response.statusCode);

    if (response.statusCode != 200){
      return SendNotificationSnackBar('Une erreur est survenue', context);
    }
    return SendNotificationSnackBar('Poste modifié avec succès !', context);
  }

  deleteComputer(id, context) async{
    final response =  await http.post(Uri.parse(apiUrl + 'computer/remove'), body: {'id': id.toString()});
    if (response.statusCode != 200){
      return SendNotificationSnackBar('Une erreur est survenue', context);
    }
    return SendNotificationSnackBar('Poste supprimé avec succès !', context);
  }

}