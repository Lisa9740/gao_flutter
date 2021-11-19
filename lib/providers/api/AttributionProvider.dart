
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:http/http.dart' as http;

import 'api.conf.dart';

class AttributionAPIProvider extends ApiConf {

  createAttribution(date, hour, computerId, customerId, String? firstname, String? lastname, context) async{
    var customerToCreate = { 'date': date, 'hour': hour, 'computerId': computerId,  'lastname' : lastname, 'firstname' : firstname};
    var dataToSend =   { 'date': date, 'hour': hour, 'computerId': computerId, 'customerId': customerId };

    if (customerId == null){
        dataToSend = customerToCreate;
    }
    final response =  await http.post(Uri.parse(apiUrl + 'attribution/create'),
        body: dataToSend);

    if (response.statusCode != 200){
      return SendNotificationSnackBar('Une erreur est survenue', context);
    }
    return SendNotificationSnackBar('Attribution ajouté avec succès !', context);
  }

   removeAttribution(id, context) async {
     final response =  await http.post(Uri.parse(apiUrl + 'attribution/remove'), body: {'id': id });
     if (response.statusCode != 200){
       return SendNotificationSnackBar('Une erreur est survenue', context);
     }
     return SendNotificationSnackBar('Attribution supprimé avec succès !', context);
   }

}