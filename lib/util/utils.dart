import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

/*  Future<bool> displayToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }*/

SnackBar displaySnackBar(String message,
    {String? actionMessage, VoidCallback? onClick}) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 14.0),
    ),
    action: (actionMessage != null)
        ? SnackBarAction(
            textColor: Colors.white,
            label: actionMessage,
            onPressed: () {
              //return onClick();
            },
          )
        : null,
    duration: Duration(seconds: 2),
    //backgroundColor: primaryColor,
  );
}

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(displaySnackBar(message));
}

void customLaunch(command) async {
  if (await canLaunch(command)) {
    await launch(command);
  } else {
    print(' could not launch $command');
  }
}

DateTime? stringToDateTime(String s){
    //DateFormat f = DateFormat("yyyy-MM-dd");
    return DateTime.tryParse(s);
}
