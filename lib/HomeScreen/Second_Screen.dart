import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallaryslicing/HomeScreen/Third_Screen.dart';

class Second_Screen extends StatefulWidget {
  const Second_Screen({Key? key, required this.images, required this.name}) : super(key: key);
  final List<String> images;
  final String name;

  @override
  State<Second_Screen> createState() => _Second_ScreenState();
}

class _Second_ScreenState extends State<Second_Screen> {
  String? selectedimage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/Splash_Screen/background.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      widget.name,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Expanded(child: SizedBox()),
                    const Icon(Icons.search_outlined,
                        size: 30, color: Colors.white),
                    const SizedBox(width: 12),
                    const Icon(Icons.settings, size: 30, color: Colors.white),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
                        final album = widget.images[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedimage = album;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Third_Screen(image: selectedimage),
                              ),
                            );
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(album),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [Colors.black54, Colors.transparent],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
