import 'dart:convert';
import 'package:gao_flutter/conf/api.dart';
import 'package:gao_flutter/database/sync.local.db.dart';
import 'package:gao_flutter/models/computer.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ComputerAPIProvider extends ApiConf {
  fetchPageSize() async {
    final response = await http.get(Uri.parse(apiUrl + 'computers/size'), headers: {});
    return response.body;
  }


  syncAllData(date) async{
    final pageSize = await fetchPageSize();
    var response;
    int i = 1;
    while(i <= int.parse(pageSize)){
      response = await http.get(Uri.parse(apiUrl + 'computers?date=' + date.toString() + '&page=' + i.toString()), headers: {});
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        jsonResponse.forEach((data) async {
          LocalDatabase.sync(Computer.fromJson(data));
        });
        i++;
      } else {
        throw Exception('Failed to load computers');
      }
    }

  }


  Future<List> fetchComputer(date, page, connectionStatus) async {
    syncAllData(date);
    var response = await http.get(Uri.parse(apiUrl + 'computers?date=' + date.toString() + '&page=' + page.toString()), headers: {});

    List computers = [];
    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse.forEach((data) async {
        computers.add(data);
      });
    }else {
      throw Exception('Failed to load computers');
    }
    return computers;
  }


  createComputer(name, context) async{
    final response =  await http.post(Uri.parse(apiUrl + 'computer/create'), body: {'name': name});
    if (response.statusCode != 200){
      return SendErrorNotificationSnackBar(context);
    }
    return SendNotificationSnackBar('Poste ajouté avec succès !', context);
  }

  updateComputer(id, name, context) async{
    final response = await http.post(Uri.parse(apiUrl + 'computer/edit'), body: {'id': id ,'name': name});
    print(response.statusCode);

    if (response.statusCode != 200){
      return SendErrorNotificationSnackBar(context);
    }
    return SendNotificationSnackBar('Poste modifié avec succès !', context);
  }

  deleteComputer(id, context) async{
    final response =  await http.post(Uri.parse(apiUrl + 'computer/remove'), body: {'id': id.toString()});
    if (response.statusCode != 200){
      return SendErrorNotificationSnackBar(context);
    }
    return SendNotificationSnackBar('Poste supprimé avec succès !', context);
  }

}