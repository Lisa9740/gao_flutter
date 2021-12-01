import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gao_flutter/utils/shared_pref.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:gao_flutter/view/login.dart';
import 'package:gao_flutter/controllers/computer.controller.dart';
import 'components/computer.dart';
import 'components/modals/computer.modal.dart';
import 'components/modals/remove.computer.modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  List _computers = [];
  List _attributions = [];

  int currentPage = 1;
  String _totalPageSize = "0";
  DateTime currentDate = DateTime.now();
  bool _isLoading = true;


  // This function is used to fetch all data from the database
  void _refreshData() async {
    var pageSize = await sharedPref().read('computerSize');
    final computer = await Computers.getComputers(_connectionStatus, currentDate, currentPage);
    print({"computers", computer});
    setState(() {
      _computers = computer;
      _isLoading = false;
      _totalPageSize = pageSize;
    });
  }

  @override
  void initState()  {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _refreshData();
  }


  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
        print({'Couldn\'t check connectivity status',  e});
      return;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
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
  void _deleteItem(int id, computer, connectivity) async {
    RemoveComputerModal(id, computer, _refreshData, connectivity, context);
  }


  totalAttributionNumber(computer, date, attributions) async{
    print({"totalAttributionNumber computer", attributions});
    if (attributions.length > 0){
        return Text(attributions.length.toString() + " / 10");
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
                              title: Text(_computers[index]['name'].toString()),
                              trailing: SizedBox(
                                width: 160,
                                child: Row(
                                  children: [
                                   // totalAttributionNumber(_computers[index], currentDate),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => showForm(_computers[index]['id'], _computers, _refreshData, _connectionStatus, context),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteItem(_computers[index]['id'], _computers[index], _connectionStatus),
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
                            computer(context, index, currentDate, _computers[index], _attributions, _connectionStatus, _refreshData)
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
        onPressed: () => showForm(null, _computers, _refreshData, _connectionStatus, context),
      ),
    );
  }
}