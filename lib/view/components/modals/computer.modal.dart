// This function will be triggered when the floating button is pressed
// It will also be triggered when you want to update an item
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/controllers/local/computer.controller.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:gao_flutter/view/home.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


final TextEditingController _nameController = TextEditingController();


void showForm(int? id, _computers, refreshData, connectivity,  context ) async {
  if (id != null) {
    final existingComputer =
    _computers.firstWhere((element) => element['id'] == id);
    _nameController.text = existingComputer['name'];
  }

  showMaterialModalBottomSheet(
      context: context,
      elevation: 5,
      expand: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Nom'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  print(connectivity);
                  if(connectivity == ConnectivityResult.none) SendOfflineNotificationSnackBar(context);
                  if (id == null) {
                    await _addItem(refreshData, context);
                  }
                  if (id != null) {
                    await _updateComputer(id.toString(), refreshData, context);
                  }
                  // Clear the text fields
                  _nameController.text = '';
                  await refreshData();
                  // Close the bottom sheet
                  Navigator.of(context, rootNavigator: true).pop(context);
                },
                child: Text(id == null ? 'Ajouter nouveau poste' : 'Editer'),
              )
            ],
          ),
        ),
      )
  );
}

// Insert a new journal to the database
Future<void> _addItem(refreshData, context) async {
  await Computers.createComputer(_nameController.text, context);
  return;
}

// Update an existing journal
Future<void> _updateComputer(id, refreshData, context) async {
  await ComputerAPIProvider().updateComputer(id, _nameController.text, context);
  return;
}