import 'package:fireapp/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../pages/login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _itempriceController = TextEditingController();


  late String dateTimedataOfToDo = "";

  List<Map<String, dynamic>> _items = [];

  final _TODOCRUDHIVE = Hive.box("TODOCRUDHIVE");

  //init state/data method
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  // Data refresh from hive storage method
  //this will work after adding data
  void _refreshItems() {
    final data = _TODOCRUDHIVE.keys.map((key) {
      final item = _TODOCRUDHIVE.get(key);
      return {"Key": key, "name": item["name"],"itemprice": item["itemprice"], "shopname": item["shopname"],"DateTime": item["DateTime"]};
    }).toList();

    setState(() {
      _items = data;
      //print(_items.length);
    });
  }

  // Data adding to hive storage method
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _TODOCRUDHIVE.add(newItem);
    _refreshItems();
    //print("Amound of data : ${_TODOCRUDHIVE.length}");
  }

  // Data update to hive storage method
  Future<void> _updateItem(int itemKey, Map<String, dynamic> itemUpdate) async {
    await _TODOCRUDHIVE.put(itemKey, itemUpdate);
    _refreshItems();
    //print("Amound of data : ${_TODOCRUDHIVE.length}");

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An item has been updated")));
  }

  // Data delete from hive storage method
  Future<void> _deleteItem(int itemKey) async {
    await _TODOCRUDHIVE.delete(itemKey);
    _refreshItems();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An item has been deleted")));
    //print("Amound of data : ${_TODOCRUDHIVE.length}");
  }

  // Form pop up method
  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
      _items.firstWhere((element) => element['Key'] == itemKey);
      _nameController.text = existingItem['name'];
      _itempriceController.text = existingItem['itemprice'];
      _shopNameController.text=existingItem['shopname'];
      // _quantityController.text = existingItem['quantity'];
      dateTimedataOfToDo = existingItem['DateTime'];
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: "Item Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _itempriceController,
                decoration: const InputDecoration(hintText: "Item Price"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _shopNameController,
                decoration: const InputDecoration(hintText: "Shop Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: DateTime.now().toString(),
                dateMask: 'd MMM, yyyy',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  if (date.weekday == 6 || date.weekday == 7) {
                    return true;
                  }

                  return true;
                },
                onChanged: (val) => setState(() {
                  //_DateTimeOfToDo = DateTime.parse(val);
                  dateTimedataOfToDo = val;
                }),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
              const SizedBox(
                height: 10,
              ),
              // TextField(
              //   controller: _quantityController,
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(hintText: "Quantity"),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              ElevatedButton(
                onPressed: () async {
                  // Adding data to hive storage
                  if (itemKey == null) {
                    _createItem({
                      "name": _nameController.text,
                      "itemprice": _itempriceController.text,
                      "shopname": _nameController.text,
                      "quantity": _quantityController.text,
                      "DateTime": dateTimedataOfToDo
                    });
                  }

                  //for data update
                  if (itemKey != null) {
                    _updateItem(itemKey, {
                      "name": _nameController.text.trim(),
                      "itemprice": _itempriceController.text,
                      "shopname": _shopNameController.text.trim(),
                      "quantity": _quantityController.text.trim(),
                      "DateTime": dateTimedataOfToDo.trim(),
                    });
                  }

                  _nameController.text = "";
                  _itempriceController.text="";
                  _shopNameController.text = "";
                  _quantityController.text = "";
                  dateTimedataOfToDo = "";

                  Navigator.of(context).pop();
                },
                child: Text(itemKey == null ? "Create New" : "Update"),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }


  //current user info
  final userInfo=FirebaseAuth.instance.currentUser;

  //sign user out
  void signUserOut(){
    FirebaseAuth.instance.signOut();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("To Shop List"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Shopping List APP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Logged in as ${userInfo?.email}",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),

            ),

      Container(
        alignment: Alignment.center,
        width: 150,
          child: ElevatedButton(onPressed: signUserOut, child: Text("Log out"),)),
          ],
        ),
      ),
      body:  ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final currentItem = _items[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              elevation: 3,
              child: ListTile(

                subtitle: Container(
                  height: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 12,),
                      Text(
                        "Item name : ${currentItem['name']}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                          "Item price : ${currentItem['itemprice'].toString()}",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Shop name : ${currentItem['shopname'].toString()}",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Date to buy : ${currentItem['DateTime'].toString()}",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black
                        ),
                      ),

                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Edit button
                    IconButton(
                      icon: const Icon(Icons.edit,color: Colors.black,),
                      onPressed: () => {_showForm(context, currentItem['Key'])},
                    ),
                    //Delete button
                    IconButton(
                      icon: const Icon(Icons.done,color: Colors.black,),
                      onPressed: () => {_deleteItem(currentItem['Key'])},
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
