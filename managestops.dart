import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {
  final String selectedRoute;
  final String selectRegion;
  final BuildContext context;
  final State state;
  TextEditingController stopNameController = TextEditingController();
  TextEditingController updatedstopNameController = TextEditingController();
  List<String> stopIds = [];

  FirestoreManager({
    required this.selectedRoute,
    required this.selectRegion,
    required this.context,
    required this.state,
  });

  CollectionReference get stopsCollection => FirebaseFirestore.instance
      .collection('Region')
      .doc(selectRegion)
      .collection('Route')
      .doc(selectedRoute)
      .collection('Stops');

  Future<void> fetchStops(List<String> stopIds) async {
    try {
      print("Fetching stops...");
      QuerySnapshot<Map<String, dynamic>> stopsQuery =
          await stopsCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      stopIds.clear();
      stopIds.addAll(stopsQuery.docs.map((doc) => doc.id));
      print("Stops fetched successfully: ${stopIds.length} stops");
    } catch (e) {
      print("Error fetching stops: $e");
      // Handle the error as needed, e.g., show an error message to the user.
    }
  }

  Future<void> addStop(String stopName) async {
    // Check if the stop already exists
    if (stopIds.contains(stopName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Stop name already exists'),
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

    // Check constraints for the stop name (alphabets only)
    // final RegExp alphabetsPattern = RegExp(r'^[A-Za-z0-9\s]+$');\
    final RegExp alphabetsPattern = RegExp(r'^[A-Za-z0-9\s-]+$');
    if (!alphabetsPattern.hasMatch(stopName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'special characters are not allowed',
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

    try {
      // Add the stop to Firestore
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(selectRegion)
          .collection('Route')
          .doc(selectedRoute)
          .collection('Stops')
          .doc(stopName)
          .set({
        'name': stopName,
        // You can add more fields if needed
      });

      // Update the UI with the new stop
      state.setState(() {
        stopIds.add(stopName);
      });

      // Clear the text field after adding the stop
      stopNameController.clear();

      // Show a success message using AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Stop added successfully!'),
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
      // Handle errors here.
      print('Error adding stop: $e');
    }
  }

  Future<void> deleteRoute(String stopId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(selectRegion)
          .collection('Route')
          .doc(selectedRoute)
          .collection('Stops')
          .doc(stopId)
          .delete();

      // Remove the deleted region from the UI
      state.setState(() {
        stopIds.remove(stopId);
      });
    } catch (e) {
      // Handle errors here.
      print('Error deleting region: $e');
    }
  }

  Future<void> updateStopName(
      String currentStopName, String updatedStopName) async {
    // Check if the current and updated names are the same
    if (currentStopName == updatedStopName) {
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
      return;
    }

    try {
      // Create a new document with the updated name
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(selectRegion)
          .collection('Route')
          .doc(selectedRoute)
          .collection('Stops')
          .doc(updatedStopName)
          .set({'name': updatedStopName});

      // Delete the old document with the previous name
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(selectRegion)
          .collection('Route')
          .doc(selectedRoute)
          .collection('Stops')
          .doc(currentStopName)
          .delete();

      // Update the stop name in the UI
      state.setState(() {
        final index = stopIds.indexOf(currentStopName);
        if (index != -1) {
          stopIds[index] = updatedStopName;
        }
      });

      // Show a success message using AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Stop name updated successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  updatedstopNameController.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors here.
      print('Error updating stop name: $e');
    }
  }

  void showEditStopNameDialog(String currentStopName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedStopName =
            currentStopName; // Initialize with the current stop name
        return AlertDialog(
          title: Text('Edit Stop Name'),
          content: TextField(
            controller: updatedstopNameController..text = updatedStopName,
            decoration: InputDecoration(
              hintText: 'Enter updated stop name',
            ),
            onChanged: (value) {
              updatedStopName = value;
            },
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
              onPressed: () {
                // Check constraints for the updated stop name
                final RegExp alphabetsPattern = RegExp(r'^[A-Za-z0-9\s-]+$');
                if (!alphabetsPattern.hasMatch(updatedStopName)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(
                          'other special characters are not allowed.',
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
                } else {
                  // Call the updateStopName function with the current and updated stop names
                  updateStopName(currentStopName, updatedStopName);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}
