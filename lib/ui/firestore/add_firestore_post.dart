import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_authentication/utils/utils.dart';
import 'package:login_signup_authentication/widgets/round_button.dart';

class AddFireStorePost extends StatefulWidget {
  const AddFireStorePost({Key? key}) : super(key: key);

  @override
  State<AddFireStorePost> createState() => _AddFireStorePostState();
}

class _AddFireStorePostState extends State<AddFireStorePost> {
  // editing controllers
  final addPostController = TextEditingController();

  //firebase database
  //for adding data in firebase store
  final fireStore = FirebaseFirestore.instance.collection('Users');

  //progress bar
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore Post'),
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
              textCapitalization: TextCapitalization.sentences,
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
                  //for adding data in firebase store
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': addPostController.text.toString(),
                    'id': id
                  }).then((value) {
                    Utils().toastMessage('Post Added');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
