import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:record_this/screens/collection.dart';

class ConfirmationPage extends StatelessWidget {
  final dynamic album;
  final String albumID;
  final String confType;
  const ConfirmationPage(
      {super.key,
      required this.album,
      required this.albumID,
      required this.confType});

  Future removeAlbum() async {
    FirebaseDatabase.instance.ref("collection/albums/$albumID").remove();
  }

  @override
  Widget build(BuildContext context) {
    final title = album["title"].toString();
    final appBarTitle = confType == "Delete" ? "Delete Album" : "Add Album";
    final promptText = confType == "Delete"
        ? 'Are you sure you want to delete\n"$title"\nfrom your collection?'
        : 'Are you sure you want to add\n"$title"\nto your collection?';
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Text(
                    promptText,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (confType == "Delete") {
                          removeAlbum();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CollectionPage()));
                        }
                      },
                      child: const Text("Confirm"))
                ]))));
  }
}
