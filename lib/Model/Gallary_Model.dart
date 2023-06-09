class AlbumModel {
  final List<String> files; // Update the parameter name to 'files'
  final String folderName;

  AlbumModel({required this.files, required this.folderName});

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      files: json['files'].cast<String>(),
      folderName: json['folderName'],
    );
  }
}

class VideoFIles {
  List<Files>? files;
  String? folderName;

  VideoFIles({this.files, this.folderName});

  VideoFIles.fromJson(Map<String, dynamic> json) {
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    folderName = json['folderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    data['folderName'] = this.folderName;
    return data;
  }
}

class Files {
  String? path;
  String? dateAdded;
  String? displayName;
  String? duration;
  String? size;

  Files(
      {this.path, this.dateAdded, this.displayName, this.duration, this.size});

  Files.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    dateAdded = json['dateAdded'];
    displayName = json['displayName'];
    duration = json['duration'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['dateAdded'] = this.dateAdded;
    data['displayName'] = this.displayName;
    data['duration'] = this.duration;
    data['size'] = this.size;
    return data;
  }
}
class Video {
  VideoFIles videoFiles;
  String thumbnails;

  Video({required this.videoFiles, required this.thumbnails});
}
