// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class LogoutOverlay extends StatefulWidget {
  LogoutOverlay({
    Key? key,
    this.message,
  }) : super(key: key);
  String? message;

  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<LogoutOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(15.0),
            height: 240.0,
            decoration: ShapeDecoration(
              color: const Color.fromRGBO(0, 50, 78, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Text(
                      widget.message!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 10.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      child: ButtonTheme(
                        height: 35.0,
                        minWidth: 110.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text("OK"),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
