import 'package:flutter/material.dart';
import 'package:record_this/screens/details.dart';

/*
  Widget for displaying album art and title for each album
*/
class AlbumDisplay extends StatelessWidget {
  final dynamic album;
  final String albumID;
  final String detailOption;
  const AlbumDisplay(
      {super.key,
      required this.album,
      required this.albumID,
      required this.detailOption});
  @override
  Widget build(BuildContext context) {
    final title = album["title"].toString();
    final albumArt = album["albumArt"].toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text("albumArt: $albumArt"),
        Text("title: $title"),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsPage(
                        album: album,
                        albumID: albumID,
                        detailOption: detailOption)),
              );
            },
            child: const Text("View"))
      ]),
    );
  }
}
