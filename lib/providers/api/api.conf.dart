import 'package:gao_flutter/controllers/attribution.controller.dart';
import 'package:gao_flutter/database/database.sync.dart';
import 'package:gao_flutter/database/sql_helper.dart';


class ApiConf {
  final String apiUrl = "http://gao-nodejs.barret-alison-dev.xyz/api/";

  syncApiToLocalDatabase(data) async {
    await DataBaseSync().sync(data);
  }

}