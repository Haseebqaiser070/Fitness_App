import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/ui/plans.dart';
import 'package:fitness_app/widgets/loginbuttons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InputField extends StatefulWidget {
  const InputField({Key? key}) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String login_email = 'LoginEmail';
  String login_password = 'LoginPassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
              const SizedBox(height: 40),
              LoginButtons(
                onClick: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Plans(),
                  //   ),
                  // );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Plans(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
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
