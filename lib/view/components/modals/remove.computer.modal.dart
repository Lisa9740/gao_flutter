import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


void RemoveComputerModal(id, computer, context) async {
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
              Text('Etes-vous sûr de supprimer le ${computer.name.toString()} ?'),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text('Supprimer'),
                    onPressed: () async {
                      await ComputerAPIProvider().deleteComputer(id, context);
                      Navigator.of(context).pop();
                    },
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
