import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/models/user.dart';
import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
        appBar: !_isCurrentUser ? AppBar(title: Text(ALUM_LABEL)) : null,
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
                      return Container(child: new Center(child: CircularProgressIndicator()));
                    default:
                      User user = User.fromAsyncDocumentSnapShot(snapshot);
                      return Column(
                        children: [
                          ProfileHeaderCard(
                            email: user.email,
                            phone: user.phoneNumber,
                            name: user.name,
                            photoURL: user.profilePic,
                            url: user.link,
                            isCurrentUser: _isCurrentUser,
                            userId: _userid,
                          ),
                          ProfessionalDetails(
                              userId: _userid,
                              isProfessional: true,
                              title: PRO_DETAILS,
                              org: user.work?.org,
                              city: user.work?.city,
                              designation: user.work?.jobTitle,
                              start: user.work?.from,
                              complete: user.work?.to,
                              isPresent: user.work?.isPresent != null
                                  ? user.work!.isPresent
                                  : true,
                              isCurrentUser: _isCurrentUser),
                          ProfessionalDetails(
                            userId: _userid,
                            isProfessional: false,
                            title: EDU_DETAILS,
                            org: user.education?.org,
                            city: user.education?.city,
                            designation: user.education?.course,
                            start: user.education?.from,
                            complete: user.education?.to,
                            isPresent: user.education?.isPresent != null
                                ? user.education!.isPresent
                                : true,
                            isCurrentUser: _isCurrentUser,
                          ),
                          PersonalDetails(
                              userId: _userid,
                              isCurrentUser: _isCurrentUser,
                              birthday: user.dob,
                              city: user.homeTown,
                              lat: user.lat,
                              lng: user.lng)
                        ],
                      );
                  }
                },
              )),
        ));
  }
}
