import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/view/components/modals/add.attribution.modal.dart';

import 'modals/remove.attribution.modal.dart';


Widget computer(BuildContext context, index,date,  _computer, refreshData) {
  final _hourSlots = [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];

  showModal(attribution, hour){
    var icon = null;
    icon = Icons.delete;
    if (attribution == null){
      icon = Icons.add_circle_outline;
      return  IconButton(
          icon: Icon(icon),
          onPressed: () async {
            if (attribution == null) {
              AddAttributionModal( hour, _hourSlots, _computer, date, refreshData, context);
            }
          });
    }

    return IconButton(
        icon: Icon(icon),
        onPressed: () async {
          RemoveAttributionModal(attribution['id'].toString() , _computer, _hourSlots[index], refreshData, context);
        });
  }

  getAttribution(_computer, hour, context){
    var attribution = null;
    var customerName = "";
    var Attributions = _computer.attributions;
    if (Attributions.length != 0) {
        Attributions[0].forEach((attr) =>
        {
          if (attr['hour'] == hour){
            attribution = attr,
            customerName = attr['Customer']['firstname'] + " " +
                attr['Customer']['lastname']
          }
        });

    }
    return Row(
        children: [
          Text(customerName),
          SizedBox(
            width: 50,
          ),
          showModal(attribution, hour)
        ]
    );
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
                                    title: Text(_hourSlots[index].toString() + ' h'),
                                    trailing: SizedBox(
                                      width: 200,
                                      child: getAttribution(_computer, _hourSlots[index], context)
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