import 'package:flutter/material.dart';
import 'package:record_this/screens/confirmation.dart';

class DetailsPage extends StatelessWidget {
  final dynamic album;
  final String albumID;
  final String
      detailOption; // either "collectionView" from collection or "addView" from add page
  const DetailsPage(
      {super.key,
      required this.album,
      required this.albumID,
      required this.detailOption});

  @override
  Widget build(BuildContext context) {
    final title = album["title"].toString();
    final artist = album["artist"].toString();
    final albumArt = album["albumArt"].toString();
    final genre = album["genre"].toString();
    final releaseYear = album["releaseYear"].toString();

    final String buttonText =
        detailOption == "collectionView" ? "Remove" : "Add";

    final String confType = detailOption == "collectionView" ? "Delete" : "Add";

    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Text("albumArt: $albumArt"),
                  Text("title: $title"),
                  Text("artist: $artist"),
                  Text("genre: $genre"),
                  Text("releaseYear: $releaseYear"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmationPage(
                                    album: album,
                                    albumID: albumID,
                                    confType: confType,
                                  )),
                        );
                      },
                      child: Text(buttonText))
                ]))));
  }
}
