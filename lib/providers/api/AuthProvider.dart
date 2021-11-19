import 'dart:convert';

import 'package:gao_flutter/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.conf.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:http/http.dart' as http;


class AuthAPIProvider extends ApiConf {

  login(email, password) async {
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(apiUrl + "/login"), body: {'email': email, 'password' : password});
    var jsonResponse = json.decode(response.body);

    print(jsonResponse);

    sharedPref().save("token", jsonResponse['token']);
    //sharedPreferences.setString("token", jsonResponse['token']);
    return jsonResponse['success'];
  }


}