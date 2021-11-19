import 'dart:convert';

import 'package:gao_flutter/utils/shared_pref.dart';
import 'api.conf.dart';
import 'package:http/http.dart' as http;


class AuthAPIProvider extends ApiConf {

  login(email, password) async {
    final response = await http.post(Uri.parse(apiUrl + "/login"), body: {'email': email, 'password' : password});
    var jsonResponse = json.decode(response.body);
    sharedPref().save("token", jsonResponse['token']);
    return jsonResponse['success'];
  }


}