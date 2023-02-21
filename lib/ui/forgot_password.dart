import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_authentication/utils/utils.dart';
import 'package:login_signup_authentication/widgets/round_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  bool loading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: 'Email', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 50.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RoundButton(
              title: 'Forgot',
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth
                    .sendPasswordResetEmail(email: emailController.text.toString())
                    .then((value) {
                  setState(() {
                    loading = false;
                  });
                      Utils().toastMessage('Please Check Your Email');
                })
                    .onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                });
              },
              loading: loading,
            ),
          )
        ],
      ),
    );
  }
}
