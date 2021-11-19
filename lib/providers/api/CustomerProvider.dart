import 'dart:convert';

import 'package:gao_flutter/models/customer.dart';
import 'package:gao_flutter/providers/api/api.conf.dart';
import 'package:http/http.dart' as http;

class CustomerAPIProvider extends ApiConf{


  Future<List<Customer>> fetchCustomer(name) async {
    final response = await http.get(
        Uri.parse(apiUrl + 'customer/search?query=' + name.toString()),
        headers: {});
    if (response.statusCode == 200) {
      List<Customer> customers = <Customer>[];
      var customerList = json.decode(response.body);

      customerList.forEach((data) async {
        customers.add(Customer.fromJson(data));
      });
      return customers;
    } else {
      throw Exception('Failed to load customers');
    }
  }
}
