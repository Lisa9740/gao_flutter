import 'dart:convert';
import 'package:gao_flutter/database/local.database.dart';
import 'package:gao_flutter/models/computer.dart';
import 'package:gao_flutter/providers/api/api.conf.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:http/http.dart' as http;


class ComputerAPIProvider extends ApiConf {

  Future<List<Computer>> fetchComputer(date, page) async {
    final response = await http.get(Uri.parse(apiUrl + 'computers?date='+ date.toString() +'&page=' + page.toString()), headers: {});
    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      List<Computer> computers = <Computer>[];
      jsonResponse.forEach((data) async {
        LocalDatabase.sync(Computer.fromJson(data));
        computers.add(Computer.fromJson(data));
      });
      return computers;
    } else {
      throw Exception('Failed to load computers');
    }
  }

  fetchPageSize() async {
    final response = await http.get(Uri.parse(apiUrl + 'computers/size'), headers: {});
    print(response.body);
    return response.body.toString();
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