import 'package:alumnimeet/firebase/fire_auth.dart' as FireAuth;
import 'package:alumnimeet/ui/alumniDirectory.dart';
import 'package:alumnimeet/ui/userProfilePage.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginPage.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _currentUser;

  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person), text: "My Profile"),
                Tab(icon: Icon(Icons.contact_page), text: "Alumni Directory")
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                UserAccountsDrawerHeader(
                    accountName: Text(_currentUser.displayName.toString()),
                    accountEmail: Text(_currentUser.email.toString()),
                    currentAccountPicture: PhotoWidget(url: _currentUser.photoURL,name: _currentUser.displayName
                    )),
                ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () {}),
                ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () async {
                      //Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          LoginPage()), (Route<dynamic> route) => false);
                      setState(() {
                        _isSigningOut = true;
                      });
                      FireAuth.logout();
                      setState(() {
                        _isSigningOut = false;
                      });
                      /*Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );*/
                      Navigator.of(context)
                          .pushReplacement(_routeToSignInScreen());
                    })
              ],
            ),
          ),
          body: _isSigningOut
              ? CircularProgressIndicator()
              : TabBarView(
                  children: [UserProfilePage(userid: _currentUser.uid, isCurrentUser: true), AlumniDirectoryPage(user: _currentUser,)])),
    );
  }
}
