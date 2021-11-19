import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/providers/api/AttributionProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


void RemoveAttributionModal(id, computer, hour, refreshData, context) async {

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
              Text('Etes-vous sûr d\'annuler l\'attribution à ${hour} h de ${computer.name.toString()} ?'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: Text('Supprimer'),
                onPressed: () {
                    AttributionAPIProvider().removeAttribution(id, context);
                    refreshData();
                    Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ));

}
