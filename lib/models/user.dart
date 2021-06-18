import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/models/education.dart';
import 'package:alumnimeet/models/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User {
  final String userid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePic;
  final String? link;
  final String? dob;
  final String? homeTown;
  final double? lat;
  final double? lng;
  final Work? work;
  final Education? education;

  User(
      this.userid,
      this.name,
      this.email,
      this.phoneNumber,
      this.profilePic,
      this.link,
      this.dob,
      this.homeTown,
      this.lat,
      this.lng,
      this.work,
      this.education);

  factory User.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    return User(
        snapshot['userid'],
        snapshot['name'],
        snapshot['email'],
        snapshot['phoneNumber'] ?? null,
        snapshot['profilePic'] ?? null,
        FireStore.doesFieldExistsInDoc(snapshot, 'link')
            ? snapshot['link']
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, 'dob')
            ? DateFormat("dd-MM-yyyy").format(snapshot['dob'].toDate())
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, 'hometown')
            ? snapshot['hometown']
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, 'lat')
            ? snapshot['lat']
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, 'lng')
            ? snapshot['lng']
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, 'work')
            ? Work.fromSnapshot(snapshot)
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, 'education')
            ? Education.fromSnapshot(snapshot)
            : null);
  }

  factory User.fromAsyncDocumentSnapShot(
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    return User(
        snapshot.data!.get('userid'),
        snapshot.data!.get('name'),
        snapshot.data!.get('email') ?? null,
        snapshot.data!.get('phoneNumber') ?? null,
        snapshot.data!['profilePic'] ?? null,
        FireStore.doesFieldExists(snapshot, 'link')
            ? snapshot.data!['link']
            : null,
        FireStore.doesFieldExists(snapshot, 'dob')
            ? DateFormat("dd-MM-yyyy").format(snapshot.data!['dob'].toDate())
            : null,
        FireStore.doesFieldExists(snapshot, 'hometown')
            ? snapshot.data!['hometown']
            : null,
        FireStore.doesFieldExists(snapshot, 'lat')
            ? snapshot.data!['lat']
            : null,
        FireStore.doesFieldExists(snapshot, 'lng')
            ? snapshot.data!['lng']
            : null,
        FireStore.doesFieldExists(snapshot, 'work')
            ? Work.fromAsyncSnapshot(snapshot)
            : null,
        FireStore.doesFieldExists(snapshot, 'education')
            ? Education.fromAsyncSnapshot(snapshot)
            : null);
  }
}
