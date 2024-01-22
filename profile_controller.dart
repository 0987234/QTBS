// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:test_project/Authentication/Auth_reprository/User_Repository/user_repository.dart';
// import 'package:test_project/Authentication/auth_controller.dart';
//
// import '../../../Authentication/models/User_model.dart';
//
// class ProfileController extends GetxController {
//   static ProfileController get instance => Get.find();
//
//   final _authRepo = Get.put(Authcontroller());
//   final _userRepo = Get.put(UserRepository());
//
//   getUserData() {
//     // final email = _authRepo.auth.value?.email;
//
//     final email = _authRepo.auth.currentUser?.email;
//     print("updata:email:$email");
//     if (email != null) {
//       return _userRepo.getUserDetails(email);
//     } else {
//       Get.snackbar("Error", "Login to continue");
//     }
//   }
//
//   Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();
//
//   updateRecord(UserModel user) async {
//     await _userRepo.UpdateUserRecord(user);
//   }
// }

// Future<void> updateRecord(UserModel user) async {
//   try {
//     await _userRepo.UpdateUserRecord(user);
//     print("User profile updated successfully");
//   } catch (e) {
//     print("Error updating user profile: $e");
//   }

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_project/Authentication/Auth_reprository/User_Repository/user_repository.dart';
import 'package:test_project/Authentication/auth_controller.dart';

//
// class ProfileController extends GetxController {
//   static ProfileController get instance => Get.find();
//
//   final _authRepo = Get.put(Authcontroller());
//   final _userRepo = Get.put(UserRepository());
//
//   getUserData() {
//     // final email = _authRepo.auth.value?.email;
//
//     final email = _authRepo.auth.currentUser?.email;
//     print("updata:email:$email");
//     if (email != null) {
//       return _userRepo.getUserDetails(email);
//     } else {
//       Get.snackbar("Error", "Login to continue");
//     }
//   }
//
//
//   void _handleUpdateEmailAndAddress() async {
//     final newEmail = emailController.text;
//     final newAddress = addressController.text;
//
//     // Get the current user's data
//     final currentUser = ProfileController.instance.getUserData();
//
//     if (currentUser != null) {
//       // Create a new user model with the updated email and address
//       final updatedUser = UserModel(
//         fullName: currentUser.fullName,
//         email: newEmail,
//         phoneNo: currentUser.phoneNo,
//         Sapid: currentUser.Sapid,
//         Address: newAddress,
//         Password: currentUser.Password,
//         ConfirmPassword: currentUser.ConfirmPassword,
//       );
//
//       // Update the user record in Firestore
//       await ProfileController.instance.updateRecord(updatedUser);
//     } else {
//       // Handle the case where the current user is not available (e.g., not logged in)
//       Get.snackbar("Error", "Login to continue");
//     }
//   }
//
//     }
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_project/Authentication/Auth_reprository/User_Repository/user_repository.dart';
import 'package:test_project/Authentication/auth_controller.dart';
import 'package:test_project/Authentication/models/User_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(Authcontroller(selectRoute: '', fees: ''));
  final _userRepo = Get.put(UserRepository());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  getUserData() {
    final email = _authRepo.auth.currentUser?.email;
    print("update: email: $email");
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }

  void handleUpdateEmailAndAddress(String newEmail, String newAddress) async {
    final currentUser = await getUserData(); // Make sure to await the result

    if (currentUser != null) {
      try {
        await _userRepo.updateUserEmailAndAddress(
          currentUser.email,
          newEmail,
          newAddress,
        );
        print(
            "Email and address updated successfully for ${currentUser.email}");
      } catch (e) {
        print("Error updating email and address: $e");
      }
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }

// Rest of your controller code...
}
