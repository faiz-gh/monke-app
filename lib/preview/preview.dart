import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Preview extends StatefulWidget {
  const Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, XFile?>{}) as Map;
    final image = arguments['photo'];
    final previewPhoto = File(image.path);

    Future<void> uploadToS3(File image) async {
      try {
        var response = await http.post(
            Uri.parse('http://43.205.216.220:3000/uploadAndAnalyse'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"photo": image.readAsBytesSync()}));
        if (response.statusCode == 200) {
          print("Upload Success");
        } else {
          print(response.statusCode);
        }
      } catch (e) {
        throw ('Error uploading photo-> $e');
      }
    }

    void saveFile() async {
      await uploadToS3(previewPhoto);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          SizedBox(
              child: (image == null)
                  ? Container()
                  : Image.file(
                previewPhoto,
                fit: BoxFit.fill,
              )),
        ],
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: 'Return to Homescreen',
                  heroTag: null,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close),
                ),
                FloatingActionButton(
                  onPressed: () {
                    saveFile();
                  },
                  tooltip: 'Save the Photo',
                  heroTag: null,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check),
                )],
          )
      ),
    );
  }
}
