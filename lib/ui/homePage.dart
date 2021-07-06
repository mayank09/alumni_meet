import 'package:alumnimeet/firebase/fire_auth.dart' as FireAuth;
import 'package:alumnimeet/ui/aboutus.dart';
import 'package:alumnimeet/ui/alumniDirectory.dart';
import 'package:alumnimeet/ui/userProfilePage.dart';
import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'language.dart';
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

  int _currentIndex = 0;
  late List<Widget> _children;

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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _currentUser = widget.user;
    _children = [
      UserProfilePage(userid: _currentUser.uid, isCurrentUser: true),
      AlumniDirectoryPage(
        user: _currentUser,
      ),
      AboutUsPage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(HOME),
/*          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: "My Profile"),
              Tab(icon: Icon(Icons.contact_page), text: "Alumni Directory")
            ],
          ),*/
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              label: MY_PROFILE,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.contact_page),
              label: ALUM_DIR,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.description),
              label: ABT_US,
            )
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          elevation: 5,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(8),
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text(_currentUser.displayName.toString()),
                  accountEmail: Text(_currentUser.email.toString()),
                  currentAccountPicture: PhotoWidget(
                      url: _currentUser.photoURL,
                      name: _currentUser.displayName)),
              ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(SETTINGS),
                  onTap: () {}),
              ListTile(
                  leading: Icon(Icons.language_outlined),
                  title: LocaleText('language'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LanguagePage()),
                    );
                  }),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(LOGOUT),
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      _isSigningOut = true;
                    });
                    await FireAuth.logout(_currentUser);
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context)
                        .pushReplacement(_routeToSignInScreen());
                    /*Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );*/
                    /*Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);*/
                  })
            ],
          ),
        ),
        body: _isSigningOut
            ? CircularProgressIndicator()
            : _children[_currentIndex]
/*          TabBarView(children: [
                UserProfilePage(
                    userid: _currentUser.uid, isCurrentUser: true),
                AlumniDirectoryPage(
                  user: _currentUser,
                )
              ])*/
        );
  }
}
