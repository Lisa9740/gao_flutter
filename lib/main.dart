// main.dart
import 'package:flutter/material.dart';
import 'package:gao_flutter/controllers/computers.controller.dart';

import 'components/computer.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Kindacode.com',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _computers = [];
  final _hourSlots = [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await Computers.getComputers();
    setState(() {
      _computers = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _nameController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _computers.firstWhere((element) => element['id'] == id);
      _nameController.text = existingJournal['name'];
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                      await _updateComputer(id);
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
        ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await Computers.createComputer(
        _nameController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateComputer(int id) async {
    await Computers.updateComputer(
        id, _nameController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await Computers.deleteComputer(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Suppression du poste réussi !'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                title: new Text('Flutter Demo'),
              ),
            ];
          },
          body:    _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          ) :
          Column(
            children: [
              Container(
                  height: 300.0,
                  child: ListView.builder(
                    itemCount: _computers.length,
                    itemBuilder: (context, index) => Card(
                        color: Colors.orange[200],
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            ListTile(
                                title: Text(_computers[index]['name']),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _showForm(_computers[index]['id']),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _deleteItem(_computers[index]['id']),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              height: 300.0,
                                child:
                                ListView.builder(
                                    itemCount: _hourSlots.length,
                                    itemBuilder: (context, index) =>
                                        Text(_hourSlots[index].toString() + " h")
                                ),
                            )
                          ],
                        )

                    ),
                  )
              )
            ],
          )



      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}