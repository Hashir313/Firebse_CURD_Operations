import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_signup_authentication/utils/utils.dart';
import 'package:login_signup_authentication/widgets/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  @override

  bool loading = false;

  File? _image;
  final picker = ImagePicker();

  //to access the image
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('Post');

  Future getGalleryImage()async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery , imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        debugPrint('No Image Print');
      }
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image!= null ? Image.file(_image!.absolute, fit: BoxFit.fill,) : const Icon(
                    Icons.image,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            RoundButton(title: 'Upload Image', loading: loading, onTap: ()async {
              setState(() {
                loading = true;
              });
              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/My image/${DateTime.now().millisecondsSinceEpoch}');
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

              await Future.value(uploadTask);
              var newUrl = await ref.getDownloadURL();

              String id = DateTime.now().millisecondsSinceEpoch.toString();
              databaseReference.child('1').set({
                'id': id,
                'title': newUrl.toString()
              }).then((value) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage('Image Posted to firestore');
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
