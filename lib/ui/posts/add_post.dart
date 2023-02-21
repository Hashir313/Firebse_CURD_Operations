import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_authentication/utils/utils.dart';
import 'package:login_signup_authentication/widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // editing controllers
  final addPostController = TextEditingController();

  //firebase database
  //for adding data in real time database
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  //progress bar
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            TextFormField(
              controller: addPostController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: 'What \'s in your mind?',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 80.0,
            ),
            RoundButton(
                title: 'Add Post',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  //for adding data in real time database
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef.child(id).set({
                    'id': id,
                    'title': addPostController.text.toString()
                  }).then((value) {
                    addPostController.clear();
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Post added');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
