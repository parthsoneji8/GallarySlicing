import 'package:flutter/material.dart';

class Status_Screen extends StatefulWidget {
  const Status_Screen({Key? key}) : super(key: key);

  @override
  State<Status_Screen> createState() => _Status_ScreenState();
}

class _Status_ScreenState extends State<Status_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Icon(Icons.star, size: 50, color: Colors.red),
      ),
    );
  }
}
