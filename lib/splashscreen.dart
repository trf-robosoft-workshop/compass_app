import 'dart:async';
import 'package:compass_app/home_page.dart';
import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    startsplash();
  }

  startsplash() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (c) => HomePage()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/splash.jpeg",
              height: 300,
              width: 300,
            ),
            const SizedBox(
              height: 32,
            ),
            Image.asset(
              "assets/images/trf.png",
              height: 128,
              width: 128,
            ),
            Image.asset(
              "assets/images/robodroid.jpeg",
              height: 128,
              width: 256,
            ),
          ],
        ),
      ),
    );
  }
}
