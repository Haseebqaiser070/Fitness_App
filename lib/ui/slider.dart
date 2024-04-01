import 'package:fitness_app/ui/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import '../shared/const.dart';

class Sliderr extends StatefulWidget {
  static const String routeName = '/slider';

  const Sliderr({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SliderState();
  }
}

class SliderState extends State<Sliderr> {
  List<Slide> slides = [];

  double? top = 200;

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        widgetTitle: Row(
          children: const [
            Text(
              'Train like\n3x Pro Fitness\nModel World\nChampion\nWilliams\nFalade',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 43,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // title:
        //     'Train like\n3x Pro Fitness\nModel World\nChampion\nWilliams\nFalade',
        // styleTitle: TextStyle(),
        backgroundImage: "images/slider1-image.jpg",
      ),
    );
    slides.add(
      Slide(
        widgetTitle: Column(
          children: [
            Row(
              children: const [
                Text(
                  kt1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 43,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Text(
                  kt2,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        // title: kt1,
        backgroundImage: "images/plan_1.png",
        centerWidget: Padding(
          padding: EdgeInsets.fromLTRB(
            30.0,
            top!, // MediaQuery.of(context).size.height * 0.6 * (1 / 2),
            30.0,
            20.0,
          ),
          child: SizedBox(
            width: 190.0,
            height: 45.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void onDonePress() {
  //   // Do what you want
  //   print("End of slides");
  // }

  @override
  Widget build(BuildContext context) {
    top = MediaQuery.of(context).size.height * 0.9 * (1 / 2);
    return IntroSlider(
      slides: slides,
      // onDonePress: onDonePress,
      hideStatusBar: true,
      showDoneBtn: false,
      showSkipBtn: false,
      showNextBtn: false,
      showPrevBtn: false,
    );
  }
}
