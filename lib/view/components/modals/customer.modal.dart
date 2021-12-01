import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/providers/api/AttributionProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void CustomerModal(int hour, computer, date, context) async {
  var _selectedCustomerId = null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();

  formatDataToArray(str){
    var formattedStr = str.toString();
    return formattedStr.split(' ').map((String test) => test).toList();
  }

  getId(data){
    return formatDataToArray(data)[0];
  }

  getName(data){
    var name = formatDataToArray(data);
    return name[1] + ' ' + name[2];
  }

 // final slot = slots.firstWhere((element) => element == hour);

  showMaterialModalBottomSheet(
      context: context,
      expand: true,
      elevation: 5,
      builder: (_) => Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text('Ajouter nouvelle attribution à ${hour} h sur le ${computer.name.toString()}'),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _firstnameController,
                decoration: const InputDecoration(hintText: 'Prénom'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _lastnameController,
                decoration: const InputDecoration(hintText: 'Nom'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Text('Ajouter attribution'),
                onPressed: () {
                    AttributionAPIProvider().createAttribution(date.toString(), hour.toString(), computer.id.toString(), null, _firstnameController.text, _lastnameController.text,   context);
                    Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ));

}
