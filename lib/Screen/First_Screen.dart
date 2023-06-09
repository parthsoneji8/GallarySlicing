//@dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:gallaryslicing/HomeScreen/Second_Screen.dart';
import 'package:gallaryslicing/HomeScreen/Videos2_Screen.dart';
import 'package:gallaryslicing/Model/Gallary_Model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool savephoto = false;
  List<AlbumModel> albums;
  List<VideoFIles> videos;
  List<AlbumModel> originalAlbums;
  List<String> preloadedThumbnails = [];
  int index = 0;
  ValueNotifier<bool> isPhotopressNotifier = ValueNotifier<bool>(true);
  bool albumStatus = true;

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      getAlbums();
      videoPath();
    } else {
      return null;
    }
  }

  Future<void> getAlbums() async {
    String response = await StoragePath.imagesPath;
    List<dynamic> albumsJson = jsonDecode(response);

    List<AlbumModel> validAlbums = [];

    for (var albumJson in albumsJson) {
      AlbumModel album = AlbumModel.fromJson(albumJson);

      bool hasMissingImage = false;

      for (var imagePath in album.files) {
        if (!(await File(imagePath).exists())) {
          hasMissingImage = true;
          break;
        }
      }

      if (!hasMissingImage) {
        validAlbums.add(album);
      }
    }

    setState(() {
      albums = validAlbums;
      originalAlbums = List.from(validAlbums);
    });
  }
  Future<void> videoPath() async {
    String videoPath = '';
    try {
      videoPath = await StoragePath.videoPath;
      final videoJson = jsonDecode(videoPath) as List<dynamic>;
      List<VideoFIles> validVideos = [];

      for (var video in videoJson) {
        VideoFIles videoFile = VideoFIles.fromJson(video);
        String filePath = videoFile.files[index].path;

        if (filePath.endsWith('.mp4') && await File(filePath).exists()) {
          String thumbnailPath = await getImage(filePath);
          if (thumbnailPath != null) {
            validVideos.add(videoFile);
          }
        }
      }

      setState(() {
        videos = validVideos;
      });
    } on PlatformException {
      videoPath = "Failed to load path";
    }
  }

  Future<String> getImage(thumbnail) async {
    try {
      final thumb = await VideoThumbnail.thumbnailFile(video: thumbnail);
      return thumb;
    } catch (e) {
      print('Error generating thumbnail for video: $thumbnail');
      return null;
    }
  }


  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/Splash_Screen/background.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        SizedBox(width: 10),
                        Text(
                          "Gallary",
                          style: TextStyle(fontSize: 23, color: Colors.white),
                        ),
                        Expanded(child: SizedBox()),
                        Icon(Icons.search_outlined,
                            size: 28, color: Colors.white),
                        SizedBox(width: 12),
                        Icon(Icons.settings, size: 28, color: Colors.white),
                        SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: albumStatus,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                isPhotopressNotifier.value = true;
                              },
                              child: ValueListenableBuilder<bool>(
                                valueListenable: isPhotopressNotifier,
                                builder: (context, value, child) {
                                  return value
                                      ? Image.asset(
                                    "images/gallary_First/photos_press.png",
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        6,
                                  )
                                      : Image.asset(
                                    "images/gallary_First/photos_unpress.png",
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        6,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                isPhotopressNotifier.value = false;
                              },
                              child: ValueListenableBuilder<bool>(
                                valueListenable: isPhotopressNotifier,
                                builder: (context, value, child) {
                                  return !value
                                      ? Image.asset(
                                    "images/gallary_First/videos_press.png",
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        6,
                                  )
                                      : Image.asset(
                                    "images/gallary_First/videos_unpress.png",
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        6,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            savephoto
                                ? Image(
                              image: const AssetImage(
                                  "images/gallary_First/save_press.png"),
                              width:
                              MediaQuery.of(context).size.width / 6.5,
                            )
                                : Image(
                              image: const AssetImage(
                                  "images/gallary_First/save_unpress.png"),
                              width:
                              MediaQuery.of(context).size.width / 6.5,
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: albumStatus,
                      child: Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: isPhotopressNotifier,
                          builder: (context, value, child) {
                            if (value) {
                              return buildAlbumsGridView();
                            } else {
                              return buildVideosGridView();
                            }
                          },
                        ),
                      ),
                    ),
                    Visibility(
                        visible: !albumStatus,
                        child: Container(
                          height: 500,
                          color: Colors.red,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: Text("Hello")),
                        ))
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                        AssetImage("images/gallary_First/bottom_box.png"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 10, left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                albumStatus = true;
                              });
                            },
                            child: albumStatus
                                ? Image.asset(
                              "images/gallary_First/albums_press.png",
                              width:
                              MediaQuery.of(context).size.width / 6,
                            )
                                : Image.asset(
                              "images/gallary_First/albums_unpress.png",
                              width:
                              MediaQuery.of(context).size.width / 6,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                albumStatus = false;
                              });
                            },
                            child: !albumStatus
                                ? Image.asset(
                              "images/gallary_First/status_press.png",
                              width:
                              MediaQuery.of(context).size.width / 6,
                            )
                                : Image.asset(
                              "images/gallary_First/status_unpress.png",
                              width:
                              MediaQuery.of(context).size.width / 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  Widget buildAlbumsGridView() {
    if (originalAlbums == null || originalAlbums.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 6,
          mainAxisExtent: MediaQuery.of(context).size.height / 3,
          mainAxisSpacing: 8,
          crossAxisCount: 2,
        ),
        shrinkWrap: true,
        itemCount: originalAlbums.length,
        itemBuilder: (BuildContext context, int index) {
          final album = originalAlbums[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Second_Screen(
                      images: album.files,
                      name: album.folderName,
                    )
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 120,
                right: MediaQuery.of(context).size.width / 120,
                top: MediaQuery.of(context).size.height / 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.file(
                        File(album.files[0]),
                        // Use the correct index to access files
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      album.folderName,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildVideosGridView() {
    if (videos == null || videos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4,
          mainAxisExtent: MediaQuery.of(context).size.height / 3.2,
          mainAxisSpacing: 8,
          crossAxisCount: 2,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          if (video.files != null && video.files.isNotEmpty) {
            int thumbnailIndex = -1;
            for (int i = 0; i < video.files.length; i++) {
              if (video.files[i].path != null && video.files[i].path.endsWith('.mp4')) {
                thumbnailIndex = i;
                break;
              }
            }
            if (thumbnailIndex != -1) {
              final videoPath = video.files[thumbnailIndex].path;
              return FutureBuilder<String>(
                future: getImage(videoPath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      preloadedThumbnails.add(snapshot.data);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Videos2_Screeen(
                                videos: video,
                                thumbnails: preloadedThumbnails,
                                name: video.folderName,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: videoPath,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 120,
                              right: MediaQuery.of(context).size.width / 120,
                              top: MediaQuery.of(context).size.height / 100,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 4.2,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.file(
                                          File(snapshot.data),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.black54,
                                            Colors.transparent
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    video.folderName,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
