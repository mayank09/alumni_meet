import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<void> addUserToCollection(
  User? user,
  phoneNumber,
) async {
  //now below I am getting an instance of firebase firestore then getting the user collection
  //now I am creating the document if not already exist and setting the data.
  FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
    'userid': user?.uid,
    'email': user?.email,
    'name': user?.displayName,
    'profilePic': user?.photoURL,
    'phoneNumber': phoneNumber,
  },SetOptions(merge: true)).whenComplete(() {
    print("User added successfully");
  }).catchError((e) => print(e));

  return;
}

//get all users excluding current user using not equal (one-time read)
Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers(String uid) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('users')
      .orderBy("name")
      .where('uid', isNotEqualTo: uid)
      .get();
  return snapshot;
}

Stream<DocumentSnapshot> documentSnapShot(String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
}

Stream<QuerySnapshot> collectionQuerySnapShot() {
  return FirebaseFirestore.instance
      .collection("users")
      .orderBy("name")
      .snapshots();
}

updateWorkAndEducationInfo(
    String uid, Map<String, dynamic> valueMap, bool isWork) {
  String field = isWork ? "work" : "education";
  FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .set({field: valueMap}, SetOptions(merge: true));
}

updateContactAndPersonalInfo(String uid, Map<String, dynamic> valueMap) {
  FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .set(valueMap, SetOptions(merge: true));
}

updateUserCurrentLocation(String uid, Position position) {
  FirebaseFirestore.instance.collection("users").doc(uid).set({
    "lat": position.latitude,
    "lng": position.longitude,
  }, SetOptions(merge: true));
}

bool doesFieldExists(
    AsyncSnapshot<DocumentSnapshot> snapshot, String fieldName) {
  try {
    snapshot.data!.get(fieldName);
    return true;
  } on StateError catch (e) {
    return false;
  }
}
