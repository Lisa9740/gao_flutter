import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gao_flutter/models/computer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL'].toString();


class ComputerAPIProvider {

  //Fetch a user with the username supplied in the form input
  Future<List<Computer>> fetchComputer(date, page) async {
    final response = await http.get(Uri.parse(apiUrl + 'computers?date='+ date.toString() +'&page=' + page.toString()), headers: {});
    if (response.statusCode == 200) {
      List<Computer> computers = <Computer>[];
      var computerList = json.decode(response.body);

     // computerList.map((data) => computers.add(Computer.fromJson(data)));
     computerList.forEach((data) async {
        computers.add(Computer.fromJson(data));
      });

      return computers;
    } else {
      throw Exception('Failed to load book computers');
    }
  }

  createComputer(name, context) async{
    final response =  await http.post(Uri.parse(apiUrl + 'computer/create'), body: {'name': name});

    if (response.statusCode != 200){
      return sendMessageSnackbar('Une erreur est survenue', context);
    }
    return {'message' :'Une erreur est survenue !'};
  }

  updateComputer(id, name, context) async{
    final response = await http.post(Uri.parse(apiUrl + 'computer/edit'), body: {'id': id ,'name': name});
    print(response.statusCode);

    if (response.statusCode != 200){
      return sendMessageSnackbar('Une erreur est survenue', context);
    }
    return sendMessageSnackbar('Poste modifié avec succès !', context);
  }

  deleteComputer(id, context) async{
    final response =  await http.post(Uri.parse(apiUrl + 'computer/remove'), body: {'id': id.toString()});
    if (response.statusCode != 200){
      return sendMessageSnackbar('Une erreur est survenue', context);
    }
    return sendMessageSnackbar('Poste supprimé avec succès !', context);
  }


  sendMessageSnackbar(message, context) async{
    return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}