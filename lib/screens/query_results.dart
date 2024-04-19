import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:record_this/classes/album.dart';
import 'package:record_this/classes/album_display.dart';

class QueryResultsPage extends StatelessWidget {
  final dynamic title;
  final dynamic artist;
  final dynamic year;
  final dynamic label;
  final dynamic genre;
  const QueryResultsPage(
      {super.key,
      required this.title,
      required this.artist,
      required this.year,
      required this.label,
      required this.genre});

  Future<Object?> discogsQuery() async {
    final url = Uri.https("api.discogs.com", "/database/search", {
      "title": "$title",
      "artist": "$artist",
      "year": "$year",
      "label": "$label",
      "genre": "$genre",
      "token": dotenv.env['DISCOGS_KEY'],
    });

    final results = await http.get(url);

    if (results.statusCode == 200) {
      // If the server did return a 200 OK results,
      // then parse the JSON.

      // debugPrint("title: ${jsonDecode(results.body)["results"][0]["title"]}");
      // debugPrint("artist: ${jsonDecode(results.body)["results"][0]["title"]}");
      // debugPrint("year: ${jsonDecode(results.body)["results"][0]["year"]}");
      // debugPrint(
      //     "label: ${jsonDecode(results.body)["results"][0]["label"][0]}");
      // debugPrint(
      //     "genre: ${jsonDecode(results.body)["results"][0]["genre"][0]}");
      // debugPrint("id: ${jsonDecode(results.body)["results"][0]["id"]}");

      // should return an array of album objects or empty
      return jsonDecode(results.body)["results"];
    } else {
      // If the server did not return a 200 OK results,
      // then throw an exception.

      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    List<Widget> albumCollection = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: FutureBuilder(
          future: discogsQuery(),
          builder: (context, snapshot) {
            // data is loaded from query
            if (snapshot.hasData) {
              /* TODO:
                            
                display each album with detailOption as "Add"
              */
              if (listEquals(snapshot.data as List<dynamic>, [])) {
                return const Text("No albums");
              }
              final snapshotData = snapshot.data as List<dynamic>;
              for (int i = 0; i < snapshotData.length; i++) {
                //create album

                // debugPrint("id: ${snapshotData[i]["id"].toString()}");
                // debugPrint("whole dame thing: ${snapshotData[i].toString()}");

                // final albumDetails = jsonDecode(snapshotData[i].toString())
                //     as Map<String, dynamic>;
                String artistTitleString = snapshotData[i]["title"].toString();
                String artistString = artistTitleString.substring(
                    0, artistTitleString.indexOf("-") - 1);
                String titleString = artistTitleString.substring(
                    artistTitleString.indexOf("-") + 2,
                    artistTitleString.length);

                // debugPrint("artist - '$artistString'");
                // debugPrint("title - '$titleString'");

                final albumDetails = {
                  "id": snapshotData[i]["id"].toString(),
                  "title": titleString,
                  "artist": artistString,
                  "genre": snapshotData[i]["genre"][0].toString(),
                  "albumArt": snapshotData[i]["cover_image"].toString(),
                  "releaseYear": snapshotData[i]["year"].toString(),
                  "label": snapshotData[i]["label"][0].toString(),
                };

                // debugPrint("title: ${albumDetails[i]["title"].toString()}");

                albumCollection.add(Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AlbumDisplay(
                      album: albumDetails,
                      albumID: snapshotData[i]["id"].toString(),
                      detailOption: "addView"),
                ));
              }

              //show query results
              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Center(
                        child: Wrap(
                          children: albumCollection,
                        ),
                      ),
                    ],
                  ),
                ),
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
