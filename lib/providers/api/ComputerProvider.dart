import 'dart:convert';
import 'package:gao_flutter/models/computer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL'].toString();


class ComputerProvider {


  //Fetch a user with the username supplied in the form input
  Future<List<Computer>> fetchComputer(date, page) async {
    final response = await http.get(Uri.parse(apiUrl + 'computers?date='+ date.toString() +'&page=' + page.toString()), headers: {});
    if (response.statusCode == 200) {
      List<Computer> computers = <Computer>[];
      var computerList = json.decode(response.body);

     // computerList.map((data) => computers.add(Computer.fromJson(data)));
     computerList.forEach((data) async {
        print(data);
        computers.add(Computer.fromJson(data));
      });

      print({computers});
      return computers;
    } else {
      throw Exception('Failed to load book computers');
    }
  }
}