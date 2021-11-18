import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gao_flutter/providers/api/CustomerProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void AttributionModal(int index, slots, computer, context) async {
  int _selectedCustomerId = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _customerController = TextEditingController();
    if (index != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final slot = slots.firstWhere((element) => element == index);
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
                Text('Ajouter nouvelle attribution à ${index} h sur le ${computer.name.toString()}'),
                const SizedBox(
                  height: 30,
                ),

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
                    return await CustomerAPIProvider().fetchCustomer(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _customerController.text = suggestion.toString();
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Your Favorite City is ${_selectedCustomerId}')
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ));

}