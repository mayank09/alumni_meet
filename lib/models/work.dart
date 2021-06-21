import 'package:alumnimeet/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Work {
  final String? org;
  final String? city;
  final String? jobTitle;
  final String? from;
  final String? to;
  final bool isPresent;

  Work(this.org, this.city, this.jobTitle, this.from, this.to, this.isPresent);

  //create Work model object from fireStore document snapshot
  factory Work.fromSnapshot(DocumentSnapshot snapshot) {
    return Work(
        snapshot[WORK][ORG],
        snapshot[WORK][CITY],
        snapshot[WORK][JOB_TITLE],
        DateFormat(WORK_FORMAT).format(snapshot[WORK][FROM]!.toDate()),
        snapshot[WORK][IS_PRESENT]
            ? null
            : DateFormat(WORK_FORMAT).format(snapshot[WORK][TO].toDate()),
        snapshot[WORK][IS_PRESENT] ?? true);
  }

  factory Work.fromAsyncSnapshot(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Work(
        snapshot.data![WORK][ORG],
        snapshot.data![WORK][CITY],
        snapshot.data![WORK][JOB_TITLE],
        DateFormat(WORK_FORMAT).format(snapshot.data![WORK][FROM]!.toDate()),
        snapshot.data![WORK][IS_PRESENT]
            ? null
            : DateFormat(WORK_FORMAT)
                .format(snapshot.data![WORK][TO].toDate()),
        snapshot.data![WORK][IS_PRESENT] ?? true);
  }

   Map<String, dynamic> toJson() => {
    'org': org,
    'city': city,
    'job_title': jobTitle,
    'from': from != null ? DateFormat("MMMM y").parse(from!) : null,
    'to': from != null ? DateFormat("MMMM y").parse(to!) : null,
    'isPresent': isPresent,
  };
}
