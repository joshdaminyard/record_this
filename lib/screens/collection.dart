import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

const pageName = "Collection Page";

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  Future<Object?> databaseQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("collection/albums");

    DatabaseEvent event = await ref.once();

    //shows the data here
    return event.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Collection'),
      ),
      body: FutureBuilder(
          future: databaseQuery(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data as List<dynamic>;
              debugPrint("theres data!");
              return Center(
                  child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(children: [
                          Text("Data: $data"),
                          const SizedBox(height: 10),
                        ]),
                      )));
            } else if (snapshot.hasError) {
              return Center(
                  child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(children: [
                          Text("Error: ${snapshot.error}"),
                          const SizedBox(height: 10),
                        ]),
                      )));
            }
            /*
                have proper way to check if there is no data
            */
            // else if (!snapshot.hasData) {
            //   return Center(
            //       child: Scrollbar(
            //           controller: scrollController,
            //           thumbVisibility: true,
            //           child: SingleChildScrollView(
            //             controller: scrollController,
            //             child: const Column(children: [
            //               Text("No Data"),
            //               SizedBox(height: 10),
            //             ]),
            //           )));
            // }
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );

    // return const Padding(
    //   padding: EdgeInsets.all(10.0),
    //   child: Text("Collection Page"),
    // );
  }
}
