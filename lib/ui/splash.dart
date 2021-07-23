
import 'package:alumnimeet/firebase/fire_auth.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_){
      initializeFirebase(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: AppLabel())),
    );
  }
}
