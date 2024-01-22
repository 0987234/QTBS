import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../../models/User_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instances => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    try {
      // Generate a unique userId based on the user's email
      final userId = user.email.hashCode.toString();

      await _db.collection("Users").doc(userId).set(user.toJson());
      print("User data saved successfully with userId: $userId");
    } catch (e) {
      print("Error saving user data: $e");
      // Handle the error here (e.g., show an error message to the user).
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();

    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    return userData;
  }

  Future<List<UserModel>> allUsers() async {
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs
        .map((e) =>
            UserModel.fromSnapshot(e.data() as DocumentSnapshot<Object?>))
        .toList();
    return userData;
  }

  // Future<void> UpdateUserRecord(UserModel user) async {
  //   await _db.collection("Users").doc(user.email).update(user.toJson());
  // }

  Future<void> updateUserEmailAndAddress(
      String userId, String newEmail, String newAddress) async {
    try {
      await _db.collection("Users").doc(userId).update({
        'Email': newEmail,
        'Address': newAddress,
      });
      print("User email and address updated succefully for : $userId");
    } catch (e) {
      print("Error updating user email and address:$e");
    }
  }
}
