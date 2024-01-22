import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:page_transition/page_transition.dart';

import '../../../../Authentication/models/User_model.dart';
import '../../../registration/Util/utils.dart';
import '../FeedBack/feedback.dart';
import '../Help/help.dart';
import '../Payment/BoardingPass.dart';
import '../Payment/Voucher_status.dart';
import '../Payment/pay.dart';
import '../Profile/profileScreen.dart';
import '../Profile/profile_controller.dart';
import '../student registration/login.dart';
import '../student_bus_selection/Bus book status.dart';

class Home extends StatefulWidget {
  final String selectRoute;
  final String fees;
  final String busnumber;
  final String voucherDocumentID;
  final String voucherURL;

  Home(
      {required this.selectRoute,
      required this.fees,
      required this.busnumber,
      required this.voucherDocumentID,
      required this.voucherURL}) {
    // assert(voucherDocumentID != null);
  }
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;
  String userName = '';
  final ProfileController profileController = Get.find();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? busInfo;
  final _firestore = FirebaseFirestore.instance;
  loc.Location location = loc.Location();
  LatLng? _currentLocation;
  LatLng? _busLocation;
  Set<Marker> _markers = Set<Marker>();

  Future<String> getVoucherStatus() async {
    try {
      // Replace with your Firestore logic to get the voucher status
      final user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot voucherSnapshot = await FirebaseFirestore.instance
          .collection('Vouchers')
          .doc(user?.uid)
          .get();

      if (voucherSnapshot.exists) {
        String status = voucherSnapshot['status'] ?? 'pending';
        print('Voucher Document ID: ${widget.voucherDocumentID}');
        print('Voucher Status: $status');
        return status;
      } else {
        print('Voucher Document ID: ${widget.voucherDocumentID}');
        print('Voucher Status: pending');
        return 'pending';
      }
    } catch (e) {
      print('Error getting voucher status: $e');
      return 'error';
    }
  }

  @override
  void initState() {
    getLoc();

    super.initState();
  }

  animateCam(data) async {
    try {
      var busLoc =
          LatLng(double.parse(data?["lat"]), double.parse(data?["lng"]));
      if (_busLocation == null) {
        setState(() {
          _busLocation = busLoc;
        });
        _addMarker(busLoc);
      } else if (_busLocation != busLoc) {
        setState(() {
          _markers.clear();
          _busLocation = busLoc;
        });
        _addMarker(busLoc);
      }
      GoogleMapController googleMapController = await _controller.future;
      googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: _currentLocation!, northeast: _busLocation!),
          30));
    } on Exception catch (e) {
      print(e);
    }
  }

  getBusInfo() async {
    final _busInfo = await _firestore
        .collection('BusRegistrations')
        .where('userId', isEqualTo: _auth.currentUser?.uid)
        .get();

    final f = _busInfo.docs.first.data();

    _firestore
        .collection("Region/Islamabad/Route")
        .doc("E_FSectorGSector")
        .collection("Buses")
        .doc(f["busNumber"])
        .snapshots()
        .listen((e) {
      print("object ${e.data()}");
      var data = e.data();

      animateCam(data);
    });
    setState(() {
      busInfo = f;
    });
  }

  getLoc() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.denied) {
        return;
      }
    }

    GoogleMapController googleMapController = await _controller.future;

    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) async {
      var loc = LatLng(position.latitude, position.longitude);

      final user = await _firestore
          .collection("Users")
          .where("Email", isEqualTo: _auth.currentUser?.email)
          .get();
      final rev = user.docs.first.reference.id;
      final cuUser = _firestore.collection("Users").doc(rev);

      cuUser.update(
          {"lat": loc.latitude.toString(), "lng": loc.longitude.toString()});

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: loc,
            zoom: 18.0,
          ),
        ),
      );
    });

    final currLoc = await location.getLocation();

    setState(() {
      _currentLocation = LatLng(currLoc.latitude!, currLoc.longitude!);
      _markers.clear();
    });
    getBusInfo();
  }

  Future<void> _addMarker(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    final markerId = MarkerId(position.toString());

    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(30, 30)), // Adjust the size as needed
      "assets/Bbus.png",
    );

    setState(() {
      _markers.add(
        Marker(
          icon: customIcon,
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(
            title: 'Waypoint',
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // getLoc();
    return Scaffold(
        appBar: AppBar(title: Text('Home'), actions: [
          IconButton(
            onPressed: () {
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
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
        ]),
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
                        radius: 50.0, // Adjust size as needed
                        backgroundImage: AssetImage(
                            'assets/profileimage.jpg'), // Replace with actual driver profile image
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
                leading: Icon(Icons.payment),
                title: Text('Payment'),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     // builder: (context) => payfee(
                  //     //     selectRoute: widget.selectRoute,
                  //     //     fee: widget.fees,
                  //     //     busnumber: widget
                  //     //         .busnumber), // Replace PaymentScreen with your actual payment screen
                  //   ),
                  // );
                  // Update the UI to show that item 1 was selected
                  Navigator.push(
                    context,
                    PageTransition(
                      child: payfee(
                          selectRoute: widget.selectRoute,
                          fee: widget.fees,
                          busnumber: widget
                              .busnumber), // Replace PaymentScreen with your actual payment screen
                      // Replace with the screen you want to navigate to
                      type: PageTransitionType
                          .rightToLeft, // or any other transition type you prefer
                      duration: Duration(
                          microseconds: 700), // Specify your desired duration
                    ),
                  );
                },
              ),
              // ListTile(
              //   title: Text('Voucher'),
              //   onTap: () async {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return VoucherUpload(
              //             selectRoute: widget.selectRoute,
              //             fee: widget.fees,
              //             bus: widget.busnumber,
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Boarding pass '),
                onTap: () async {
                  // AssetImage('assets/boarding pass.jpg');
                  // Check voucher status from Firestore
                  String voucherStatus = await getVoucherStatus();

                  if (voucherStatus == 'accepted') {
                    // Navigate to the BoardingPass screen if the voucher is accepted
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardingPass(
                          selectRoute: widget.selectRoute,
                          fee: widget.fees,
                          bus: widget.busnumber,
                        ),
                      ),
                    );
                  } else {
                    // Show a message for rejected or pending voucher
                    if (voucherStatus == 'rejected') {
                      // Show dialog for rejected voucher
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Voucher Rejected'),
                            content: Text(
                                'Your voucher has been rejected. Please submit an authentic voucher.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (voucherStatus == 'pending') {
                      // Show dialog for pending voucher
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Voucher Pending'),
                            content: Text(
                                'Your voucher is pending. Please wait for approval.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Show a SnackBar for pending voucher
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Voucher status is pending.'),
                      //   ),
                      // );
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.details),
                title: Text('Voucher Status '),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: voucherstatus(),

                      // with the screen you want to navigate to
                      type: PageTransitionType
                          .rightToLeft, // or any other transition type you prefer
                      duration: Duration(
                          microseconds: 700), // Specify your desired duration
                    ),
                  ); // Update the UI to show that item 1 was selected
                },
              ),
              ListTile(
                leading: Icon(Icons.schedule_send),
                title: Text('Reservation Status '),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          busbookstatus(), // Replace PaymentScreen with your actual payment screen
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
                          feedback(), // Replace PaymentScreen with your actual payment screen
                    ),
                  );
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
                  ); // Update the UI to show that item 2 was selected
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
                  );
                  // Update the UI to show that item 2 was selected
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(children: [
            Container(
                height: size.height / 1.7,
                child: GoogleMap(
                  markers: _markers,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? LatLng(33.68889, 73.06667),
                    zoom: 8,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                )),
            Container(
              padding: EdgeInsets.all(16.0), // Adjust padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.access_time_outlined,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('10:00am - 4:00pm'),
                                ],
                              ),
                            ]), // Replace with actual arrival time
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_bus,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Bus No.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(busInfo?["busNumber"] ?? ""),
                                  ],
                                ),
                              ],
                            ) // Replace with actual bus number
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0), // Add spacing between rows
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0, // Adjust size as needed
                        backgroundImage: AssetImage(
                            'assets/driverr.jpg'), // Replace with actual driver profile image
                      ),
                      SizedBox(
                          width: 16.0), // Add spacing between image and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driver ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Bahseer Ahmed'), // Replace with actual driver name
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        )));
  }
}
