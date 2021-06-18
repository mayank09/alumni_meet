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
        snapshot['work']['org'],
        snapshot['work']['city'],
        snapshot['work']['job_title'],
        DateFormat("MMMM y").format(snapshot['work']['from']!.toDate()),
        snapshot['work']['isPresent']
            ? null
            : DateFormat("MMMM y").format(snapshot['work']['to'].toDate()),
        snapshot['work']['isPresent'] ?? true);
  }

  factory Work.fromAsyncSnapshot(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Work(
        snapshot.data!['work']['org'],
        snapshot.data!['work']['city'],
        snapshot.data!['work']['job_title'],
        DateFormat("MMMM y").format(snapshot.data!['work']['from']!.toDate()),
        snapshot.data!['work']['isPresent']
            ? null
            : DateFormat("MMMM y")
                .format(snapshot.data!['work']['to'].toDate()),
        snapshot.data!['work']['isPresent'] ?? true);
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
