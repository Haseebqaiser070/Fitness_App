import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/ui/login_page.dart';
import 'package:fitness_app/ui/plans.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Image.asset('images/loo.jpg'),
                ),
                const SizedBox(
                  height: 6.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(50),
                  child: Register_fields(),
                ),
                //SignUpButton(),

                //SignUpText(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Register_fields extends StatefulWidget {
  const Register_fields({Key? key}) : super(key: key);

  @override
  _Register_fieldsState createState() => _Register_fieldsState();
}

class _Register_fieldsState extends State<Register_fields> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool? _success;

  var _userEmail;

  bool? isLoading = false;

  // final _formKey = GlobalKey<FormState>();
  // String _email, _password, _Name, _repassword;
  // final auth = FirebaseAuth.instance;
  // final firestore = FirebaseFirestore.instance;

  // _signUp() async {
  //   try {
  //     if (_formKey.currentState.validate()) {
  //       await auth.createUserWithEmailAndPassword(
  //         email: _email,
  //         password: _password,
  //       );
  //       Fluttertoast.showToast(
  //         msg: 'Registration successful',
  //         gravity: ToastGravity.TOP,
  //         timeInSecForIosWeb: 1,
  //       );

  //       firestore
  //           .collection('users')
  //           .doc(FirebaseAuth.instance.currentUser.uid)
  //           .set({
  //         'name': _Name,
  //         'email': _email,
  //         'password': _password,
  //         'payout': "00",
  //         'repassword': _repassword,
  //         'dateTime': DateTime.now(),
  //       }).whenComplete(
  //         () {
  //           Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(
  //               builder: (context) => LoginPage(),
  //             ),
  //           );
  //         },
  //       );
  //     }
  //   } on PlatformException catch (err) {
  //     print(err.message);
  //     Fluttertoast.showToast(msg: err.message, gravity: ToastGravity.TOP);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              validator: (text) {
                if (text!.length < 4) {
                  return 'Please Enter Valid Name';
                } else if (text.length > 16) {
                  return 'Name is too Long';
                }
                return null;
              },
              // onChanged: (value) {
              //   setState(() {
              //     _Name = value.toString();
              //   });
              // },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.grey),
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              validator: (text) {
                if (!text!.contains('@')) {
                  return 'Please Enter Valid Email';
                }
                return null;
              },
              //         onChanged: (value) {
              //           setState(() {
              //             _email = value.toString().trim();
              //           });
              //         },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: TextFormField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.grey),
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              validator: (text) {
                if (text!.length < 6) {
                  return 'Password must be greater than 6 character';
                }
                return null;
              },

              //         onChanged: (value) {
              //           setState(() {
              //             _password = value.toString().trim();
              //           });
              //         },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 25, 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: TextFormField(
              controller: _confirmPasswordController,
              style: const TextStyle(color: Colors.grey),
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Re Enter Password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              validator: (text) {
                if (text!.length < 6) {
                  return 'Password must be greater than 6 character';
                }
                return null;
              },
              //         onChanged: (value) {
              //           setState(() {
              //             _password = value.toString().trim();
              //           });
              //         },
            ),
          ),
          const SizedBox(height: 50),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 70),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  if (isLoading!) {
                    signUp();
                  }
                }
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Plans(),),
                // );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Center(
                child: isLoading!
                    ? const SizedBox(
                        width: 16, child: CircularProgressIndicator())
                    : const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Example code for registration.
  Future<void> signUp() async {
    User? user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
    } catch (e) {}

    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'isAdmin': false,
        'dateTime': DateTime.now().toString(),
      }).then((value) => debugPrint('Added'));
      setState(() {
        isLoading = false;
        _success = true;
        _userEmail = user!.email!;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Plans()));
    } else {
      setState(() {
        isLoading = false;
      });
      _success = false;
    }
  }
}
