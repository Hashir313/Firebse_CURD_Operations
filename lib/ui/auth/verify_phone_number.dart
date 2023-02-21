// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_authentication/ui/posts/post_screen.dart';
import 'package:login_signup_authentication/utils/utils.dart';
import 'package:login_signup_authentication/widgets/round_button.dart';

class VerifyPhoneNumber extends StatefulWidget {
  //variable for the verification of phone number
  String verificationId;

  VerifyPhoneNumber({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  //progress bar
  bool loading = false;

  //firebase auth for mobile verification
  final auth = FirebaseAuth.instance;

  //editing controller
  final otpVerificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify With Phone Number'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
            const SizedBox(
            height: 80.0,
          ),
          TextFormField(
            controller: otpVerificationController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: '6 digit Code',
            ),
          ),
          const SizedBox(
            height: 80.0,
          ),
          RoundButton(
              title: 'Verify OTP',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true ;
                });
                final credentials = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpVerificationController.text.toString());
                try{
                  await auth.signInWithCredential(credentials);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Post_Screen()));
                }catch(e){
                  Utils().toastMessage(e.toString());
                  setState(() {
                    loading = false ;
                  });
                };
              }
      )
      ],
    ),)
    ,
    );
  }
}
