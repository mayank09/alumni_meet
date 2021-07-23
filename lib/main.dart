import 'package:alumnimeet/ui/loginPage.dart';
import 'package:alumnimeet/ui/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'hi']);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(builder: (locale) {
      return MaterialApp(
          title: "Alumni Meet",
          debugShowCheckedModeBanner: false,
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          home: SplashPage());
    });
  }
}
