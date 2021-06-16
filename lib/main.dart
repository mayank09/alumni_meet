import 'package:alumnimeet/ui/loginPage.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Alumni Meet",
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: LoginPage()));
  }
}

