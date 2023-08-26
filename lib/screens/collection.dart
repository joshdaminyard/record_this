import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
    - do something with search results
    - add nice display for collection
    - add route to results page when clicking on an album
    - if collectoin is empty make user add an album and make it nice
    - convert to stateful widget to hide search button when no albums
  */
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    List<String> albumList = [];
    String searchResult = "";
    List data = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Collection'),
        actions: [
          //add an album
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),

          //search for album
          if (data.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                searchResult = await showSearch(
                    context: context,
                    delegate: MySearchDelegate(
                      albumList: albumList,
                      collection: data,
                    ));
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
                              Text("There is no data"),
                              SizedBox(height: 10),
                            ]),
                          ),
                        )));
              }

              // add album titles to list for search suggestions
              for (var album in data) {
                albumList.add(album['title'].toString());
              }

              // query has data so show albums
              return Center(
                  child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            Text("Data: $data\n\n POGG"),
                            const SizedBox(height: 10),
                          ]),
                        ),
                      )));
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

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate({required this.albumList, required this.collection});
  List<String> albumList;
  List collection;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, "");
            }
            query = '';
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ""));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }

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
