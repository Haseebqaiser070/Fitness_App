import 'package:flutter/material.dart';
import 'package:fitness_app/ui/register.dart';
import 'package:fitness_app/widgets/input_field.dart';

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                child: Image.asset(
                  'images/login_logo.png',
                  width: 600.0,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const InputField(),
            ),
            // const SizedBox(
            //   height: 40,
            // ),
            // const LoginButtons(),
            // const SizedBox(
            //   height: 20,
            // ),
            //RegisterButton(),
            Row(
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
