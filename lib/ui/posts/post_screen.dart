// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_authentication/ui/auth/login_screen.dart';
import 'package:login_signup_authentication/ui/posts/add_post.dart';
import 'package:login_signup_authentication/utils/utils.dart';

class Post_Screen extends StatefulWidget {
  const Post_Screen({Key? key}) : super(key: key);

  @override
  State<Post_Screen> createState() => _Post_ScreenState();
}

class _Post_ScreenState extends State<Post_Screen> {
  final auth = FirebaseAuth.instance;

  //fetching data from firebase
  final ref = FirebaseDatabase.instance.ref('Post');

  //for filter list
  final searchFilter = TextEditingController();

  //to update post
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Post Screen'),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search_rounded),
                  border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
              //fetching data using Firebase animated list
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: const Text('Loading'),
                  itemBuilder: (context, snapshot, animation, index) {
                    //for search filter
                    final title = snapshot.child('title').value.toString();
                    final id = snapshot.child('id').value.toString();
                    if (searchFilter.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          //updating posts
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
                                          ref
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove()
                                              .then((value) {
                                            Utils()
                                                .toastMessage('Post deleted');
                                          }).onError((error, stackTrace) {
                                            Utils()
                                                .toastMessage(error.toString());
                                          });
                                        },
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete'),
                                      ))
                                ]),
                      );
                    } else if (title.toLowerCase().contains(
                        searchFilter.text.toLowerCase().toLowerCase())) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    } else {
                      return Container();
                    } //for search filter
                  }))
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
                    //updating posts
                    ref.child(id).update({
                      'title': editController.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage('Post Update');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    }); //updating posts
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}
//fetching data using stream builder
// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (!snapshot.hasData) {
// return const CircularProgressIndicator();
// } else {
// Map<dynamic, dynamic>? map =
// snapshot.data!.snapshot.value as Map?;
// List<dynamic> list = [];
// list.clear();
// list = map!.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(list[index]['title']),
// subtitle: Text(list[index]['id']),
// );
// });
// }
// },
// )),
