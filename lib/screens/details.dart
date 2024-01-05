import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final dynamic album;
  const DetailsPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final title = album["title"].toString();
    final artist = album["artist"].toString();
    final albumArt = album["albumArt"].toString();
    final genre = album["genre"].toString();
    final releaseYear = album["releaseYear"].toString();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Album'),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text("albumArt: $albumArt"),
                  Text("title: $title"),
                  Text("artist: $artist"),
                  Text("genre: $genre"),
                  Text("releaseYear: $releaseYear"),
                ]))));
  }
}
