import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_authentication/ui/auth/login_screen.dart';
import 'package:login_signup_authentication/ui/firestore/add_firestore_post.dart';
import 'package:login_signup_authentication/utils/utils.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;

  //to update post
  final editController = TextEditingController();

  //firebase database
  //for adding data in firebase store
  final fireStore = FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFireStorePost()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Firebase Store'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined)),
          const SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Some Error');
                }

                return Expanded(
                    //fetching data using Firebase animated list
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String id =
                              snapshot.data!.docs[index]['id'].toString();
                          String title =
                              snapshot.data!.docs[index]['title'].toString();
                          return ListTile(
                            title: Text(title),
                            subtitle: Text(id),
                            trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert_rounded),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showMyDialog(title, id);
                                            },
                                            leading: const Icon(Icons.edit),
                                            title: const Text('Update'),
                                          )),
                                  PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        //delete posts
                                        onTap: () {
                                          Navigator.pop(context);
                                          ref.doc(id).delete().then((value) {
                                            Utils().toastMessage('Post deleted');
                                          }).onError((error, stackTrace) {
                                            Utils().toastMessage(error.toString());
                                          });
                                        },
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete'),
                                      ))
                                    ]),
                          );
                        }));
              })
        ],
      ),
    );
  }

  //updating posts
  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: editController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Edit', border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.doc(id).update({
                      'title': editController.text
                    }).then((value) {
                      Utils().toastMessage('Post updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}
