import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallaryslicing/HomeScreen/Videos3_Screeen.dart';
import 'package:gallaryslicing/Model/Gallary_Model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Videos2_Screeen extends StatefulWidget {
  const Videos2_Screeen({Key? key, required this.videos, required this.thumbnails, required this.name}) : super(key: key);
  final VideoFIles videos;
  final List<String> thumbnails;
  final String name;

  @override
  State<Videos2_Screeen> createState() => _Videos2_ScreeenState();
}

class _Videos2_ScreeenState extends State<Videos2_Screeen> {

  Map<String, String?> videoThumbnails = {};

  Future<void> loadThumbnails() async {
    for (var video in widget.videos.files!) {
      if (!videoThumbnails.containsKey(video.path!)) {
        final thumbnail =
        await VideoThumbnail.thumbnailFile(video: video.path!);
        setState(() {
          videoThumbnails[video.path!] = thumbnail;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadThumbnails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.name,style: const TextStyle(fontSize: 20, color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.search_outlined,
                    size: 30, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.settings, size: 30, color: Colors.white),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:  GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: widget.videos.files!.length,
                itemBuilder: (context, index) {
                  final video = widget.videos;
                  final videoPath = video.files![index].path!;
                  final thumbnail = videoThumbnails[videoPath];

                  if (thumbnail != null) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Video3_Screen(
                              videos: video.files!
                                  .map((file) => file.path!)
                                  .toList(),
                              thumbnails: widget.thumbnails,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(thumbnail),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                                child: Image(image: AssetImage("images/Third_Screen/video_icon.png"),width: 20,height: 20,)),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      )
    );
  }
}
