import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/ui/plans.dart';
import 'package:fitness_app/ui/register.dart';
import 'package:fitness_app/widgets/loginbuttons.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/ui/input.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  // static const String routeName = '/LoginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String login_email = 'LoginEmail';
  String login_password = 'LoginPassword';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                child: ClipRRect(
                  child: Image.asset(
                    'images/login_img.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 34, 38, 45),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                          child: Image.asset(
                            'images/login_logo.png',
                            width: 600.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    style: const TextStyle(color: Colors.grey),
                                    onChanged: (value) {
                                      login_email = value;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _passwordController,
                                    style: const TextStyle(color: Colors.grey),
                                    onChanged: (value) {
                                      login_email = value;
                                    },
                                    obscureText: true,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                LoginButtons(
                                  onClick: () {
                                    _signInWithEmailAndPassword();
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const Plans(),
                                    //   ),
                                    // );
                                  },
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      // const LoginButtons(),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      //RegisterButton(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Dont\'t have an account? ',
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Register(),
                                  ),
                                );
                              },
                              child: const Text(
                                'SignUp',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user!.email} signed in'),
        ),
      );
      Fluttertoast.showToast(
        msg: 'Login Successful',
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        prefs.setBool('isAdmin', value.get('isAdmin'));
        print(value);
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Plans(),
        ),
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Failed to sign in with Email & Password'),
      //   ),
      // );
    }
  }

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
    }
  }
}
