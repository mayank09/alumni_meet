import 'package:alumnimeet/ui/userProfilePage.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name, email, userid;
  final String? phone;
  final String? url, photoURL;

  CustomCard(
      {required this.name,
      required this.email,
      required this.phone,
      this.url,
      this.photoURL,
      required this.userid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          /** Push a new page while passing data to it */
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UserProfilePage(userid: userid, isCurrentUser: false)));
        },
        child:
            /*Card(
          child: Row(
        children: [
          PhotoWidget(url: imageURL, name: name),
          Expanded(
            child: Column(
              children: [
                InkwellWithIconClickable(iconData: Icons.person, title: name),
                InkwellWithIconClickable(
                  iconData: Icons.email,
                  title: email,
                  isClickable: true,
                ),
                InkwellWithIconClickable(
                  iconData: Icons.phone,
                  title: phone,
                  isClickable: true,
                )
              ],
            ),
          )
        ],
      )),*/
            ProfileHeaderCard(
          email: email,
          phone: phone,
          name: name,
          photoURL: photoURL,
          isCurrentUser: false,
          userId: userid,
        ));
  }
}
