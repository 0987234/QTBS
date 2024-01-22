import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/UI/registration/Util/utils.dart';
import 'package:test_project/UI/widgets/round_button.dart';
import 'package:test_project/posts/post_Screen.dart';

class verifycode extends StatefulWidget {
  final String verificationId;
  const verifycode({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<verifycode> createState() => _verifycodeState();
}

class _verifycodeState extends State<verifycode> {
  bool loading = false;
  final verifyCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: verifyCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '6-digit code'),
          ),
          SizedBox(
            height: 50,
          ),
          RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading:
                  true;
                });
                final crendital = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verifyCodeController.text.toString());

                try {
                  await auth.signInWithCredential(crendital);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => postscreen()));
                } catch (e) {
                  setState(() {
                    loading:
                    false;
                  });
                  utils().toastMessage(e.toString());
                }
              })
        ]),
      ),
    );
  }
}
