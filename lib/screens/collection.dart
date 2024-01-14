import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:record_this/classes/search_delegate.dart';
import 'package:record_this/screens/add.dart';
import 'package:record_this/screens/details.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  Future<Object?> databaseQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("collection/albums");

    DatabaseEvent event = await ref.once();

    // check if query returned with nothing
    if (!event.snapshot.exists) {
      return {};
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
              //query returns with nothing
              if (mapEquals(snapshot.data as Map<dynamic, dynamic>, {})) {
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
              // add albums to a list to when searching for specific album
              // and create a widget for each album
              final Map<dynamic, dynamic> snapshotData;
              snapshotData = snapshot.data as Map<dynamic, dynamic>;
              snapshotData.forEach((key, value) {
                data.add(value);
                albumList.add(value['title'].toString());
                albumCollection.add(Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AlbumDisplay(
                      album: value, albumID: value["id"].toString()),
                ));
              });

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
  Widget for displaying album art and title for each album
*/
class AlbumDisplay extends StatelessWidget {
  final dynamic album;
  final String albumID;
  const AlbumDisplay({
    super.key,
    required this.album,
    required this.albumID,
  });
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
                        DetailsPage(album: album, albumID: albumID)),
              );
            },
            child: const Text("View"))
      ]),
    );
  }
}
