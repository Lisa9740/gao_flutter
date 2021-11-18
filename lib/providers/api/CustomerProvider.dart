import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gao_flutter/models/customer.dart';
import 'package:http/http.dart' as http;

final String apiUrl = dotenv.env['API_URL'].toString();

class CustomerAPIProvider {

  //Fetch a user with the username supplied in the form input
  Future<List<Customer>> fetchCustomer(name) async {
    final response = await http.get(
        Uri.parse(apiUrl + 'customer/search?query=' + name.toString()),
        headers: {});
    if (response.statusCode == 200) {
      List<Customer> customers = <Customer>[];
      var customerList = json.decode(response.body);

      // computerList.map((data) => computers.add(Computer.fromJson(data)));
      customerList.forEach((data) async {
        customers.add(Customer.fromJson(data));
      });

      return customers;
    } else {
      throw Exception('Failed to load customers');
    }
  }
}
