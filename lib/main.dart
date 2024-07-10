import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mad_project/pallets.dart';
import 'package:mad_project/splashScreen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCNOzaa6hzkH24n4jkhr4oio3CgnT9wYTE",
          appId: "1:803976692292:web:47f4c0eec93689516c3211",
          messagingSenderId: "803976692292",
          projectId: "islamicapp-faf74",
          storageBucket: "islamicapp-faf74.appspot.com"));
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Islamic World',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: Pallete.backgroundColor),
      home: const SplashScreen(),
    );
  }
}
