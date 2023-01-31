import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillDetails extends StatefulWidget {
  const BillDetails({Key? key}) : super(key: key);

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  @override
  Widget build(BuildContext context) {
    Map<dynamic,dynamic> arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, String>{}) as Map;
    final id = arguments['id'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Bill Details"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("bills").doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final bill = snapshot.data;
          return Container(
            child: Column(
              children: [
                Text("Vendor Name: ${(bill?['vendor_name'] != null) ? bill!['vendor_name'] : 'Not available'}"),
                Text("Total: ${bill?['total']}"),
                Expanded(
                  child: ListView.builder(
                    itemCount: bill?['items'].length,
                    itemBuilder: (context, index) {
                      final item = bill?['items'][index];
                      return ListTile(
                        title: Text("${item['item']}"),
                        subtitle: Text("Price: ${item['price']} | Quantity: ${item['quantity']}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
