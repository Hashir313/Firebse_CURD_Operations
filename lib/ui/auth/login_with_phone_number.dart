import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_authentication/ui/auth/verify_phone_number.dart';
import 'package:login_signup_authentication/utils/utils.dart';
import 'package:login_signup_authentication/widgets/round_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  //progress bar
  bool loading = false;

  //firebase auth for mobile verification
  final auth = FirebaseAuth.instance;

  //editing controller
  final phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 80.0,
            ),
            TextFormField(
              controller: phoneNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+92 321 4438772',
              ),
            ),
            const SizedBox(
              height: 80.0,
            ),
            RoundButton(
                title: 'Get OTP',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true ;
                  });
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumber.text,
                      verificationCompleted: (_) {},
                      verificationFailed: (e) {
                        setState(() {
                          loading = false ;
                        });
                        debugPrint(e.toString());
                        Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                        setState(() {
                          loading = false ;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyPhoneNumber(
                                      verificationId: verificationId,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (e) {
                        setState(() {
                          loading = false ;
                        });
                        Utils().toastMessage(e.toString());
                      });
                })
          ],
        ),
      ),
    );
  }
}
