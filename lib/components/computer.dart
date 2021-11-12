import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/controllers/computers.controller.dart';

Widget computer(BuildContext context, index, _computers) {
  final _hourSlots = [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
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
                                            icon: const Icon(Icons.add_circle_outline), onPressed: () {  },
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