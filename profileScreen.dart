import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_project/Authentication/models/User_model.dart';
import 'package:test_project/UI/module/Student/HomeScreen/Homee.dart';
import 'package:test_project/UI/module/Student/Profile/profile_controller.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EditProfile(
        selectRoute: '',
        fees: '',
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  final String selectRoute;
  final String fees;

  EditProfile({required this.selectRoute, required this.fees});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController profileController = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isObscurePassword = true;

  File? profileImage;

  bool hasError = false;
  // Future<void> _pickImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     // Check the file size (in bytes)
  //     final fileSize = File(pickedFile.path).lengthSync();
  //
  //     if (fileSize > 1048576) {
  //       // Image size exceeds 1MB (1048576 bytes)
  //       _showErrorDialog('Image Size Exceeded',
  //           'The selected image exceeds the 1MB size limit.');
  //
  //       setState(() {
  //         hasError = true;
  //       });
  //     } else {
  //       // Image size is within the limit
  //       final fileExtension = pickedFile.path.split('.').last.toLowerCase();
  //       if (fileExtension != 'jpg' && fileExtension != 'png') {
  //         _showErrorDialog(
  //             'Invalid Image Format', 'Please select a JPG or PNG image.');
  //         setState(() {
  //           hasError = true;
  //         });
  //       } else {
  //         setState(() {
  //           hasError = false;
  //           profileImage = File(pickedFile.path);
  //         });
  //       }
  //     }
  //   }
  // }
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileSize = File(pickedFile.path).lengthSync();

      if (fileSize > 1048576) {
        _showErrorDialog('Image Size Exceeded',
            'The selected image exceeds the 1MB size limit.');

        setState(() {
          hasError = true;
        });
      } else {
        final fileExtension = pickedFile.path.split('.').last.toLowerCase();
        if (fileExtension != 'jpg' && fileExtension != 'png') {
          _showErrorDialog(
              'Invalid Image Format', 'Please select a JPG or PNG image.');
          setState(() {
            hasError = true;
          });
        } else {
          // Upload image to Firebase Storage
          await _uploadImageToStorage(File(pickedFile.path));

          setState(() {
            hasError = false;
            profileImage = File(pickedFile.path);
          });
        }
      }
    }
  }

  // Future<void> _uploadImageToStorage(File imageFile) async {
  //   try {
  //     final storageRef = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('user_images/${DateTime.now().millisecondsSinceEpoch}');
  //
  //     await storageRef.putFile(imageFile);
  //   } catch (e) {
  //     print('Error uploading image to storage: $e');
  //     // Handle error as needed
  //   }
  // }

  Future<void> _uploadImageToStorage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Upload image to Firebase Storage
        final storageRef = firebase_storage.FirebaseStorage.instance.ref().child(
            'user_images/${user.uid}_${DateTime.now().millisecondsSinceEpoch}');

        await storageRef.putFile(imageFile);

        // Get download URL for the uploaded image
        final imageUrl = await storageRef.getDownloadURL();

        // Update user data in Firestore with the new image URL
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'profileImageUrl': imageUrl,
        });
      }
    } catch (e) {
      print('Error uploading image to storage: $e');
      // Handle error as needed
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  selectRoute: widget.selectRoute,
                  fees: widget.fees,
                  busnumber: '',
                  voucherDocumentID: '',
                  voucherURL: '',
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: Container(
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;

                  final fullname = TextEditingController(text: user.fullName);
                  final userEmailController =
                      TextEditingController(text: user.email);
                  final sapid = TextEditingController(text: user.Sapid);
                  // final addressController =
                  //     TextEditingController(text: user.Address);
                  final phoneno = TextEditingController(text: user.phoneNo);
                  final password = TextEditingController(text: user.Password);
                  final confirmpassword =
                      TextEditingController(text: user.ConfirmPassword);

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                    )
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: profileImage != null
                                        ? FileImage(profileImage!)
                                            as ImageProvider // Use the selected image
                                        : AssetImage('assets/person_icon.png')
                                            as ImageProvider, // Fallback asset image
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: Positioned(
                                  bottom: 300,
                                  right: 10,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed:
                                        _pickImage, // Call your image picker function here
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 150, right: 10, bottom: 0),
                                child: ElevatedButton(
                                  onPressed: _removeImage,
                                  child: Text('Remove Image'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 100, right: 10, bottom: 0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: fullname,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        hintText: 'Full name ',
                                        suffixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: userEmailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        hintText: 'Email',
                                        suffixIcon: Icon(Icons.edit),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: phoneno,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: 'phone no',
                                        suffixIcon: Icon(Icons.edit),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: sapid,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: 'Sap Id',
                                        suffixIcon: Icon(Icons.numbers),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // TextFormField(
                                    //   controller: addressController,
                                    //   keyboardType: TextInputType.text,
                                    //   decoration: const InputDecoration(
                                    //     hintText: 'Address',
                                    //     suffixIcon: Icon(Icons.edit),
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: password,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: 'password',
                                        suffixIcon: Icon(Icons.password),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final newEmail =
                                          userEmailController.text.trim();
                                      final newAddress =
                                          addressController.text.trim();
                                      profileController
                                          .handleUpdateEmailAndAddress(
                                              newEmail, newAddress);

                                      final updatedUserData = UserModel(
                                        Sapid: sapid.text.trim(),
                                        fullName: fullname.text.trim(),
                                        email: newEmail,
                                        phoneNo: phoneno.text.trim(),
                                        // Address: newAddress,
                                        Address: '',
                                        Password: password.text.trim(),
                                        ConfirmPassword:
                                            confirmpassword.text.trim(),
                                        role: '',
                                        profileImageUrl: '',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      side: BorderSide.none,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
