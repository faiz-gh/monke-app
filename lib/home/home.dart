import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  XFile? image;
  final storage = FirebaseStorage.instance;

  void _getCounter() async {
    final count =
    await FirebaseFirestore.instance.collection('data').doc('stats').get();
    setState(() {
      counter = count.get('count');
    });
  }

  void _openCamera() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = file;
    });
    if (image != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/preview',
          arguments: <String, XFile?>{'photo': image});
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _getCounter();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          'Monke',
        ),
        leading: Icon(Icons.menu),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            BigCard(theme: theme, counter: counter),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () => _openCamera(),
        child: Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.theme,
    required this.counter,
  }) : super(key: key);

  final ThemeData theme;
  final int counter;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.primary,
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text(
            '$counter',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}