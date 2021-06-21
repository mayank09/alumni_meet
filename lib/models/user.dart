import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/models/education.dart';
import 'package:alumnimeet/models/work.dart';
import 'package:alumnimeet/util/constants.dart';
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
        snapshot[USER_ID],
        snapshot[NAME],
        snapshot[EMAIL_ID],
        snapshot[PHONE] ?? null,
        snapshot[PROFILE_PIC] ?? null,
        FireStore.doesFieldExistsInDoc(snapshot, LINK)
            ? snapshot[LINK]
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, DOB)
            ? DateFormat(BIRTHDAY_FORMAT).format(snapshot[DOB].toDate())
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, HOMETOWN)
            ? snapshot[HOMETOWN]
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, LAT)
            ? snapshot[LAT]
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, LNG)
            ? snapshot[LNG]
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, WORK)
            ? Work.fromSnapshot(snapshot)
            : null,
        FireStore.doesFieldExistsInDoc(snapshot, EDU)
            ? Education.fromSnapshot(snapshot)
            : null);
  }

  factory User.fromAsyncDocumentSnapShot(
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    return User(
        snapshot.data!.get(USER_ID),
        snapshot.data!.get(NAME),
        snapshot.data!.get(EMAIL_ID) ?? null,
        snapshot.data!.get(PHONE) ?? null,
        snapshot.data![PROFILE_PIC] ?? null,
        FireStore.doesFieldExists(snapshot, LINK)
            ? snapshot.data![LINK]
            : null,
        FireStore.doesFieldExists(snapshot, DOB)
            ? DateFormat(BIRTHDAY_FORMAT).format(snapshot.data![DOB].toDate())
            : null,
        FireStore.doesFieldExists(snapshot, HOMETOWN)
            ? snapshot.data![HOMETOWN]
            : null,
        FireStore.doesFieldExists(snapshot,LAT)
            ? snapshot.data![LAT]
            : null,
        FireStore.doesFieldExists(snapshot, LNG)
            ? snapshot.data![LNG]
            : null,
        FireStore.doesFieldExists(snapshot, WORK)
            ? Work.fromAsyncSnapshot(snapshot)
            : null,
        FireStore.doesFieldExists(snapshot, EDU)
            ? Education.fromAsyncSnapshot(snapshot)
            : null);
  }
}
