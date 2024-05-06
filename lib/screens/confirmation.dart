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

  Future<bool> addAlbum(dynamic album, String albumID) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("collection/albums/$albumID");

    DatabaseEvent event = await ref.once();

    if (!event.snapshot.exists) {
      await ref.set(album);
      return true;
    }

    //return false if the album was not added since its already in the db
    return false;
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

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CollectionPage()),
                              (route) => false);
                        }
                        //Adding an album
                        else {
                          bool status = await addAlbum(album, albumID);

                          //The album is already in the collection so show a popup
                          //and go back to the add screen
                          if (!status) {
                            if (context.mounted) {
                              await _showMyDialog(context);
                            }
                          }
                          //The album isnt in the collection so go to collection
                          //screen after it was added
                          else {
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CollectionPage()),
                                  (route) => false);
                            }
                          }
                        }
                      },
                      child: const Text("Confirm"))
                ]))));
  }
}

//show popup when album is already in the db with 2 options going
//back to the collection page or the add album list page
Future<void> _showMyDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Album in Collecion'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This album is already in your collection'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Go Back'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Go to Collection'),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CollectionPage()),
                  (route) => false);
            },
          ),
        ],
      );
    },
  );
}
