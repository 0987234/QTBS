import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_project/UI/module/Driver/track_bus_location.dart';
import 'package:test_project/UI/module/Guardian/guardian_student_sapid/student_sap.dart';
import 'package:test_project/UI/module/Manager/Dashboard/man%20dashboard.dart';
import 'package:test_project/UI/module/Student/student%20registration/Users.dart';
import 'package:test_project/UI/module/Student/student%20routes/regionn.dart';
import 'package:test_project/UI/registration/Util/utils.dart';
import 'package:test_project/UI/registration/forgetpassword.dart';

import '../../../widgets/round_button.dart';
import '../../Guardian/guardian_student_sapid/student_location_view.dart';
import '../HomeScreen/Homee.dart';

class LoginScreen extends StatefulWidget {
  final String selectRoute;
  final String fee;
  final String bus;
  final String? voucherDocumentID;
  LoginScreen(
      {required this.selectRoute,
      required this.fee,
      this.voucherDocumentID,
      required this.bus});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _fire = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    checkPer();
    super.initState();
  }

  checkPer() async {
    final check = await Permission.location.isGranted;
    if (!check) {
      Permission.location.request();
    }
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) async {
      // Check if the user is authenticated
      if (value.user != null) {
        final userId = value.user!.uid;
        final userObj = await _fire
            .collection("Users")
            .where("Email", isEqualTo: emailController.text)
            .get();
// .first["role"] == "manager"
        // print(userObj.docs.first.data());
        final userRole = userObj.docs.first.data()["role"];
        if (userRole == "manager") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (e) => mdashboard(
                        selectedroute: '',
                      )),
              (route) => false);
        } else if (userRole == "driver") {
          // Handle the driver role
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (e) => TrackBusLocation(
                      selectRoute: widget.selectRoute,
                      fees: widget.fee,
                      busnumber: widget.bus,
                    )),
            (route) => false,
          );
        } else if (userRole == "guardian") {
          // Handle the guardian role
          // For example, navigate to the GuardianDashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (e) => Studentsapid(
                      selectRoute: widget.selectRoute,
                      fee: widget.fee,
                      bus: widget.bus,
                    )),
            (route) => false,
          );
        } else {
          final busRegistrationCollection =
              FirebaseFirestore.instance.collection('BusRegistrations');

          // Check if the user has registered for any bus
          QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await busRegistrationCollection
                  .where('userId', isEqualTo: userId)
                  .get();

          print("Query Snapshot Size: ${querySnapshot.size}");

          if (querySnapshot.size > 0) {
            // The user is authenticated and has registered for a bus, fetch the route and fee from Firebase
            final data =
                querySnapshot.docs.first.data() as Map<String, dynamic>;
            print("Data: $data");
            final route = data[
                'Route']; // Replace 'route' with the actual field name in your Firestore document
            final fee = data['fees'];
            print("Fee: $fee");
            final bus = data['buses'];
            print("bus: $bus");

            // Replace 'fee' with the actual field name in your Firestore document

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  selectRoute: route ?? widget.selectRoute,
                  fees: fee ?? widget.fee,
                  busnumber: bus ?? widget.bus,
                  voucherDocumentID: '',
                  voucherURL: '',
                ),
              ),
            );
          } else {
            // The user is authenticated but has not registered for a bus, navigate to the region screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => regionnnn()),
            );
          }
        }

        setState(() {
          loading = false;
        });
      }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  // void login() {
  //   setState(() {
  //     loading = true;
  //   });
  //   _auth
  //       .signInWithEmailAndPassword(
  //           email: emailController.text,
  //           password: passwordController.text.toString())
  //       .then((value) async {
  //     // Check if the user is authenticated
  //     if (value.user != null) {
  //       final userId = value.user!.uid;
  //       final usersCollection = FirebaseFirestore.instance.collection('Users');
  //
  //       // Retrieve the user's role from Firestore
  //       DocumentSnapshot<Map<String, dynamic>> userDoc =
  //           await usersCollection.doc(userId).get();
  //
  //       if (userDoc.exists) {
  //         final userRole = userDoc.data()?['role'];
  //
  //         if (userRole == 'manager') {
  //           // Navigate to manager screen
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => mdashboard(),
  //             ),
  //           );
  //         } else if (userRole == 'student') {
  //           // Navigate to student screen
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Home(
  //                 selectRoute: widget.selectRoute,
  //                 fees: widget.fee,
  //                 busnumber: '',
  //               ),
  //             ),
  //           );
  //         } else {
  //           // Handle other roles if needed
  //           print("Unknown role: $userRole");
  //         }
  //       } else {
  //         print("User document not found");
  //       }
  //
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   }).onError((error, stackTrace) {
  //     debugPrint(error.toString());
  //     utils().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgroundd.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
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
                              return null;
                            }),
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
                              return null;
                            }),
                      ],
                    )),
                SizedBox(
                  height: 40,
                ),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => forgetpassword(
                                      selectRoute: widget.selectRoute,
                                      fee: widget.fee,
                                      // bus:widget.bus,
                                    )));
                      },
                      child: Text("Forgot password")),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RollButton(
                                        email: "",
                                        role: "",
                                      )));
                        },
                        child: Text("Sign up"))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // InkWell(
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => loginWithphonenumber()));
                //     },
                //     child: Container(
                //       height: 50,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(50),
                //           border: Border.all(
                //             color: Colors.black,
                //           )),
                //       child: Center(
                //         child: Text('Login with phone'),
                //       ),
                //     ))
              ]),
        )
      ]),
    );
  }
}
