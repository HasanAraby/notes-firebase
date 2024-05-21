import 'package:fire_base/auth/signup.dart';
import 'package:fire_base/categories/addCategory.dart';
import 'package:fire_base/home.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fire_base/auth/logIn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
      // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('============User is currently signed out!');
      } else {
        print('===========User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Home()
          : LogIn(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
              color: Colors.orange, fontSize: 17, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(
            color: Colors.orange,
          ),
        ),
      ),
      routes: {
        'home': (context) => Home(),
        'logIn': (context) => LogIn(),
        'signUp': (context) => SignUp(),
        'addCategory': (context) => AddCategory(),
      },
    );
  }
}
