import 'package:flutter/material.dart';

/*
  Class for search delegate when pressing the search icon
*/
class MySearchDelegate extends SearchDelegate {
  MySearchDelegate({required this.albumList, required this.collection});
  List<String> albumList;
  List collection;

  /*
    Action buttons which is a clear icon that clears query and closes the search
  */
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            close(context, "");
            query = '';
          })
    ];
  }

  /*
    Back arrow widget for going back to colleciton page
  */
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ""));
  }

  /*
    What is shown after clicking on a result which should look similar to
    the details page
  */
  @override
  Widget buildResults(BuildContext context) {
    for (var album in collection) {
      if (album['title'] == query) {
        final title = album["title"].toString();
        final artist = album["artist"].toString();
        final albumArt = album["albumArt"].toString();
        final genre = album["genre"].toString();
        final releaseYear = album["releaseYear"].toString();
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("albumArt: $albumArt"),
            Text("title: $title"),
            Text("artist: $artist"),
            Text("genre: $genre"),
            Text("releaseYear: $releaseYear"),
          ]),
        );
      }
    }
    return Center(
      child: Text(
        '"$query" is not in your collection',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  /*
    The search suggestions that will be shown as the user is typing in an album
  */
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = albumList.where((album) {
      final result = album.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final album = suggestions[index];

        return ListTile(
          title: Text(album),
          onTap: () {
            query = album;

            showResults(context);
          },
        );
      },
    );
  }
}
