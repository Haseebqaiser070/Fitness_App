import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/ui/plans.dart';
import 'package:fitness_app/ui/slider.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static var routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    goNext(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Image.asset(
            'assets/splash.png',
            fit: BoxFit.cover,
          ),
          // FlutterLogo(
          //   size: MediaQuery.of(context).size.height,
          // ),
        ),
      ),
    );
  }

  void goNext(BuildContext contextt) {
    Timer(const Duration(seconds: 7), () {
      FirebaseAuth.instance.currentUser == null
          ? Navigator.pushReplacement(
              contextt,
              MaterialPageRoute(
                builder: (context) => const Sliderr(),
              ),
            )
          : Navigator.pushReplacement(
              contextt,
              MaterialPageRoute(
                builder: (context) => const Plans(),
              ),
            );
    });
  }
}
