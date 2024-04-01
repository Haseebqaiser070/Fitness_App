import 'package:fitness_app/ui/login_page.dart';
import 'package:fitness_app/ui/register.dart';
import 'package:flutter/material.dart';
import '../ui/plans.dart';

class LoginButtons extends StatelessWidget {
  final Function? onClick;

  const LoginButtons({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: onClick!(),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 45),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Register()),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Center(
          child: Text(
            'Don\'t have an account, Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 82),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: const Center(
          child: Text(
            'Already have an account, Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color.fromRGBO(29, 194, 95, 1),
          minimumSize: const Size.fromHeight(50),
        ),
        child: buildContent(),
        onPressed: onClicked,
      );

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ],
      );
}
