import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_packageInfo.appName,
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.blueAccent,
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                VER + _packageInfo.version,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
                "Alumni Meet helps simplify and encourage alumni engagement activities, thereby leveraging the power of alumni relationships. It is the easiest way to connect with classmates and peers wherever we are in the world.Empowering alumni to not only connect with each other, but also back with the university is one of the most important functions of an alumni association. Because alumni hold shared experiences as students of their school, this lends itself to powerful networking opportunities; whether it’s in the form of class reunions or volunteer events. Even in their local communities, alumni can form affinity networks to pursue common interests with their peers.",
                textAlign: TextAlign.justify),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(CONTACT_US,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold))),
            ),
            InkwellWithIconClickable(
                iconData: Icons.email, title: ADMIN_EMAIL, isClickable: true),
            InkwellWithIconClickable(
                iconData: Icons.phone, title: ADMIN_PHONE, isClickable: true),
          ],
        ),
      ),
    );
  }
}
