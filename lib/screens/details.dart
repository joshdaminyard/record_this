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
    final label = album["label"].toString();

    final String buttonText =
        detailOption == "collectionView" ? "Remove" : "Add";

    final String confType = detailOption == "collectionView" ? "Delete" : "Add";

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  // Text("albumArt: $albumArt"),
                  Image.network(
                    // albumArt.toString(),
                    "http://placecats.com/300/300",
                    scale: 1,
                    width: 75,
                    height: 75,
                  ),
                  Text("title: $title"),
                  Text("artist: $artist"),
                  Text("genre: $genre"),
                  Text("releaseYear: $releaseYear"),
                  Text("label: $label"),
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
