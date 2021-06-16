import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/util/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends StatefulWidget {
  final String userid;
  final bool isCurrentUser;

  const UserProfilePage(
      {Key? key, required this.userid, required this.isCurrentUser})
      : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String _userid;
  late bool _isCurrentUser;

  @override
  void initState() {
    _userid = widget.userid;
    _isCurrentUser = widget.isCurrentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !_isCurrentUser ? AppBar(title: Text("Alumni Profile")) : null,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(5.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FireStore.documentSnapShot(_userid),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      bool isWork = FireStore.doesFieldExists(snapshot, 'work');
                      bool isEducation =
                          FireStore.doesFieldExists(snapshot, 'education');
                      return Column(
                        children: [
                          ProfileHeaderCard(
                            email: snapshot.data!.get('email'),
                            phone: snapshot.data!.get('phoneNumber'),
                            name: snapshot.data!.get('name'),
                            photoURL: snapshot.data?.get('profilePic') != null
                                ? snapshot.data?.get('profilePic')
                                : null,
                            url: FireStore.doesFieldExists(snapshot, 'link')
                                ? snapshot.data!.get('link')
                                : null,
                            isCurrentUser: _isCurrentUser,
                            userId: _userid,
                          ),
                          ProfessionalDetails(
                              userId: _userid,
                              isProfessional: true,
                              title: "Professional Details",
                              org:
                                  isWork ? snapshot.data!['work']['org'] : null,
                              city: isWork
                                  ? snapshot.data!['work']['city']
                                  : null,
                              designation: isWork
                                  ? snapshot.data!['work']['job_title']
                                  : null,
                              start: isWork
                                  ? DateFormat("MMMM y").format(
                                      snapshot.data!['work']['from'].toDate())
                                  : null,
                              complete: isWork
                                  ? snapshot.data!['work']['isPresent']
                                      ? null
                                      : DateFormat("MMMM y").format(
                                          snapshot.data?['work']['to'].toDate())
                                  : null,
                              isPresent: isWork
                                  ? snapshot.data!['work']['isPresent']
                                  : true,
                              isCurrentUser: _isCurrentUser),
                          ProfessionalDetails(
                            userId: _userid,
                            isProfessional: false,
                            title: "Education Details",
                            org: isEducation
                                ? snapshot.data!['education']['org']
                                : null,
                            city: isEducation
                                ? snapshot.data!['education']['city']
                                : null,
                            designation: isEducation
                                ? snapshot.data!['education']['course']
                                : null,
                            start: isEducation
                                ? DateFormat("MMMM y").format(snapshot
                                    .data!['education']['from']
                                    .toDate())
                                : null,
                            complete: isEducation
                                ? snapshot.data!['education']['isPresent']
                                    ? null
                                    : DateFormat("MMMM y").format(snapshot
                                        .data!['education']['to']
                                        .toDate())
                                : null,
                            isPresent: isEducation
                                ? snapshot.data!['education']['isPresent']
                                : true,
                            isCurrentUser: _isCurrentUser,
                          ),
                          PersonalDetails(
                              userId: _userid,
                              isCurrentUser: _isCurrentUser,
                              birthday: FireStore.doesFieldExists(
                                      snapshot, 'dob')
                                  ? DateFormat("dd-MM-yyyy")
                                      .format(snapshot.data!['dob'].toDate())
                                  : null,
                              city: FireStore.doesFieldExists(
                                      snapshot, 'hometown')
                                  ? snapshot.data!.get('hometown')
                                  : null,
                              lat: FireStore.doesFieldExists(snapshot, 'lat')
                                  ? snapshot.data!.get('lat')
                                  : null,
                              lng: FireStore.doesFieldExists(snapshot, 'lng')
                                  ? snapshot.data!.get('lng')
                                  : null)
                        ],
                      );
                  }
                },
              )),
        ));
  }
}
