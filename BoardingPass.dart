import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../Authentication/models/User_model.dart';
import '../Profile/profile_controller.dart';
import 'package:timezone/timezone.dart' as tz;

// class BoardingPass extends StatefulWidget {
//   final String selectRoute;
//   final String fee;
//   final String bus;
//
//   BoardingPass(
//       {required this.selectRoute, required this.fee, required this.bus});
//
//   @override
//   State<BoardingPass> createState() => _BoardingPassState();
// }
//
// class _BoardingPassState extends State<BoardingPass> {
//   String userName = ''; // Store the user's name
//   String sapId = '';
//   String registrationDate = ''; // Store the start date
//   DateTime parsedDate = DateTime.now(); // Initialize parsedDate
//
//   final ProfileController profileController = Get.find();
//   final _auth = FirebaseAuth.instance;
//   final busRegistrationCollection =
//       FirebaseFirestore.instance.collection('BusRegistrations');
//   String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//   Future<void> initNotifications() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'fee_channel', // ID
//       'Fee Notifications', // Title
//       description: 'Notifications for fee payments',
//     );
//
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch the registration date
//     fetchRegistrationData();
//
//     // Schedule the first payment notification
//     schedulePaymentNotification(parsedDate);
//   }
//
//   // Function to fetch Firestore data and set the registrationDate
//   Future<void> fetchUserData() async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       return; // User not authenticated, handle this case accordingly
//     }
//   }
//
//   Future<DateTime> fetchRegistrationData() async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       return DateTime.now(); // Return the current date in case of an error
//     }
//
//     final userId = user.uid;
//
//     try {
//       final querySnapshot = await busRegistrationCollection
//           .where('userId', isEqualTo: userId)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
//         final dateFromFirestore = data['registrationDate'];
//
//         // Validate and convert the date to 'yyyy-MM-dd' format
//         final validDate = validateAndConvertDate(dateFromFirestore);
//
//         if (validDate != null) {
//           parsedDate = validDate;
//
//           // Calculate the next notification date as one month after the registration date
//           final nextNotificationDate = parsedDate.add(Duration(days: 1));
//
//           // Schedule the first payment notification using parsedDate
//           schedulePaymentNotification(parsedDate);
//
//           setState(() {
//             registrationDate = DateFormat('yyyy-MM-dd').format(parsedDate);
//           });
//
//           return nextNotificationDate; // Return the calculated date
//         } else {
//           print('Invalid date format: $dateFromFirestore');
//           // Handle the case where the date is in an invalid format
//         }
//       }
//     } catch (error) {
//       // Handle errors here if needed
//       print('Error fetching Firestore data: $error');
//     }
//
//     return DateTime.now(); // Return the current date if any error occurs
//   }
//
//   DateTime? validateAndConvertDate(String dateFromFirestore) {
//     try {
//       final parts = dateFromFirestore.split('-');
//       if (parts.length == 3) {
//         final year = int.tryParse(parts[0]);
//         final month = int.tryParse(parts[1]);
//         final day = int.tryParse(parts[2]);
//         if (year != null && month != null && day != null) {
//           return DateTime(year, month, day);
//         }
//       }
//     } catch (e) {
//       print('Error validating and converting date: $e');
//     }
//     return null; // Invalid date
//   }
//
//   void schedulePaymentNotification(DateTime registrationDate) async {
//     final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     final now = tz.TZDateTime.now(tz.local);
//     final nextPaymentDate = tz.TZDateTime(tz.local, registrationDate.year,
//         registrationDate.month, registrationDate.day + 30);
//     final difference = nextPaymentDate.isBefore(now) ? now : nextPaymentDate;
//
//     if (difference.isAfter(now)) {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'Payment Reminder',
//         'It\'s time to pay your monthly fee!',
//         difference,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'fee_channel', // Channel ID
//             'Fee Notifications',
//             // 'Notifications for fee payments',
//           ),
//         ),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }
//
//   int calculateTotalFee(DateTime registrationDate) {
//     DateTime paymentDeadline = registrationDate.add(Duration(days: 5));
//
//     if (registrationDate.weekday == DateTime.saturday ||
//         registrationDate.weekday == DateTime.sunday) {
//       paymentDeadline = paymentDeadline.add(Duration(days: 2));
//     }
//
//     // Calculate the number of days between today and the payment deadline
//     DateTime today = DateTime.now();
//     int daysDifference = paymentDeadline.difference(today).inDays;
//
//     // If the payment deadline is exceeded, add a fine of 100 Rupees per day
//     int fine = 0;
//     if (daysDifference < 0) {
//       fine = -daysDifference * 100;
//       // sendPaymentDeadlineNotification();
//     }
//
//     // Remove commas from the fee string and parse it into an integer
//     int initialFee = int.parse(widget.fee.replaceAll(',', ''));
//
//     // Calculate the total fee by adding the fine to the initial fee
//     int totalFee = initialFee + fine;
//     return totalFee;
//   }
//
//   int calculateFineAfterDeadline(DateTime registrationDate) {
//     DateTime paymentDeadline = registrationDate.add(Duration(days: 5));
//
//     if (registrationDate.weekday == DateTime.saturday ||
//         registrationDate.weekday == DateTime.sunday) {
//       paymentDeadline = paymentDeadline.add(Duration(days: 2));
//     }
//
//     // Calculate the number of days between today and the payment deadline
//     DateTime today = DateTime.now();
//     int daysDifference = paymentDeadline.difference(today).inDays;
//
//     // If the payment deadline is exceeded, calculate the fine after the deadline
//     if (daysDifference < 0) {
//       int dailyFine = 100; // Adjust the fine amount as needed
//       return -daysDifference * dailyFine;
//     }
//
//     return 0; // No fine if the payment is not overdue
//   }
//
//   Widget buildSingleCard() {
//     int totalFee = calculateTotalFee(parsedDate);
//     return Row(
//       children: [
//         Card(
//           margin: EdgeInsets.all(2),
//           child: FutureBuilder(
//             future: profileController.getUserData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasData) {
//                   UserModel user = snapshot.data as UserModel;
//
//                   userName = user.fullName;
//                   sapId = user.Sapid;
//
//                   return Padding(
//                     padding: EdgeInsets.all(1),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               'Name:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 9.0,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                             SizedBox(width: 35),
//                             Text(
//                               userName,
//                               style: TextStyle(
//                                 fontSize: 9,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Text(
//                               'Sap Id:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 9,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                             SizedBox(width: 35),
//                             Text(
//                               sapId,
//                               style: TextStyle(
//                                 fontSize: 9,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Text(
//                               'Fees:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 9.0,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                             SizedBox(width: 40),
//                             Text(
//                               '$totalFee',
//                               style: TextStyle(
//                                 fontSize: 9.0,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Text(
//                               'Bus no',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 9.5,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                             SizedBox(width: 30),
//                             Text(
//                               widget.bus,
//                               style: TextStyle(
//                                 fontSize: 9.5,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 5),
//                         Row(
//                           children: [
//                             Text(
//                               'Valid Upto:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 9.0,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                             SizedBox(width: 10),
//                             Text(
//                               registrationDate,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 9.0,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'Route',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 9.5,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                             SizedBox(width: 10),
//                             Text(
//                               widget.selectRoute,
//                               style: TextStyle(
//                                 fontSize: 9.5,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               }
//               // Return a loading indicator or error message if needed
//               return CircularProgressIndicator(); // Change this to suit your UI
//             },
//           ),
//         ),
//         SizedBox(
//           width: 18,
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.cyan[100],
//       appBar: AppBar(
//         title: Text('Boarding Pass'),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.download,
//               color: Colors.white,
//             ),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.share,
//               color: Colors.white,
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/Bus background.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Container(
//                   width: 360,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 // color: Colors.blue,
//                               ),
//                               child: Text('BOARDING PASS',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black)),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage('assets/logo.png'),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 40),
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 children: [
//                                   Row(children: [
//                                     for (int i = 0; i < 1; i++)
//                                       buildSingleCard(),
//                                   ]),
//                                 ],
//                               )
//                             ]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BoardingPass extends StatefulWidget {
  final String selectRoute;
  final String fee;
  final String bus;

  BoardingPass(
      {required this.selectRoute, required this.fee, required this.bus});

  @override
  State<BoardingPass> createState() => _BoardingPassState();
}

class _BoardingPassState extends State<BoardingPass> {
  String userName = ''; // Store the user's name
  String sapId = '';
  String registrationDate = ''; // Store the start date
  DateTime parsedDate = DateTime.now(); // Initialize parsedDate

  final ProfileController profileController = Get.find();
  final _auth = FirebaseAuth.instance;
  final busRegistrationCollection =
      FirebaseFirestore.instance.collection('BusRegistrations');
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> initNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fee_channel', // ID
      'Fee Notifications', // Title
      description: 'Notifications for fee payments',
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  void initState() {
    super.initState();
    // Fetch the registration date
    fetchRegistrationData();

    // Schedule the first payment notification
    schedulePaymentNotification(parsedDate);
  }

  // Function to fetch Firestore data and set the registrationDate
  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return; // User not authenticated, handle this case accordingly
    }
  }

  Future<DateTime> fetchRegistrationData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return DateTime.now(); // Return the current date in case of an error
    }

    final userId = user.uid;

    try {
      final querySnapshot = await busRegistrationCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        final dateFromFirestore = data['registrationDate'];

        // Validate and convert the date to 'yyyy-MM-dd' format
        final validDate = validateAndConvertDate(dateFromFirestore);

        if (validDate != null) {
          parsedDate = validDate;

          // Calculate the next notification date as one month after the registration date
          final nextNotificationDate = parsedDate.add(Duration(days: 1));

          // Schedule the first payment notification using parsedDate
          schedulePaymentNotification(parsedDate);

          setState(() {
            registrationDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          });

          return nextNotificationDate; // Return the calculated date
        } else {
          print('Invalid date format: $dateFromFirestore');
          // Handle the case where the date is in an invalid format
        }
      }
    } catch (error) {
      // Handle errors here if needed
      print('Error fetching Firestore data: $error');
    }

    return DateTime.now(); // Return the current date if any error occurs
  }

  DateTime? validateAndConvertDate(String dateFromFirestore) {
    try {
      final parts = dateFromFirestore.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);
        if (year != null && month != null && day != null) {
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      print('Error validating and converting date: $e');
    }
    return null; // Invalid date
  }

  void schedulePaymentNotification(DateTime registrationDate) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final now = tz.TZDateTime.now(tz.local);
    final nextPaymentDate = tz.TZDateTime(tz.local, registrationDate.year,
        registrationDate.month, registrationDate.day + 30);
    final difference = nextPaymentDate.isBefore(now) ? now : nextPaymentDate;

    if (difference.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Payment Reminder',
        'It\'s time to pay your monthly fee!',
        difference,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fee_channel', // Channel ID
            'Fee Notifications',
            // 'Notifications for fee payments',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  int calculateTotalFee(DateTime registrationDate) {
    DateTime paymentDeadline = registrationDate.add(Duration(days: 5));

    if (registrationDate.weekday == DateTime.saturday ||
        registrationDate.weekday == DateTime.sunday) {
      paymentDeadline = paymentDeadline.add(Duration(days: 2));
    }

    // Calculate the number of days between today and the payment deadline
    DateTime today = DateTime.now();
    int daysDifference = paymentDeadline.difference(today).inDays;

    // If the payment deadline is exceeded, add a fine of 100 Rupees per day
    int fine = 0;
    if (daysDifference < 0) {
      fine = -daysDifference * 100;
      // sendPaymentDeadlineNotification();
    }

    // Remove commas from the fee string and parse it into an integer
    int initialFee = int.parse(widget.fee.replaceAll(',', ''));

    // Calculate the total fee by adding the fine to the initial fee
    int totalFee = initialFee + fine;
    return totalFee;
  }

  int calculateFineAfterDeadline(DateTime registrationDate) {
    DateTime paymentDeadline = registrationDate.add(Duration(days: 5));

    if (registrationDate.weekday == DateTime.saturday ||
        registrationDate.weekday == DateTime.sunday) {
      paymentDeadline = paymentDeadline.add(Duration(days: 2));
    }

    // Calculate the number of days between today and the payment deadline
    DateTime today = DateTime.now();
    int daysDifference = paymentDeadline.difference(today).inDays;

    // If the payment deadline is exceeded, calculate the fine after the deadline
    if (daysDifference < 0) {
      int dailyFine = 100; // Adjust the fine amount as needed
      return -daysDifference * dailyFine;
    }

    return 0; // No fine if the payment is not overdue
  }

  Widget buildSingleCard() {
    int totalFee = calculateTotalFee(parsedDate);
    return Row(
      children: [
        Card(
          margin: EdgeInsets.all(2),
          child: FutureBuilder(
            future: profileController.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;

                  userName = user.fullName;
                  sapId = user.Sapid;

                  return Padding(
                    padding: EdgeInsets.all(1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9.0,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(width: 35),
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 9,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Sap Id:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(width: 35),
                            Text(
                              sapId,
                              style: TextStyle(
                                fontSize: 9,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Fees:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9.0,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(width: 40),
                            Text(
                              '$totalFee',
                              style: TextStyle(
                                fontSize: 9.0,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        // Row(
                        //   children: [
                        //     Text(
                        //       'Bus no',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 9.5,
                        //       ),
                        //       textAlign: TextAlign.justify,
                        //     ),
                        //     SizedBox(width: 30),
                        //     Text(
                        //       widget.bus,
                        //       style: TextStyle(
                        //         fontSize: 9.5,
                        //       ),
                        //       textAlign: TextAlign.justify,
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Valid Upto:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9.0,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(width: 10),
                            Text(
                              registrationDate,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9.0,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Route',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.selectRoute,
                              style: TextStyle(
                                fontSize: 9.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              }
              // Return a loading indicator or error message if needed
              return CircularProgressIndicator(); // Change this to suit your UI
            },
          ),
        ),
        SizedBox(
          width: 18,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: Text('Boarding Pass'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Bus background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  width: 360,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                // color: Colors.blue,
                              ),
                              child: Text('BOARDING PASS',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(children: [
                                    for (int i = 0; i < 1; i++)
                                      buildSingleCard(),
                                  ]),
                                ],
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
