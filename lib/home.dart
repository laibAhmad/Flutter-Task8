import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final CollectionReference database =
      Firestore.instance.collection("Augersoft");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store and Fetch Data'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: database.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: snapshot.data.documents.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data.documents[index]['Name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(snapshot.data.documents[index]['Details']),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
          // _showAlert();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Enter Details',
          ),
          children: [
            SimpleDialogOption(
              child: TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Name Here..',
                ),
              ),
            ),
            SimpleDialogOption(
              child: TextField(
                controller: detailsController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Description..',
                ),
              ),
            ),
            SimpleDialogOption(
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: () {
                  if (nameController != null && detailsController != null) {
                    print(nameController.text);
                    print(detailsController.text);

                    storeDetails();
                    nameController.clear();
                    detailsController.clear();
                    Navigator.pop(context);
                  }
                },
                color: Colors.purple,
                child: Text(
                  'Enter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> storeDetails() async {
    return await database.add({
      'Details': detailsController.text,
      'Name': nameController.text,
    });
  }
}
