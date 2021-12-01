import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/controllers/attribution.controller.dart';
import 'package:gao_flutter/controllers/customer.controller.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:gao_flutter/view/components/modals/add.attribution.modal.dart';

import 'modals/remove.attribution.modal.dart';


Widget computer(BuildContext context, index,date,  _computer, _attributions, connectivity, refreshData) {
  final _hourSlots = [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
  var attributions = [];

  showModal(attribution, hour){
    var icon = null;
    icon = Icons.delete;
    if (attribution == null){
      icon = Icons.add_circle_outline;
      return  IconButton(
          icon: Icon(icon),
          onPressed: () async {
            if (attribution == null) {

              if(connectivity != ConnectivityResult.none) {
                AddAttributionModal(
                    hour,
                    _hourSlots,
                    _computer,
                    date,
                    refreshData,
                    connectivity,
                    context);
              }
              SendOfflineNotificationSnackBar(context);

            }
          });
    }

    return IconButton(
        icon: Icon(icon),
        onPressed: () async {
          if(connectivity != ConnectivityResult.none) {
            RemoveAttributionModal(
                attribution['id'].toString(), _computer, _hourSlots[index],
                refreshData, connectivity, context);
          }
          SendOfflineNotificationSnackBar(context);
          });
  }

  Future<List> getAttributions(_computer, date) async {
    attributions = await Attributions.getComputerAttribution(_computer['id'], date);
    return attributions;
  }

  Future getCustomer(attributions) async{
    print(attributions);
    var customer = await Customers.getAll();
    return customer;
  }

  getCustomerName(attr, customers){
    if (customers != null) {
      List customer = [];
      customers.forEach((elem) {
        if (elem['id'] == attr['customerId'])
          customer.add(elem['firstname'].toString() + ' ' + elem['lastname'].toString());
      });
      return customer[0];
    }
  }

  getAttribution(attributions, hour, customers,  context)  {
    var attribution;
    var customerName;
    if (attributions.length != 0) {
        attributions.forEach((attr) =>
        {
          if (attr['hour'] == hour){
            attribution = attr,
            customerName = getCustomerName(attr, customers)
          }
        });
    };

    return Row(
        children: [
          Text(customerName.toString()),
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
                                      child: FutureBuilder(
                                        future: getAttributions(_computer, date),
                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.data != null) {
                                           return FutureBuilder(
                                               future: getCustomer(snapshot.data),
                                               builder: (BuildContext context, AsyncSnapshot<dynamic> customer) {
                                                   return getAttribution(snapshot.data, _hourSlots[index], customer.data, context);
                                               }
                                           );
                                          }
                                          return Text('');
                                        }
                                      ),
                                    )
                                ) ,
                              ),
                            ],
                          )
                  ),
                )
              ],
            )
        );
}