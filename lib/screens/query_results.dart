import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record_this/screens/details.dart';
import 'package:record_this/classes/album.dart';

class QuesryResultsPage extends StatelessWidget {
  const QuesryResultsPage({super.key});

  Future<Object?> discogsQuery() async {
    return null;
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
