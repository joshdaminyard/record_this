import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:record_this/screens/add.dart';
import 'package:record_this/screens/details.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  Future<Object?> databaseQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("collection/albums");

    DatabaseEvent event = await ref.once();

    // check if query returned with nothing
    if (!event.snapshot.exists) {
      return [];
    }
    return event.snapshot.value;
  }

  /*
   TODO: 
    - add nice display for collection
    - make everything look actually nice
  */
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    List<String> albumList = [];
    List data = [];
    List<Widget> albumCollection = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Collection'),
        actions: [
          //add an album
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPage()),
                );
              }),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              if (data.isEmpty) {
                showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                        title: Text('No Albums in Collection'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('You have no albums in your collection.'),
                              Text("Press the '+' button to add an album"),
                            ],
                          ),
                        )));
              } else {
                await showSearch(
                    context: context,
                    delegate: MySearchDelegate(
                      albumList: albumList,
                      collection: data,
                    ));
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: databaseQuery(),
          builder: (context, snapshot) {
            // data is loaded from query
            if (snapshot.hasData) {
              data = snapshot.data as List<dynamic>;

              //query returns with nothing
              if (data.isEmpty) {
                return Center(
                    child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(children: [
                              Text('You have no albums in your collection.'),
                              Text("Press the '+' button to add an album"),
                              SizedBox(height: 10),
                            ]),
                          ),
                        )));
              }

              // add album titles to list for search suggestions
              // and create a widget for each album
              for (var i = 0; i < data.length; i++) {
                var album = data[i];
                albumList.add(album['title'].toString());
                albumCollection.add(Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AlbumDisplay(album: album, index: i),
                ));
              }

              // query has data so show albums
              return Column(
                children: [
                  Center(
                    child: Wrap(
                      children: albumCollection,
                    ),
                  ),
                ],
              );
            }

            // when query returns with an error
            else if (snapshot.hasError) {
              return Center(
                  child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Text("Error: ${snapshot.error}"),
                            const SizedBox(height: 10),
                          ]),
                        ),
                      )));
            }

            // show loading symbol while data is still being loaded
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

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

/*
  Widget for displaying album art and title for each album
*/
class AlbumDisplay extends StatelessWidget {
  final dynamic album;
  final int index;
  const AlbumDisplay({super.key, required this.album, required this.index});
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
                    builder: (context) =>
                        DetailsPage(album: album, index: index)),
              );
            },
            child: const Text("View"))
      ]),
    );
  }
}
