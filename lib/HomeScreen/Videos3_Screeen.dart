import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video3_Screen extends StatefulWidget {
  const Video3_Screen(
      {Key? key,
      required this.videos,
      required this.initialIndex,
      required this.thumbnails})
      : super(key: key);
  final List<String> videos;
  final int initialIndex;
  final List<String> thumbnails;

  @override
  State<Video3_Screen> createState() => _Video3_ScreenState();
}

class _Video3_ScreenState extends State<Video3_Screen> {
  late PageController pageController;
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
    videoPlayerController =
        VideoPlayerController.file(File(widget.videos[widget.initialIndex]));
    _initializeVideoPlayerFuture = videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: const [
                Image(
                  image: AssetImage("images/Third_Screen/share_unpress.png"),
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 10),
                Image(
                    image: AssetImage("images/Third_Screen/delete_unpress.png"),
                    width: 30,
                    height: 30)
              ],
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PageView.builder(
          controller: pageController,
          itemCount: widget.videos.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                      child: videoPlayerController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(
                                videoPlayerController,
                              ),
                            )
                          : Container());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
          onPageChanged: (index) {
            setState(() {
              videoPlayerController.pause();
              videoPlayerController =
                  VideoPlayerController.file(File(widget.videos[index]));
              _initializeVideoPlayerFuture = videoPlayerController.initialize();
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (videoPlayerController.value.isPlaying) {
              videoPlayerController.pause();
            } else {
              videoPlayerController.play();
            }
          });
        },
        child: Icon(
          videoPlayerController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}
