import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  Future<Object?> discogQuery() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("collection/albums");

    DatabaseEvent event = await ref.once();

    // check if query returned with nothing
    if (!event.snapshot.exists) {
      return [];
    }
    return event.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Album Collection'),
        ),
        body: const Center(
          child: Column(children: [
            Text("Title"),
            Form(child: TextField()),
            Text("Artist"),
            Form(child: TextField())
          ]),
        ));
  }
}
