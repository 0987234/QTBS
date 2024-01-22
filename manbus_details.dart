import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class mandetails extends StatefulWidget {
  final String selectregion;
  final String selectRoute;

  mandetails({required this.selectregion, required this.selectRoute});

  @override
  State<StatefulWidget> createState() => _mandetailsState();
}

class _mandetailsState extends State<mandetails> {
  late CollectionReference busesCollection; // Removed the generic type

  List<String> busIds = [];
  bool busesLoaded = false;
  bool busAdded = false;
  String selectedBusNumber = "";

  @override
  void initState() {
    super.initState();
    // Initialize the Firestore path for the selected route's buses
    busesCollection = FirebaseFirestore.instance
        .collection('Region')
        .doc(widget.selectregion)
        .collection('Route')
        .doc(widget.selectRoute)
        .collection('Buses');

    // Call fetchBuses to load the data when the widget is first created
    fetchBuses();
  }

  Future<void> fetchBuses() async {
    try {
      print("Fetching buses..."); // Update the log message
      QuerySnapshot busesQuery =
          await busesCollection.get(); // Removed the generic type

      setState(() {
        busIds = busesQuery.docs.map((doc) {
          return doc.id;
        }).toList();
        busesLoaded = true;
      });

      print("Buses fetched successfully: ${busIds.length} buses");
    } catch (e) {
      print("Error fetching buses: $e");
      // Handle the error as needed, e.g., show an error message to the user.
    }
  }

  Future<void> addBus() async {
    String busNumber = '';
    String driverName = ''; // Added driverName variable
    bool showError = false; // Initialize showError to false

    GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add a GlobalKey

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Buses'),
          content: Form(
            key: formKey, // Assign the GlobalKey to the Form
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (value) {
                    busNumber = value;
                    // Clear the error message when the user starts typing
                    setState(() {
                      showError = false;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Enter Bus Number'),
                ),
                TextFormField(
                  onChanged: (value) {
                    driverName = value;
                  },
                  decoration: InputDecoration(labelText: 'Enter Driver Name'),
                  validator: (value) {
                    if (value != null &&
                        !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return 'Driver name should contain only alphabets.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                if (showError) // Show the error message conditionally
                  Text(
                    'Only capital letters and numbers allowed at the same time, maximum 10 characters.',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  // Validate the form before proceeding
                  try {
                    await busesCollection.doc(busNumber).set({
                      'time': '0',
                      'seats': 0,
                      'drivername': driverName, // Add driver information
                    });
                    fetchBuses();
                    Navigator.of(context).pop();
                    setState(() {
                      busAdded = true;
                    });
                    selectedBusNumber = busNumber;
                  } catch (e) {
                    print('Error adding bus: $e');
                    // Handle the Firestore write error as needed
                  }
                } else {
                  // Set the showError flag to true to display the error message
                  setState(() {
                    showError = true;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addTime(String busId) async {
    String time = '';

    GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add a GlobalKey

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Time'),
          content: Form(
            key: formKey, // Assign the GlobalKey to the Form
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (value) {
                    time = value;
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter Time (HH:MMam-HH:MMpm)'),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^([1-9]|1[0-2]):[0-5][0-9][apAP][mM]-([1-9]|1[0-2]):[0-5][0-9][apAP][mM]$')
                            .hasMatch(value)) {
                      return 'Invalid time format. Use HH:MMam-HH:MMpm';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Add Time'),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  // Validate the form before proceeding
                  try {
                    await busesCollection.doc(busId).update({
                      'time': time,
                    });
                    fetchBuses(); // Refresh the bus list
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error adding time: $e');
                    // Handle the Firestore update error as needed
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> editTime(String busId) async {
    String time = '';

    // Fetch the existing data for the selected bus
    DocumentSnapshot busSnapshot = await busesCollection.doc(busId).get();

    if (busSnapshot.exists) {
      // Set the initial value for the form field
      String existingTime = busSnapshot['time'];
      time = existingTime;

      GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Time'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: time,
                    onChanged: (value) {
                      time = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Enter Time (HH:MMam-HH:MMpm)'),
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^([1-9]|1[0-2]):[0-5][0-9][apAP][mM]-([1-9]|1[0-2]):[0-5][0-9][apAP][mM]$')
                              .hasMatch(value)) {
                        return 'Invalid time format. Use HH:MMam-HH:MMpm';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    try {
                      // Update the time in Firestore
                      await busesCollection.doc(busId).update({
                        'time': time,
                      });
                      fetchBuses(); // Refresh the bus list
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Error editing time: $e');
                      // Handle the Firestore update error as needed
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> addSeats(String busId) async {
    int totalSeats = 0;
    int availableSeats = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Seats'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  totalSeats = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Enter Total Seats'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2), // Limit to 2 digits
                ],
                keyboardType: TextInputType.number, // Show numeric keyboard
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add Seats'),
              onPressed: () async {
                if (totalSeats > 0) {
                  try {
                    // Update both total seats and available seats
                    await busesCollection.doc(busId).update({
                      'totalseats': totalSeats,
                      'seats':
                          totalSeats, // Set available seats initially to total seats
                    });
                    fetchBuses(); // Refresh the bus list
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error adding seats: $e');
                    // Handle the Firestore update error as needed
                  }
                } else {
                  print('Invalid input. Please enter a valid number of seats.');
                  // You can show an error message to the user if needed
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteBus(String busId) async {
    try {
      await busesCollection.doc(busId).delete();
      fetchBuses(); // Refresh the bus list
    } catch (e) {
      print('Error deleting bus: $e');
      // Handle the Firestore delete error as needed
    }
  }

  Future<void> editBus(String busId) async {
    // Fetch the existing data for the selected bus
    DocumentSnapshot busSnapshot = await busesCollection.doc(busId).get();

    if (busSnapshot.exists) {
      // Set the initial value for the form field
      String existingBusNumber = busSnapshot['busNumber'];
      String editedBusNumber = existingBusNumber;

      GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Bus'),
            content: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: editedBusNumber,
                    onChanged: (value) {
                      editedBusNumber = value;
                    },
                    decoration: InputDecoration(labelText: 'Enter Bus Number'),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  if (editFormKey.currentState?.validate() ?? false) {
                    try {
                      // Update the bus number in Firestore
                      await busesCollection.doc(busId).update({
                        'busNumber': editedBusNumber,
                      });
                      fetchBuses();
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Error editing bus: $e');
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.blue,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Manage Bus'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Bus background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 260),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text("Add Bus"),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text("Add Time"),
                                enabled: busAdded,
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text("Add Seat"),
                                enabled: busAdded,
                              ),
                              // PopupMenuItem(
                              //   value: 4,
                              //   child: Text("Add Seats"),
                              //   enabled: busAdded,
                              // ),
                            ],
                            onSelected: (value) {
                              if (value == 1) {
                                addBus();
                                //Handle add bus option
                              } else if (value == 2) {
                                if (busAdded) {
                                  // Call the addTime function for the selected bus here
                                  addTime(
                                      selectedBusNumber); // Pass the bus number or bus ID to the function
                                }
                                // Handle "Add Time" option
                              } else if (value == 3) {
                                if (busAdded) {
                                  // Call the addSeats function for the selected bus here
                                  addSeats(
                                      selectedBusNumber); // Pass the bus number or bus ID to the function
                                } // Handle "Add Seats" option
                              }
                            },
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 421,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: busesCollection.snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<QueryDocumentSnapshot> busDocuments =
                                      snapshot.data!.docs;

                                  return Column(
                                    children: busDocuments.map((busDocument) {
                                      final busData = busDocument.data()
                                          as Map<String, dynamic>;

                                      final timeData = busDocument.data()
                                          as Map<String, dynamic>;
                                      final time =
                                          timeData['time'] as String? ?? '0';

                                      final busNumber =
                                          busDocument.id.toString();
                                      final driverName =
                                          busData['drivername'] as String? ??
                                              '';
                                      int seats = int.tryParse(
                                              busData['seats'].toString()) ??
                                          0;

                                      final b = busDocument.id.toString();
                                      int totalseats = int.tryParse(
                                              busData['totalseats']
                                                  .toString()) ??
                                          0;

                                      return Column(
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 3),
                                                    ),
                                                    child: SizedBox(
                                                      width: 160,
                                                      height: 96,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Image.asset(
                                                                'assets/bus_icon.png',
                                                                width: 40,
                                                                height: 40,
                                                              ),
                                                              SizedBox(
                                                                height: 22,
                                                              ),
                                                              Text(
                                                                busNumber,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons.edit),
                                                                onPressed: () {
                                                                  editBus(
                                                                      busDocument
                                                                          .id);
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .delete),
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            'Delete Bus'),
                                                                        content:
                                                                            Text('Are you sure you want to delete this bus?'),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                Text('Cancel'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            child:
                                                                                Text('Delete'),
                                                                            onPressed:
                                                                                () {
                                                                              deleteBus(busDocument.id); // Call the deleteBus function
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ); // Add delete icon's onPressed functionality here
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 3),
                                                    ),
                                                    child: SizedBox(
                                                      width: 160,
                                                      height: 96,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Time',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' $time',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons.edit),
                                                                onPressed: () {
                                                                  editBus(busDocument
                                                                      .id); // Add edit icon's onPressed functionality here
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 3),
                                                    ),
                                                    child: SizedBox(
                                                      width: 160,
                                                      height: 96,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Driver name ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' $driverName',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 3),
                                                    ),
                                                    child: SizedBox(
                                                      width: 160,
                                                      height: 96,
                                                      child: Column(children: [
                                                        Text(
                                                          'Total seats',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Text(
                                                          ' $totalseats',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.edit),
                                                              onPressed: () {
                                                                addSeats(
                                                                    busNumber); // Add seats to this bus// Add edit icon's onPressed functionality here
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 3),
                                                    ),
                                                    child: SizedBox(
                                                      width: 160,
                                                      height: 100,
                                                      child: Column(children: [
                                                        Text(
                                                          'Available seats',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          '$seats',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 3,
                                              top: 10,
                                              bottom: 50,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Card(
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                // child: SingleChildScrollView(
                                                //   scrollDirection:
                                                //       Axis.horizontal,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 3),
                                                  ),
                                                  child: SizedBox(
                                                    width: 350,
                                                    height: 70,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 3,
                                                        top: 20,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                ('${widget.selectRoute}'), // Corrected from 'widget.selectedroute'
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                ' $time',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // SizedBox(
                                                          //   width: 10,
                                                          // ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 12,
                                                              right: 3,
                                                              bottom: 12,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Total Seats: $totalseats',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  'Available Seats: $seats',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return Text(
                                    'No documents found',
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
