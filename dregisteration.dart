import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Authentication/Auth_reprository/User_Repository/user_repository.dart';
import '../../../../Authentication/models/User_model.dart';
import '../../../registration/Util/utils.dart';
import '../../../widgets/round_button.dart';
import '../../Student/student registration/login.dart';

class dregister extends StatefulWidget {
  const dregister({Key? key}) : super(key: key);

  @override
  State<dregister> createState() => _dregisterState();
}

class _dregisterState extends State<dregister> {
  bool loading = false;
  bool isFormValid = false;
  final _formkey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final licenseController = TextEditingController();
  final phonenoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  final userrepo = Get.put(UserRepository());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void register() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      utils().toastMessage(value.user!.email.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    selectRoute: '',
                    fee: '',
                    voucherDocumentID: "",
                    bus: '',
                  )),
          (route) => false);
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> createUser(UserModel user) async {
    await userrepo.createUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Registration',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(children: [
          Container(
            // Wrap with Container
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundd.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Wrap with Container

          Padding(
            padding:
                const EdgeInsets.only(left: 110, top: 0, right: 110, bottom: 0),
            child: Image(
              height: 150,
              width: 120,
              image: AssetImage('assets/logo.png'),
            ),
          ),

          Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 150, right: 10, bottom: 0),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: fullnameController,
                            decoration: const InputDecoration(
                              hintText: 'Full name',
                              suffixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter name';
                              }

                              // Update the regular expression to allow spaces
                              final RegExp nameRegex =
                                  RegExp(r'^[a-zA-Z ]{3,25}$');

                              if (!nameRegex.hasMatch(value)) {
                                return 'Name should consist of only alphabetical characters and have 3 to 25 characters.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: const InputDecoration(
                                  hintText: 'Email',
                                  suffixIcon: Icon(Icons.alternate_email)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter email';
                                }
                                // Define a regular expression to match the email format.
                                final RegExp emailRegExp = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Invalid email address format';
                                }

                                return null;
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: phonenoController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'XXXX-XXXXXXX',
                              suffixIcon: Icon(Icons.add_call),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter phone no';
                              }

                              // Define a regular expression to match the phone number format.
                              final RegExp phoneRegExp =
                                  RegExp(r'^\d{4}-\d{7}$');

                              if (!phoneRegExp.hasMatch(value)) {
                                return 'Invalid phone number format. Use XXXX-XXXXXXX';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // TextFormField(
                          //   controller: addressController,
                          //   keyboardType: TextInputType.text,
                          //   decoration: const InputDecoration(
                          //     hintText: 'Address',
                          //     suffixIcon: Icon(Icons.home),
                          //   ),
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'Enter Address';
                          //     }
                          //
                          //     // Split the input into parts using any whitespace as the separator.
                          //     List<String> addressParts =
                          //         value.split(RegExp(r'\s+'));
                          //
                          //     // Check if there are at least one non-empty part.
                          //     if (addressParts.isEmpty ||
                          //         addressParts
                          //             .any((part) => part.trim().isEmpty)) {
                          //       return 'Each part of the address should not be empty';
                          //     }
                          //
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: licenseController,
                            decoration: const InputDecoration(
                              hintText: 'Enter license number',
                              suffixIcon: Icon(Icons.assignment_ind),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter license number';
                              }

                              // Define a regular expression to match the license number format 'MH-XX-X'.
                              final RegExp licenseRegExp =
                                  RegExp(r'^MH-[A-Z0-9]{2}-[A-Z0-9]$');

                              if (!licenseRegExp.hasMatch(value)) {
                                return 'Invalid license number format (e.g., MH-12-A)';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  hintText: 'password',
                                  suffixIcon: Icon(Icons.lock_open)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter password';
                                }
                                final RegExp passwordRegExp = RegExp(
                                    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                                if (!passwordRegExp.hasMatch(value)) {
                                  return 'Password must contain at least 8 characters with \n alphabets, numbers, and special characters';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: confirmpasswordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  hintText: ' Confirm password',
                                  suffixIcon: Icon(Icons.lock_open)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Reenter password';
                                }

                                // Check if the password matches the value in the password field.
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              }),
                        ],
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  RoundButton(
                    title: 'Create Account',
                    loading: loading,
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        isFormValid = true;
                        final user = UserModel(
                          fullName: fullnameController.text.trim(),
                          email: emailController.text.trim(),
                          phoneNo: phonenoController.text.trim(),
                          Address: '',
                          Password: passwordController.text.trim(),
                          ConfirmPassword:
                              confirmpasswordController.text.trim(),
                          Sapid: '',
                          role: 'driver',
                          profileImageUrl: '',
                        );

                        register();
                        UserRepository.instances.createUser(user);

                        // Corrected the line here
                      }

                      // if (isFormValid) {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => mlogin()));
                      // }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(
                                          selectRoute: '',
                                          fee: '',
                                          voucherDocumentID: "",
                                          bus: '',
                                        )));
                          },
                          child: Text("Login"))
                    ],
                  )
                ],
              )))
        ]));
  }
}
