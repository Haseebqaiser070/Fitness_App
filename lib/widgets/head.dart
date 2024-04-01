import 'package:flutter/material.dart';

class Head extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            //flex: 1,
            child: Container(
              color: Colors.blue,
              //width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset(
                'images/login_img.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
