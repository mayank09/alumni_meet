import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Education {
  final String? org;
  final String? city;
  final String? course;
  final String? from;
  final String? to;
  final bool isPresent;

  Education(
      this.org, this.city, this.course, this.from, this.to, this.isPresent);

  //create Education model object from fireStore document snapshot
  factory Education.fromSnapshot(DocumentSnapshot snapshot) {
    return Education(
        snapshot['education']['org'],
        snapshot['education']['city'],
        snapshot['education']['course'],
        DateFormat("MMMM y").format(snapshot['education']['from']!.toDate()),
        snapshot['education']['isPresent']
            ? null
            : DateFormat("MMMM y").format(snapshot['education']['to'].toDate()),
        snapshot['education']['isPresent'] ?? true);
  }

  factory Education.fromAsyncSnapshot(
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Education(
        snapshot.data!['education']['org'],
        snapshot.data!['education']['city'],
        snapshot.data!['education']['course'],
        DateFormat("MMMM y")
            .format(snapshot.data!['education']['from']!.toDate()),
        snapshot.data!['education']['isPresent']
            ? null
            : DateFormat("MMMM y")
                .format(snapshot.data!['education']['to'].toDate()),
        snapshot.data!['education']['isPresent'] ?? true);
  }

  // formatting for upload to Firebase when creating the education section
  Map<String, dynamic> toJson() => {
        'org': org,
        'city': city,
        'course': course,
        'from': from != null ? DateFormat("MMMM y").parse(from!) : null,
        'to': from != null ? DateFormat("MMMM y").parse(to!) : null,
        'isPresent': isPresent,
      };

//if you want to get arguments as a Map and create model
/*
  Education({this.org, this.city, this.course, this.from, this.to,
    this.isPresent});

  Education.fromMap(Map map):
      this(
        org : map['org'],
        city: map['city'],
        course: map['course'],
        from: map['from'],
        to : map['to'],
        isPresent : map['isPesent']
      );

}*/
}
