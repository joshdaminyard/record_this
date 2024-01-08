import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:record_this/screens/collection.dart';

class ConfirmationPage extends StatelessWidget {
  final dynamic album;
  final int index;
  final String confType;
  const ConfirmationPage(
      {super.key,
      required this.album,
      required this.index,
      required this.confType});

  Future removeAlbum() async {
    FirebaseDatabase.instance.ref("collection/albums/$index").remove();
  }

  @override
  Widget build(BuildContext context) {
    final title = album["title"].toString();
    return Scaffold(
        appBar: AppBar(
          title: Text(confType),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Text(
                    'Are you sure you want to delete\n"$title"\nfrom your collection?',
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        removeAlbum();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CollectionPage()));
                      },
                      child: const Text("Confirm"))
                ]))));
  }
}
