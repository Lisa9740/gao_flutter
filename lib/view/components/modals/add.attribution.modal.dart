import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gao_flutter/providers/api/AttributionProvider.dart';
import 'package:gao_flutter/providers/api/CustomerProvider.dart';
import 'package:gao_flutter/utils/format.data.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:gao_flutter/view/components/modals/add.customer.modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


void AddAttributionModal(int hour, slots, computer, date, refreshData, connectivity, context) async {
  var _selectedCustomerId = null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _customerController = TextEditingController();

  getId(data){
    return FormatData.toArray(data)[0];
  }

  getName(data){
    var name = FormatData.toArray(data);
    return name[1] + ' ' + name[2];
  }

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
              Text('Ajouter nouvelle attribution à ${hour} h sur le ${computer["name"].toString()}'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(   child: const Icon(Icons.add),
                onPressed: () => AddCustomerModal(hour, slots, computer, date,connectivity, context)),
              Form(
                key: _formKey,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _customerController,
                      decoration: const InputDecoration(hintText: 'Nom du client'),
                      autofocus: true,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontStyle: FontStyle.italic
                      ),
                  ),
                  suggestionsCallback: (pattern) async {
                    var response;
                    response = await CustomerAPIProvider().fetchCustomer(pattern);
                    return response;
                  },
                  itemBuilder: (context, suggestion) {
                    var name = getName(suggestion);
                    return ListTile(
                      title: Text(name),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    var id = getId(suggestion);
                    _selectedCustomerId = id;
                    _customerController.text = getName(suggestion);
                  },
                 validator: (value) {
                   if (value!.isEmpty) {
                     return 'Veuillez sélectionnez un client';
                   }
                 },
                 onSaved: (value) => print(value),
                ),
              ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: Text('Ajouter attribution'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if(connectivity != ConnectivityResult.none) {
                       await AttributionAPIProvider().createAttribution(
                            date.toString(),
                            hour.toString(),
                            computer['id'].toString(),
                            _selectedCustomerId,
                            null,
                            null,
                            context);
                       refreshData();
                       Navigator.of(context).pop();
                      }
                      SendOfflineNotificationSnackBar(context);
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          ),
        ));

}
