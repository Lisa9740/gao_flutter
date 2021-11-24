import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/models/computer.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:gao_flutter/utils/shared_pref.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:gao_flutter/view/login.dart';
import 'package:gao_flutter/controllers/computers.controller.dart';
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

  int currentPage = 1;
  String _totalPageSize = "0";
  DateTime currentDate = DateTime.now();

  bool _isLoading = true;
  var subscription = null;

  // This function is used to fetch all data from the database
  void _refreshData() async {
    var pageSize = await ComputerAPIProvider().fetchPageSize();
//    final computer = await ComputerAPIProvider().fetchComputer(currentDate, currentPage);
    final computer = await Computers.getComputers(currentDate, currentPage);

   // await Computers.getComputers(currentDate, currentPage);

    print({"computers", computer});
    setState(() {
      _computers = computer;
      _isLoading = false;
      _totalPageSize = pageSize.toString();
    });
  }

  @override
  void initState()  {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
                  print(result);
    });
    _refreshData(); // Loading the diary when the app starts
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        locale : const Locale("fr","FR"),
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      _refreshData();
      setState(() {
        currentDate = pickedDate;
      });
    }
  }
  // Delete an item
  void _deleteItem(int id, computer) async {
    RemoveComputerModal(id, computer, _refreshData, context);
  }

  totalAttributionNumber(computer){
    print({"totalAttributionNumber computer", computer});
    if (computer.attributions.length > 0){
      if (computer.attributions[0].length > 0){
        return Text(computer.attributions[0].length.toString() + " / 10");
      }
    }
    return Text("0 / 10");
  }

  logout(){
    sharedPref().remove('token');
    SendNotificationSnackBar('Vous êtes maintenant déconnecté', context);
    return  Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false);
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
               Row(
                 children: [
                   const SizedBox(
                     width: 300,
                   ),
                   IconButton(
                     onPressed: () => logout(),
                     icon: Icon(Icons.logout),
                   ),
                 ],
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                    ),
                    ElevatedButton(onPressed: () async {
                      if (currentPage != 1){
                        setState(() {
                          currentPage = currentPage - 1;
                        });
                        _refreshData();
                      }
                    }, child: Icon(Icons.arrow_back_ios)),
                    const SizedBox(
                      width: 20,
                    ),
                    Text('Page ' + currentPage.toString() + '/' + _totalPageSize),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(onPressed: () async {
                      setState(() {
                        currentPage = currentPage + 1;
                      });
                      _refreshData();

                    },  child: Icon(Icons.arrow_forward_ios)),
                  ],
                ),
                Expanded(
                  child: Container(
                  height: 450.0,
                  child: ListView.builder(
                    itemCount: _computers.length,
                    itemBuilder: (context, int index) {
                      return ExpansionTile(
                          title: ListTile(
                              title: Text(_computers[index].name.toString()),
                              trailing: SizedBox(
                                width: 160,
                                child: Row(
                                  children: [
                                    totalAttributionNumber(_computers[index]),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => showForm(_computers[index].id, _computers, _refreshData, context),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteItem(_computers[index].id,   _computers[index]),
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
                )
              ]

          )
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showForm(null, _computers, _refreshData, context),
      ),
    );
  }
}