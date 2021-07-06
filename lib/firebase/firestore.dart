import 'package:alumnimeet/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<void> addUserToCollection(
  User? user,
  String? phoneNumber,
) async {
  //now below I am getting an instance of firebase firestore then getting the user collection
  //now I am creating the document if not already exist and setting the data.
  FirebaseFirestore.instance.collection(USER_COLLECTION).doc(user?.uid).set({
    USER_ID: user?.uid,
    EMAIL_ID : user?.email,
    NAME : user?.displayName,
    PROFILE_PIC: user?.photoURL,
    PHONE : phoneNumber,
  },SetOptions(merge: true)).whenComplete(() {
    print("User added successfully");
  }).catchError((e) => print(e));

  return;
}

//get all users excluding current user using not equal (one-time read)
Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers(String uid) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection(USER_COLLECTION)
      .orderBy(NAME)
      .where('uid', isNotEqualTo: uid)
      .get();
  return snapshot;
}

Stream<DocumentSnapshot> documentSnapShot(String uid) {
  return FirebaseFirestore.instance.collection(USER_COLLECTION).doc(uid).snapshots();
}

Stream<QuerySnapshot> collectionQuerySnapShot() {
  return FirebaseFirestore.instance
      .collection(USER_COLLECTION)
      .orderBy(NAME)
      .snapshots();
}


updateWorkAndEducationInfo(
    String uid, Map<String, dynamic> valueMap, bool isWork) {
  String field = isWork ? WORK : EDU;
  FirebaseFirestore.instance
      .collection(USER_COLLECTION)
      .doc(uid)
      .set({field: valueMap}, SetOptions(merge: true));
}

updateContactAndPersonalInfo(String uid, Map<String, dynamic> valueMap) {
  FirebaseFirestore.instance
      .collection(USER_COLLECTION)
      .doc(uid)
      .set(valueMap, SetOptions(merge: true));
}

updateUserCurrentLocation(String uid, Position position) {
  FirebaseFirestore.instance.collection(USER_COLLECTION).doc(uid).set({
    LAT: position.latitude,
    LNG: position.longitude,
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

bool doesFieldExistsInDoc(DocumentSnapshot snapshot, String fieldName) {
  try {
    snapshot.get(fieldName);
    return true;
  } on StateError catch (e) {
    return false;
  }
}
