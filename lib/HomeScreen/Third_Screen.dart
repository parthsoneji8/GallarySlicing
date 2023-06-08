import 'dart:io';

import 'package:flutter/material.dart';

class Third_Screen extends StatefulWidget {
  const Third_Screen({Key? key, this.image}) : super(key: key);
  final String? image;

  @override
  State<Third_Screen> createState() => _Third_ScreenState();
}

class _Third_ScreenState extends State<Third_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/Splash_Screen/background.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12,top: 10,left: 12),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back,size: 30,color: Colors.white),
                    Expanded(child: SizedBox()),
                    Image(image: AssetImage("images/Third_Screen/share_unpress.png"),width: 30,height: 30,),
                    SizedBox(width: 10),
                    Image(image: AssetImage("images/Third_Screen/delete_unpress.png"),width: 30,height: 30)
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(File(widget.image!),fit: BoxFit.contain,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
