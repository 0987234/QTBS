import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'man_route.dart';

class RegionManagerScreen extends StatefulWidget {
  @override
  _RegionManagerScreenState createState() => _RegionManagerScreenState();
}

class _RegionManagerScreenState extends State<RegionManagerScreen> {
  String selectregion = '';
  List<String> regionDataList = [];
  TextEditingController regionNameController = TextEditingController();
  TextEditingController updatedRegionNameController = TextEditingController();

  Future<void> _fetchRegion() async {
    final regionquery =
        await FirebaseFirestore.instance.collection('Region').get();

    setState(() {
      regionDataList = regionquery.docs.map((doc) => doc.id).toList();
    });

    print("My Debug: $regionDataList");
  }

  Future<void> deleteRegion(String regionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(regionId)
          .delete();

      // Remove the deleted region from the UI
      setState(() {
        regionDataList.remove(regionId);
      });
    } catch (e) {
      // Handle errors here.
      print('Error deleting region: $e');
    }
  }

  Future<void> addRegion(String regionName) async {
    //check if the region name already exist in regionDatalist
    if (regionDataList.contains(regionName)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Region name already exists'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return;
    }
    // Define a regular expression pattern to match only alphabets and spaces
    final RegExp alphabetsPattern = RegExp(r'^[A-Za-z\s]+$');
    if (!alphabetsPattern.hasMatch(regionName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Region name should consist of alphabets. number and special character  are not allowed'),
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
      await FirebaseFirestore.instance
          .collection('Region')
          .doc(regionName)
          .set({
        'name': regionName,
        // You can add more fields if needed
      });

      // Add the new region to the UI
      setState(() {
        regionDataList.add(regionName);
      });

      // Clear the text field after adding the region
      regionNameController.clear();
      // Show a success message using AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Region added successfully!'),
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
      print('Error adding region: $e');
    }
  }

  Future<void> updateRegionName(
      String currentRegionName, String updatedRegionName) async {
    // Define a regular expression pattern to match only alphabets and spaces
    final RegExp alphabetsPattern = RegExp(r'^[A-Za-z\s]+$');
    if (!alphabetsPattern.hasMatch(updatedRegionName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Region name should consist of alphabets. number and special character  are not allowed'),
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

    if (regionDataList.contains(updatedRegionName)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Region name already exists'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    regionNameController.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return;
    }

    try {
      // Check if the updated name is different from the current name
      // if (currentRegionName != updatedRegionName) {
      //   await FirebaseFirestore.instance
      //       .collection('Region')
      //       .doc(currentRegionName)
      //       .delete(); // Delete the current document
      //
      //   // Create a new document with the updated name
      //   await FirebaseFirestore.instance
      //       .collection('Region')
      //       .doc(updatedRegionName)
      //       .set({
      //     'name': updatedRegionName,
      //     // You can add more fields if needed
      //   });
      // }

      if (currentRegionName != updatedRegionName) {
        await FirebaseFirestore.instance
            .collection('Region')
            .doc(currentRegionName)
            .update({'name': updatedRegionName});
      }

      // Update the region name in the UI
      setState(() {
        int index = regionDataList.indexOf(currentRegionName);
        if (index != -1) {
          regionDataList[index] = updatedRegionName;
        }
      });

      // Show a success message using AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Region name updated successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  regionNameController.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors here.
      print('Error updating region name: $e');
    }
  }

  void handleUpdateRegionName(
      String currentRegionName, String updatedRegionName) {
    if (currentRegionName != updatedRegionName) {
      // Call the updateRegionName function
      updateRegionName(currentRegionName, updatedRegionName);
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

  Future<void> _showDeleteConfirmationDialog(String regionId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this region?'),
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
                deleteRegion(regionId); // Delete the region
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRegion(); // Fetch regions when the screen initializes
  }

  @override
  void dispose() {
    regionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Region'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/reg manager.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 300),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: regionNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter region name',
                        ),
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
                          String regionName = regionNameController.text.trim();
                          if (regionName.isNotEmpty) {
                            addRegion(regionName);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: regionDataList.length,
                  itemBuilder: (context, index) {
                    final regionName = regionDataList[index];

                    return Padding(
                        padding: EdgeInsets.fromLTRB(
                            30, 8, 16, 10), // Adjust the padding as needed
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RouteManagerScreen(
                                        selectregion: regionName,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  ' ${regionName.toUpperCase()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmationDialog(regionName);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // When the edit button is pressed, show a dialog for editing the region name
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Edit Region Name'),
                                      content: TextField(
                                        controller: updatedRegionNameController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter updated region name',
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
                                          onPressed: () {
                                            String updatedRegionName =
                                                updatedRegionNameController.text
                                                    .trim();

                                            // Check constraints for the updated region name
                                            final RegExp alphabetsPattern =
                                                RegExp(r'^[A-Za-z]+$');
                                            if (!alphabetsPattern
                                                .hasMatch(updatedRegionName)) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Error'),
                                                    content: Text(
                                                      'Region name should consist of alphabets only. Spaces, numbers, and special characters are not allowed.',
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              // Update the region name in Firestore
                                              updateRegionName(regionName,
                                                  updatedRegionName);

                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
