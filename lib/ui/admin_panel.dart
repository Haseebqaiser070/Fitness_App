import 'package:flutter/material.dart';
import 'add_plan.dart';

class AdminPanel extends StatefulWidget {
  static const String routeName = '/adminpanel';
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPlan(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Add Plans'.toUpperCase()),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.grey,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('View Subscriptions'.toUpperCase()),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.grey,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
