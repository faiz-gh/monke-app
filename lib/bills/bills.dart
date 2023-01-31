import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  const Bills({Key? key}) : super(key: key);

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bills').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final bills = snapshot.data!.docs;
          List<ListTile> billIDs = [];
          for (var bill in bills) {
            billIDs.add(
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text(
                  bill.id,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/bill_details', arguments: <String, String>{'id': bill.id});
                },
              )
            );
          }
          return ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListBody(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: billIDs,
                    ).toList(),
                  )
              )
            ],
          );
        },
      ),
    );
  }
}
