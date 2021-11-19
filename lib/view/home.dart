
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/models/computer.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'components/computer.dart';
import 'components/modals/computer.modal.dart';
import 'components/modals/remove.computer.modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Computer> _computers = [];

  DateTime currentDate = DateTime.now();

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final computer = await ComputerAPIProvider().fetchComputer(currentDate, 1);
    print(computer);
    setState(() {
      _computers = computer;
      _isLoading = false;
    });
  }

  @override
  void initState()  {
    super.initState();
    _refreshData(); // Loading the diary when the app starts
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        locale : const Locale("fr","FR"),
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }
  // Delete an item
  void _deleteItem(int id, computer) async {
    RemoveComputerModal(id, computer, context);
    _refreshData();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const SliverAppBar(
                pinned: true,
                title: Text('GAO Flutter'),
              ),
            ];
          },
          body: _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          ) :
          Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 30.0,
                  child: Text(formatDate(currentDate, [dd, '/', mm, '/', yyyy])),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Selectionner une date'),
                  ),
                ),
                Container(
                  height: 500.0,
                  child: ListView.builder(
                    itemCount: _computers.length,
                    itemBuilder: (context, int index) {
                      return ExpansionTile(
                          title: ListTile(
                              title: Text(_computers[index].name.toString()),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => showForm(_computers[index].id, _computers, _refreshData, context),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteItem(
                                              _computers[index].id,   _computers[index]),
                                    ),
                                  ],
                                ),
                              )
                          ),
                          children: [
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            computer(context, index, currentDate, _computers[index], _refreshData)
                          ]
                      );
                    },
                  ),
                )
              ]
          )
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showForm(null, null, null, null),
      ),
    );
  }
}