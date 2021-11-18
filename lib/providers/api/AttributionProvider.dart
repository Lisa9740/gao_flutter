
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:http/http.dart' as http;

import 'api.conf.dart';

class AttributionAPIProvider extends ApiConf {

  createAttribution(date, hour, computerId, customerId, context) async{
    final response =  await http.post(Uri.parse(apiUrl + 'attribution/create'), body: {'date': date, 'hour': hour, 'computerId': computerId, 'customerId': customerId});

    if (response.statusCode != 200){
      return SendNotificationSnackBar('Une erreur est survenue', context);
    }
    return SendNotificationSnackBar('Attribution ajouté avec succès !', context);
  }
}