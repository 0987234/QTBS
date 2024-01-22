import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/UI/module/Driver/time_sechedule.dart';
import '../../../Authentication/models/User_model.dart';
import '../../../utils.dart';
import '../Student/Help/help.dart';
import '../Student/Profile/profileScreen.dart';
import '../Student/Profile/profile_controller.dart';
import '../Student/student registration/login.dart';
import 'Student_stop/stu_stop.dart';
import 'bas_information.dart';

class DriverDrawer extends StatefulWidget {
  // const DriverDrawer({super.key});
  final String selectRoute;
  final String fees;
  final String busnumber;

  DriverDrawer({
    required this.selectRoute,
    required this.fees,
    required this.busnumber,
  });

  @override
  State<DriverDrawer> createState() => _DriverDrawerState();
}

class _DriverDrawerState extends State<DriverDrawer> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String userName = '';
    final ProfileController profileController = Get.find();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => profile()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 50.0, // Adjust size as needed
                    backgroundImage: AssetImage(
                        'assets/driverr.jpg'), // Replace with actual driver profile image
                  ),
                ),
                FutureBuilder(
                  future: profileController.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        UserModel user = snapshot.data as UserModel;

                        userName = user.fullName;

                        return Text(
                          userName,
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    }
                    // Return a loading indicator or error message if needed
                    return CircularProgressIndicator(); // Change this to suit your UI
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Student Stop'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => stustop(
                    selectedRoute: '',
                    selectregion: '',
                    fee: '',
                    voucherDocumentID: '',
                  ), // Replace PaymentScreen with your actual payment screen
                ),
              ); // Update the UI to show that item 1 was selected
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.star),
          //   title: Text('Time Schedule'),
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             TimeSchedule(), // Replace PaymentScreen with your actual payment screen
          //       ),
          //     ); // Update the UI to show that item 1 was selected
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.system_security_update,
            ),
            title: Text('Bus Information'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BusInformation(
                          selectRoute: widget.selectRoute,
                          fees: '',
                          busnumber: '',
                        )),
              ); // Update the UI to show that item 1 was selected
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.notifications),
          //   title: Text('Notification'),
          //   onTap: () {
          //     // Update the UI to show that item 2 was selected
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.feedback),
          //   title: Text('Feedback'),
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             mfeedback(), // Replace PaymentScreen with your actual payment screen
          //       ),
          //     ); // Update the U
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting '),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => profile(),
                ),
              );
              // Update the UI to show that item 2 was selected
              // Update the UI to show that item 2 was selected
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help '),
            onTap: () {
              // Update the UI to show that item 2 was selected
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => help()),
              ); //
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Logout '),
            onTap: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              selectRoute: widget.selectRoute,
                              fee: widget.fees,
                              bus: widget.busnumber,
                            )));
              }).onError((error, stackTrace) {
                utils().toastMessage(error.toString());
              });
            },
          ),
        ],
      ),
    );
  }
}
