import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/controllers/computers.controller.dart';



Widget computer(BuildContext context, index, _computers) {
  final _hourSlots = [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
  final TextEditingController _customerController = TextEditingController();


  void _showForm(int? index) async {
    if (index != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final slot = _hourSlots.firstWhere((element) => element == index);
    }


    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _customerController,
                  decoration: const InputDecoration(hintText: 'Nom du client'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Save new journal
                  /*  if (index == null) {
                      await _addItem();
                    }

                    if (index != null) {
                      await _updateComputer(id);
                    }*/

                    // Clear the text fields
                    _customerController.text = '';

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ajouter'),
                )
              ],
            ),
          ),
        ));
  }


  return
        Card(
            color: Colors.orange[200],
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  height: 500.0,
                  child:
                  ListView.builder(
                      itemCount: _hourSlots.length,
                      itemBuilder: (context, index) =>
                          Column(
                            children: [
                              const Divider(
                                thickness: 1.0,
                                height: 1.0,
                              ),
                              SizedBox(
                                height: 80,
                                child: ListTile(
                                    title: Text(_hourSlots[index].toString()),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline),
                                            onPressed: () {
                                              _showForm(_hourSlots[index]);
                                            },
                                          ),
                                        ],
                                      ),
                                    )) ,
                              ),
                            ],
                          )
                  ),
                )
              ],
            )

        );

}