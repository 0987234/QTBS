import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'man_stops.dart';

class RouteManagerScreen extends StatefulWidget {
  final String selectregion;

  RouteManagerScreen({required this.selectregion});

  @override
  State<RouteManagerScreen> createState() => _RouteManagerScreenState();
}

class _RouteManagerScreenState extends State<RouteManagerScreen> {
  String selectroute = '';
  List<String> routeDataList = [];
  String currentRouteName = ''; // Change the type if needed
  String updatedRouteName = ''; // Change the type if needed
  String currentRouteId = ''; // Add this variable if needed

  TextEditingController routeNameController = TextEditingController();
  TextEditingController feesController = TextEditingController();

  TextEditingController updatedRouteNameController = TextEditingController();

  Future<List<QueryDocumentSnapshot>> _fetchRoute() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Region')
        .doc(widget.selectregion)
        .collection('Route')
        .get();

    // final routeDataList =
    //     querySnapshot.docs.where((doc) => doc.exists).toList();
    final routeDataList = querySnapshot.docs.toList();
    print("My Debug: $routeDataList");

    return routeDataList;
  }

  Future<void> deleteRoute(String routeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(widget.selectregion)
          .collection('Route')
          .doc(routeId)
          .delete();

      // Remove the deleted region from the UI
      setState(() {
        routeDataList.remove(routeId);
      });
    } catch (e) {
      // Handle errors here.
      print('Error deleting region: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog(String routeId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this route?'),
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
              child: Text('Delete'),
              onPressed: () {
                deleteRoute(routeId); // Delete the region
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addRoute(String routeName, String fees) async {
    if (routeDataList.contains(routeName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Route name already exists'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final RegExp alphabetsPattern = RegExp(r'^[A-Za-z0-9\s-]+$');
    if (!alphabetsPattern.hasMatch(routeName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(' Other Special characters are not allowed'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(widget.selectregion)
          .collection('Route')
          .doc(routeName)
          .set({
        'fees': fees,
        // 'routename': routeName,
      });

      setState(() {
        routeDataList.add(routeName);
      });

      routeNameController.clear();
      feesController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Route added successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error adding route: $e');
    }
  }

  Future<void> updateRouteName(
      String currentRouteName, String updatedRouteName) async {
    final RegExp alphabetsPattern = RegExp(r'^[A-Za-z0-9\s]+$');

    if (!alphabetsPattern.hasMatch(updatedRouteName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'Special characters are not allowed',
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function if the constraint is not met
    }

    if (routeDataList.contains(updatedRouteName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Route name already exists'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  updatedRouteNameController.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      if (currentRouteName != updatedRouteName) {
        // Create a new document with the updated name
        await FirebaseFirestore.instance
            .collection('Region')
            .doc(widget.selectregion)
            .collection('Route')
            .doc(updatedRouteName)
            .set({'name': updatedRouteName});

        // Delete the old document with the previous name
        await FirebaseFirestore.instance
            .collection('Region')
            .doc(widget.selectregion)
            .collection('Route')
            .doc(currentRouteName)
            .delete();

        print('Route name updated: $updatedRouteName');
      }

      // Update the region name in the UI
      setState(() {
        final index = routeDataList.indexOf(currentRouteName);
        if (index != -1) {
          routeDataList[index] = updatedRouteName;
        }
      });

      // Show a success message using AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Route name updated successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  updatedRouteNameController.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors here.
      print('Error updating route name: $e');
    }
  }

  void handleUpdateRouteName(String currentRouteName, String updatedRouteName) {
    if (currentRouteName != updatedRouteName) {
      // Call the updateRegionName function
      updateRouteName(currentRouteName, updatedRouteName);
    } else {
      // Show a message to inform the user that the names are the same
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('The new name is the same as the current name.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showEditFeesDialog(String currentRouteId) {
    String updatedFees = ''; // Set initial value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Fees'),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              // updatedFees = double.tryParse(value) ?? 0.0;
              updatedFees = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                handleEditFees(currentRouteId, updatedFees);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateFees(String currentRouteId, String updatedFees) async {
    try {
      // Update fees in Firestore
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(widget.selectregion)
          .collection('Route')
          .doc(currentRouteId)
          .update({'fees': updatedFees});

      // Update fees in the UI
      setState(() {
        // Add your logic to update fees in routeDataList or wherever you store fees in the UI
      });

      // Show a success message using AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Fees updated successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Add any additional logic if needed
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors here.
      print('Error updating fees: $e');
    }
  }

  void handleEditFees(String currentRouteId, String updatedFees) {
    // Call the updateFees function
    updateFees(currentRouteId, updatedFees);
  }

  @override
  void initState() {
    super.initState();
    _fetchRoute(); // Fetch regions when the screen initializes
  }

  @override
  void dispose() {
    routeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Route"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _fetchRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final routeDataList = snapshot.data!;
              return Stack(children: [
                // ... (your existing code)

                Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: routeNameController,
                              decoration:
                                  InputDecoration(hintText: 'Enter route name'),
                            ),
                          ),
                          Expanded(
                            // Add this expanded widget
                            child: TextField(
                              controller: feesController,
                              keyboardType: TextInputType
                                  .number, // Specify the keyboard type
                              decoration:
                                  InputDecoration(hintText: 'Enter fees'),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                String routeName =
                                    routeNameController.text.trim();
                                // double fees =
                                //     double.tryParse(feesController.text) ?? 0.0;
                                String fees = feesController.text
                                    .trim(); // Treat fees as String
                                if (routeName.isNotEmpty) {
                                  addRoute(routeName, fees);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 70),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: routeDataList.map((document) {
                              final routeName = document.id;
                              final fee = document.get('fees');

                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Card(
                                          elevation: 10.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              routeName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            subtitle: Text(
                                              'Fee: $fee',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StopManagerScreen(
                                                    selectedroute: document.id,
                                                    selectregion:
                                                        widget.selectregion,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            document.id);
                                      },
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        final currentDocument = snapshot.data!
                                            .firstWhere((document) =>
                                                document.id == routeName);
                                        final currentRouteName =
                                            currentDocument.id;

                                        if (value == 'edit route name') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              String updatedRouteName =
                                                  currentRouteName;
                                              return AlertDialog(
                                                title: Text('Edit Route Name'),
                                                content: TextField(
                                                  onChanged: (value) {
                                                    updatedRouteName = value;
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Save'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      handleUpdateRouteName(
                                                          currentRouteName,
                                                          updatedRouteName);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else if (value == 'edit_fees') {
                                          _showEditFeesDialog(currentRouteName);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem<String>(
                                            value: 'edit_route_name',
                                            child: Text('Edit Route Name'),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'edit_fees',
                                            child: Text('Edit Fees'),
                                          ),
                                        ];
                                      },
                                    ),

                                    // PopupMenuButton<String>(
                                    //   onSelected: (value) {
                                    //     // Use the current context of PopupMenuButton to get the correct routeName
                                    //     final currentDocument = snapshot.data!
                                    //         .firstWhere((document) =>
                                    //             document.id == routeName);
                                    //     final currentRouteName =
                                    //         currentDocument.id;
                                    //
                                    //     if (value == 'edit_route_name') {
                                    //       showDialog(
                                    //         context: context,
                                    //         builder: (BuildContext context) {
                                    //           String updatedRouteName =
                                    //               currentRouteName;
                                    //           return AlertDialog(
                                    //             title: Text('Edit Route Name'),
                                    //             content: TextField(
                                    //               onChanged: (value) {
                                    //                 updatedRouteName = value;
                                    //               },
                                    //             ),
                                    //             actions: [
                                    //               TextButton(
                                    //                 child: Text('Cancel'),
                                    //                 onPressed: () {
                                    //                   Navigator.of(context)
                                    //                       .pop();
                                    //                 },
                                    //               ),
                                    //               TextButton(
                                    //                 child: Text('Save'),
                                    //                 onPressed: () {
                                    //                   Navigator.of(context)
                                    //                       .pop();
                                    //                   handleUpdateRouteName(
                                    //                       currentRouteName,
                                    //                       updatedRouteName);
                                    //                 },
                                    //               ),
                                    //             ],
                                    //           );
                                    //         },
                                    //       );
                                    //     } else if (value == 'edit_fees') {
                                    //       _showEditFeesDialog(currentRouteName);
                                    //     }
                                    //   },
                                    //   itemBuilder: (BuildContext context) {
                                    //     return [
                                    //       PopupMenuItem<String>(
                                    //         value: 'edit_route_name',
                                    //         child: Text('Edit Route Name'),
                                    //       ),
                                    //       PopupMenuItem<String>(
                                    //         value: 'edit_fees',
                                    //         child: Text('Edit Fees'),
                                    //       ),
                                    //     ];
                                    //   },
                                    // ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ]);
            } else {
              return Center(child: Text('No route data available'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
