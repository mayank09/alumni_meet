import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/util/customCard.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlumniDirectoryPage extends StatefulWidget {
  final User user;

  const AlumniDirectoryPage({Key? key, required this.user}) : super(key: key);

  @override
  _AlumniDirectoryPageState createState() => _AlumniDirectoryPageState();
}

class _AlumniDirectoryPageState extends State<AlumniDirectoryPage> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FireStore.collectionQuerySnapShot(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      if (document['userid'].toString() == _currentUser.uid) {
                        return new Container();
                      }
                      return new CustomCard(
                        userid: document['userid'],
                        name: document['name'],
                        email: document['email'],
                        phone: document['phoneNumber'],
                        photoURL: document['profilePic'],
                      );
                    }).toList(),
                  );
              }
            },
          )),
    ));
  }
}
