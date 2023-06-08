// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallaryslicing/Screen/BottomTabBar.dart';
import 'package:gallaryslicing/Screen/First_Screen.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/Splash_Screen/background.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              const SizedBox(height: 70),
              const Image(
                image: AssetImage("images/Splash_Screen/icon.png"),
                height: 40,
                width: 40,
              ),
              const SizedBox(height: 25),
              Text(
                "You can freely create album, and  ",
                style: TextStyle(
                    fontSize: 20, color: Colors.white.withOpacity(0.5)),
              ),
              Text(
                "add photos and videos",
                style: TextStyle(
                    fontSize: 20, color: Colors.white.withOpacity(0.5)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 8),
              const Image(
                  image: AssetImage("images/Splash_Screen/gallary.gif")),
            ],
          ),
        ),
      ),
    );
  }
}
