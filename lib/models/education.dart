import 'package:alumnimeet/util/constants.dart';
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
        snapshot[EDU][ORG],
        snapshot[EDU][CITY],
        snapshot[EDU][COURSE],
        DateFormat(WORK_FORMAT).format(snapshot[EDU][FROM]!.toDate()),
        snapshot[EDU][IS_PRESENT]
            ? null
            : DateFormat(WORK_FORMAT).format(snapshot[EDU][TO].toDate()),
        snapshot[EDU][IS_PRESENT] ?? true);
  }

  factory Education.fromAsyncSnapshot(
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Education(
        snapshot.data![EDU][ORG],
        snapshot.data![EDU][CITY],
        snapshot.data![EDU][COURSE],
        DateFormat(WORK_FORMAT)
            .format(snapshot.data![EDU][FROM]!.toDate()),
        snapshot.data![EDU][IS_PRESENT]
            ? null
            : DateFormat(WORK_FORMAT)
                .format(snapshot.data![EDU][TO].toDate()),
        snapshot.data![EDU][IS_PRESENT] ?? true);
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
