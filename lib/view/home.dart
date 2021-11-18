
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/models/computer.dart';
import 'package:gao_flutter/providers/api/ComputerProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'components/computer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Computer> _computers = [];
  final TextEditingController _nameController = TextEditingController();
  DateTime currentDate = DateTime.now();

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    //final data = await Computers.getComputers();
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
    _refreshJournals(); // Loading the diary when the app starts
  }


  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingComputer =
      _computers.firstWhere((element) => element.id == id);
      _nameController.text = existingComputer.name;
    }

    showMaterialModalBottomSheet(
        context: context,
        elevation: 5,
        expand: true,
        builder: (_) => Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Nom'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Save new journal
                    if (id == null) {
                      await _addItem();
                    }

                    if (id != null) {
                      await _updateComputer(id.toString());
                    }

                    // Clear the text fields
                    _nameController.text = '';

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Ajouter nouveau poste' : 'Editer'),
                )
              ],
            ),
          ),
        )
    );
  }

// Insert a new journal to the database
  Future<void> _addItem() async {

    /*  await Computers.createComputer(
        _nameController.text);*/
    await ComputerAPIProvider().createComputer(_nameController.text, context);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateComputer(id) async {
    await ComputerAPIProvider().updateComputer(id, _nameController.text, context);
    /* await Computers.updateComputer(
        id, _nameController.text);*/
    _refreshJournals();
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
  void _deleteItem(int id) async {
    await ComputerAPIProvider().deleteComputer(id, context);
    //await Computers.deleteComputer(id);
    _refreshJournals();
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
                                      onPressed: () => _showForm(
                                          _computers[index].id),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteItem(
                                              _computers[index].id),
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
                            computer(context, index, currentDate, _computers[index])
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
        onPressed: () => _showForm(null),
      ),
    );
  }
}