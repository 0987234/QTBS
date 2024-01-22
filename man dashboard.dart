import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:test_project/UI/module/Manager/Feed%20back/feedback.dart';

import '../../../../Authentication/models/User_model.dart';

import '../../../../utils.dart';
import '../../Student/Help/help.dart';
import '../../Student/Profile/profileScreen.dart';
import '../../Student/Profile/profile_controller.dart';

import '../../Student/student registration/login.dart';
import '../Driver_panel/businformation.dart';
import '../Driver_panel/driver_region.dart';
import '../Payment_handler/student_voucher_check.dart';
import '../manager_busesdetails/bus registration record.dart';
import '../manager_routes/man_region.dart';

class mdashboard extends StatefulWidget {
  // const mdashboard({Key? key}) : super(key: key);
  final String selectedroute;

  mdashboard({required this.selectedroute});

  @override
  State<mdashboard> createState() => _mdashboardState();
}

class _mdashboardState extends State<mdashboard> {
  String userName = '';
  final ProfileController profileController = Get.find();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;

  String getGreeting() {
    final currentTime = DateTime.now().hour;

    if (currentTime >= 5 && currentTime < 12) {
      return 'Good morning!';
    } else if (currentTime >= 12 && currentTime < 17) {
      return 'Good afternoon!';
    } else if (currentTime >= 17 && currentTime < 21) {
      return 'Good evening!';
    } else {
      return 'Good night!';
    }
  }

  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd MMM yyy').format(DateTime.now());
    String greeting = getGreeting();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[500],
        key: _globalKey,
        drawer: Drawer(
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
                        radius: 60.0, // Adjust size as needed
                        backgroundImage: AssetImage(
                            'assets/manager.png'), // Replace with actual driver profile image
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
                leading: Icon(Icons.schedule_send),
                title: Text('Reservation Record'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          busregistration(), // Replace PaymentScreen with your actual payment screen
                    ),
                  ); // Update the UI to show that item 1 was selected
                },
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Vouchercheck(), // Replace PaymentScreen with your actual payment screen
                    ),
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
              ListTile(
                leading: Icon(Icons.feedback),
                title: Text('Feedback'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          mfeedback(), // Replace PaymentScreen with your actual payment screen
                    ),
                  ); // Update the U
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Setting '),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => profile(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help '),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => help(),
                    ),
                  ); // Update the UI to show that item 2 was selected
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned(
                top: 12,
                left: 17,
                child: GestureDetector(
                  onTap: () {
                    _globalKey.currentState?.openDrawer();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.menu, // Replace with the desired icon
                      size: 25, // Adjust the size as needed
                      color: Colors.black, // Set the color of the icon
                    ),
                  ),
                )),
            Positioned(
              left: 300,
              top: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        auth.signOut().then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                selectRoute: 'widget.selectRoute',
                                fee: 'widget.fees',
                                bus: 'widget.busnumber',
                              ),
                            ),
                          );
                        }).onError((error, stackTrace) {
                          utils().toastMessage(error.toString());
                        });
                      },
                      icon: Icon(Icons.logout_outlined),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(children: [
                      SizedBox(height: 85),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hi,$userName!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Manager',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(height: 5),
                      // Padding(
                      //   padding: (EdgeInsets.only(right: 230)),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         'Manager',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 15,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 35),
                      Row(
                        children: [
                          Text(
                            '$greeting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                          height: 543,
                          width: 800,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                              child: Column(children: [
                            SizedBox(height: 20),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, top: 80),
                                  child: Column(children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child:
                                                        RegionManagerScreen(), // Replace with the screen you want to navigate to
                                                    type: PageTransitionType
                                                        .topToBottom, // or any other transition type you prefer
                                                    duration: Duration(
                                                        seconds:
                                                            1), // Specify your desired duration
                                                  ),
                                                );
                                              },
                                              child: Opacity(
                                                opacity: 0.8,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 0),
                                                  width: 280,
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .white, // Use a slightly lighter blue for better contrast
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Add subtle rounded corners
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 9.0,
                                                        spreadRadius: 2.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/locationn.png',
                                                        width: 112,
                                                        height: 112,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 80),
                                                              child: Text(
                                                                'Manage Route ', // Use a more descriptive label
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // Opacity(
                                            //   opacity: 0.8,
                                            //   child: Container(
                                            //     margin: const EdgeInsets.only(
                                            //         right: 10),
                                            //     width: 140,
                                            //     height: 160,
                                            //     decoration: BoxDecoration(
                                            //       color: Colors
                                            //           .white, // Use a slightly lighter blue for better contrast
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               10.0), // Add subtle rounded corners
                                            //       boxShadow: [
                                            //         BoxShadow(
                                            //           color: Colors.black
                                            //               .withOpacity(0.2),
                                            //           offset: Offset(0, 2),
                                            //           blurRadius: 4.0,
                                            //           spreadRadius: 2.0,
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     child: Column(
                                            //       mainAxisAlignment:
                                            //           MainAxisAlignment.center,
                                            //       children: [
                                            //         Image.asset(
                                            //           'assets/busmann.png',
                                            //           width: 115,
                                            //           height: 108,
                                            //         ),
                                            //         const SizedBox(height: 4),
                                            //         Row(
                                            //           children: [
                                            //             Expanded(
                                            //               child: Padding(
                                            //                 padding:
                                            //                     EdgeInsets.only(
                                            //                         left: 15),
                                            //                 child: Text(
                                            //                   'Bus Manage ', // Use a more descriptive label
                                            //                   style: TextStyle(
                                            //                     color: Colors
                                            //                         .black,
                                            //                     fontSize: 15.0,
                                            //                     fontWeight:
                                            //                         FontWeight
                                            //                             .w500,
                                            //                   ),
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: driverregion(
                                                      selectregion: '',
                                                      selectedRoute: '',
                                                    ), // Replace with the screen you want to navigate to
                                                    type: PageTransitionType
                                                        .topToBottom, // or any other transition type you prefer
                                                    duration: Duration(
                                                        seconds:
                                                            1), // Specify your desired duration
                                                  ),
                                                );
                                              },
                                              child: Opacity(
                                                opacity: 0.8,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  width: 280,
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .white, // Use a slightly lighter blue for better contrast
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Add subtle rounded corners
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 4.0,
                                                        spreadRadius: 2.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/diverman.png',
                                                        width: 115,
                                                        height: 108,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 84),
                                                              child: Text(
                                                                'Allocate driver ', // Use a more descriptive label
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //     Opacity(
                                            //       opacity: 0.8,
                                            //       child: Container(
                                            //         margin: const EdgeInsets.only(
                                            //             left: 10),
                                            //         width: 140,
                                            //         height: 160,
                                            //         decoration: BoxDecoration(
                                            //           color: Colors
                                            //               .white, // Use a slightly lighter blue for better contrast
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   10.0), // Add subtle rounded corners
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //               color: Colors.black
                                            //                   .withOpacity(0.2),
                                            //               offset: Offset(0, 2),
                                            //               blurRadius: 9.0,
                                            //               spreadRadius: 2.0,
                                            //             ),
                                            //           ],
                                            //         ),
                                            //         child: Column(
                                            //           mainAxisAlignment:
                                            //               MainAxisAlignment.center,
                                            //           children: [
                                            //             Image.asset(
                                            //               'assets/time.png',
                                            //               width: 90,
                                            //               height: 90,
                                            //             ),
                                            //             Row(
                                            //               children: [
                                            //                 Expanded(
                                            //                   child: Padding(
                                            //                     padding:
                                            //                         EdgeInsets.only(
                                            //                             left: 20),
                                            //                     child: Text(
                                            //                       'Time Schedule ', // Use a more descriptive label
                                            //                       style: TextStyle(
                                            //                         color: Colors
                                            //                             .black,
                                            //                         fontSize: 15.0,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w500,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(width: 10),
                                            //     GestureDetector(
                                            //       onTap: () {
                                            //         Navigator.push(
                                            //           context,
                                            //           PageTransition(
                                            //             child: driverregion(
                                            //               selectregion: '',
                                            //               selectedRoute: '',
                                            //             ), // Replace with the screen you want to navigate to
                                            //             type: PageTransitionType
                                            //                 .topToBottom, // or any other transition type you prefer
                                            //             duration: Duration(
                                            //                 seconds:
                                            //                     1), // Specify your desired duration
                                            //           ),
                                            //         );
                                            //       },
                                            //       child: Opacity(
                                            //         opacity: 0.8,
                                            //         child: Container(
                                            //           margin: const EdgeInsets.only(
                                            //               right: 10),
                                            //           width: 140,
                                            //           height: 160,
                                            //           decoration: BoxDecoration(
                                            //             color: Colors
                                            //                 .white, // Use a slightly lighter blue for better contrast
                                            //             borderRadius:
                                            //                 BorderRadius.circular(
                                            //                     10.0), // Add subtle rounded corners
                                            //             boxShadow: [
                                            //               BoxShadow(
                                            //                 color: Colors.black
                                            //                     .withOpacity(0.2),
                                            //                 offset: Offset(0, 2),
                                            //                 blurRadius: 4.0,
                                            //                 spreadRadius: 2.0,
                                            //               ),
                                            //             ],
                                            //           ),
                                            //           child: Column(
                                            //             mainAxisAlignment:
                                            //                 MainAxisAlignment
                                            //                     .center,
                                            //             children: [
                                            //               Image.asset(
                                            //                 'assets/diverman.png',
                                            //                 width: 115,
                                            //                 height: 108,
                                            //               ),
                                            //               const SizedBox(height: 4),
                                            //               Row(
                                            //                 children: [
                                            //                   Expanded(
                                            //                     child: Padding(
                                            //                       padding: EdgeInsets
                                            //                           .only(
                                            //                               left: 15),
                                            //                       child: Text(
                                            //                         'Allocate driver ', // Use a more descriptive label
                                            //                         style:
                                            //                             TextStyle(
                                            //                           color: Colors
                                            //                               .black,
                                            //                           fontSize:
                                            //                               15.0,
                                            //                           fontWeight:
                                            //                               FontWeight
                                            //                                   .w500,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ]),
                                ))
                          ])))
                    ])))
          ],
        ),
      ),
    );
  }
}
