import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Authentication/Verify%20Code.dart';
import 'package:test_project/UI/registration/Util/utils.dart';
import 'package:test_project/UI/widgets/round_button.dart';

class loginWithphonenumber extends StatefulWidget {
  const loginWithphonenumber({Key? key}) : super(key: key);

  @override
  State<loginWithphonenumber> createState() => _loginWithphonenumberState();
}

class _loginWithphonenumberState extends State<loginWithphonenumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '+92332839123'),
          ),
          SizedBox(
            height: 50,
          ),
          RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                setState(() {
                  loading:
                  true;
                });
                auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading:
                        false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        loading:
                        false;
                      });
                      utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => verifycode(
                                    verificationId: verificationId,
                                  )));
                      setState(() {
                        loading:
                        false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      utils().toastMessage(e.toString());
                    });
              })
        ]),
      ),
    );
  }
}
