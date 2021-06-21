import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/models/user.dart' as UserModel;
import 'package:alumnimeet/util/constants.dart';
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

  TextEditingController _searchController = TextEditingController();

  Future? resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    _currentUser = widget.user;
    _searchController.addListener(_onSearchChange);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersSnapShot();
  }

  _onSearchChange() {
    searchResultsList();
    print(_searchController.text);
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var userSnapshot in _allResults) {
        UserModel.User user = UserModel.User.fromDocumentSnapShot(userSnapshot);
        if (user.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            user.email
                .toLowerCase()
                .contains(_searchController.text.toLowerCase())) {
          showResults.add(userSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersSnapShot() async {
    var data = await FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .orderBy(NAME)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _resultsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserModel.User user = UserModel.User.fromDocumentSnapShot(
                        _resultsList[index]);
                    if (user.userid == _currentUser.uid) return Container();
                    return CustomCard(
                        userid: user.userid,
                        name: user.name,
                        email: user.email,
                        phone: user.phoneNumber,
                        photoURL: user.profilePic);
                  })),
        ],
      )),
    ));
  }
}
