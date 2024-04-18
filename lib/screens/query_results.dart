import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

    debugPrint("URL: ${url.toString()}");
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: FutureBuilder(
          future: discogsQuery(),
          builder: (context, snapshot) {
            // data is loaded from query
            if (snapshot.hasData) {
              return const Text("Pog");

              /* TODO:
                            
                display each album with detailOption as "Add"
              */
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
