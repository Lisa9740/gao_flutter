import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


void RemoveComputerModal(id, computer, refreshData, connectivity, context) async {
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
              Text('Etes-vous sûr de supprimer le ${computer['name'].toString()} ?'),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text('Supprimer'),
                    onPressed: () async {
                      if(connectivity != ConnectivityResult.none) {
                        await ComputerAPIProvider().deleteComputer(id, context);
                        refreshData();
                        Navigator.of(context).pop();
                      }
                      SendOfflineNotificationSnackBar(context);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ));

}
