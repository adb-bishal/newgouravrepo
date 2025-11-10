import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/view/screens/base_view/video_base_view.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import 'package:video_player/video_player.dart';

import 'model/services/player/file_video_widget.dart';
import 'model/utils/app_constants.dart';

class Video {
  final int? id;
  final String title;
  final String path;
  final String thumbnailPath;

  Video({
    this.id,
    required this.title,
    required this.path,
    required this.thumbnailPath,
  });

  // Convert a Video object into a map for SQFLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'thumbnailPath': thumbnailPath,
    };
  }

  // Convert a map into a Video object
  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      title: map['title'],
      path: map['path'],
      thumbnailPath: map['thumbnailPath'],
    );
  }
}

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'videos.db';
  static const String _tableName = 'videos';

  // Singleton pattern to get the database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database with versioning and migration
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: 2, // Increment the version number to trigger migration
      onCreate: _createDb,
      onUpgrade: _onUpgrade, // Add migration logic here
    );
  }

  // Create the database schema with title, path, and thumbnailPath columns
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,        -- Title of the video
        path TEXT NOT NULL,         -- Path for the video
        thumbnailPath TEXT NOT NULL -- Path for the thumbnail
      )
    ''');
    
  }

  // Handle database migration (if needed)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // In case we need to add/remove columns in future versions
    }
  }

  // Insert a video record into the database
  Future<int> insertVideo(Video video) async {
    final db = await database;
    return await db.insert(_tableName, video.toMap());
  }


  // Get all videos from the database
  Future<List<Video>> getVideos() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Video.fromMap(maps[i]);
    });
  }

  // Delete a video by ID
  Future<int> deleteVideo(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllVideos() async {
    final db = await database;  // Get reference to your database
    await db.delete('videos');  // Delete all records from the 'videos' table
  }

  // Close the database connection
  Future<void> closeDb() async {
    final db = await database;
    await db.close();
  }
}


class VideoPlayerScreen extends StatefulWidget {
  final Video videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  bool _isControlsVisible = true;
  late bool _isLandscapeMode;
  late Timer _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _isLandscapeMode = true;

    // Set the device orientation to landscape by default
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = VideoPlayerController.file(File(widget.videoPath.path))
      ..addListener(() {
        setState(() {
          _currentPosition = _controller.value.position;
        });
      })
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      }).catchError((error) {
        print('Error initializing video: $error');
      });

    // Automatically hide controls after 5 seconds of inactivity
    _hideControlsTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_isControlsVisible && _controller.value.isPlaying) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer.cancel();
    // Reset the orientation to portrait when exiting the screen
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _seekForward() {
    final newPosition = _controller.value.position + Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _seekBackward() {
    final newPosition = _controller.value.position - Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _toggleControlsVisibility() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });

    // Reset the timer to hide controls again after 5 seconds of inactivity
    if (_isControlsVisible) {
      _hideControlsTimer.cancel();
      _hideControlsTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        if (_isControlsVisible && _controller.value.isPlaying) {
          setState(() {
            _isControlsVisible = false;
          });
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControlsVisibility,
        child: _controller.value.isInitialized
            ? Stack(
          children: [
            // Video player
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),

            // Controls
            if (_isControlsVisible) ...[
              // Seek bar
              Positioned(
                bottom: 60,
                left: 20,
                right: 20,
                child: Slider(
                  value: _currentPosition.inSeconds.toDouble(),
                  max: _controller.value.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _controller.seekTo(Duration(seconds: value.toInt()));
                  },
                  activeColor: ColorResource.primaryColor,
                  inactiveColor: ColorResource.primaryColor.withOpacity(0.3),
                ),
              ),

              // Duration display
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      _formatDuration(_controller.value.duration),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Play/Pause and Skip Buttons
              Positioned(
                bottom: 10,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.replay_10,
                        color: ColorResource.primaryColor,
                        size: 36,
                      ),
                      onPressed: _seekBackward,
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: ColorResource.primaryColor,
                        size: 48,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.forward_10,
                        color: ColorResource.primaryColor,
                        size: 36,
                      ),
                      onPressed: _seekForward,
                    ),
                  ],
                ),
              ),
            ],

              Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              splashColor: Colors.transparent,
              child: const SizedBox(
                  height: 45,
                  width: 50,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: ColorResource.white,
                        size: 20,
                      ))),
            ),
          ),

          // Title overlay
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Text(
              widget.videoPath.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}


// class VideoPlayerScreen extends StatefulWidget {
//   final Video video;
//
//   VideoPlayerScreen({required this.video});
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Set the orientation to landscape by default
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//     ]);
//
//     // Hide the status bar and navigation bar
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//
//     // Initialize the video player controller
//     _controller = VideoPlayerController.file(File(widget.video.path))
//       ..initialize().then((_) {
//         setState(() {
//           _controller.play();
//         }); // Update the UI when the video is ready
//       });
//
//     // Start playback automatically after initialization
//     // _controller.addListener(() {
//     //   if (_controller.value.isInitialized && !_controller.value.isPlaying) {
//     //     _controller.play();
//     //   }
//     // });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     // Reset the orientation when exiting
//
//     // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//
//     // Show the status bar and navigation bar again when exiting the screen
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: _controller.value.isInitialized
//           ? Stack(
//         children: [
//           // Video player
//
//           // Center(
//           //   child: AspectRatio(
//           //     aspectRatio: _controller.value.aspectRatio,
//           //     child: VideoPlayer(_controller),
//           //   ),
//           // ),
//           Center(
//             child: FileVideoWidget(
//               isOrientation: false,
//               autoPlay: true,
//               url: widget.video.path ?? "",
//               eventCallBack: (progress, totalDuration) async {},
//             ),
//           ),
//
//           Positioned(
//             top: 30,
//             left: 10,
//             right: 10,
//             child: InkWell(
//               onTap: () {
//                 Get.back();
//               },
//               splashColor: Colors.transparent,
//               child: const SizedBox(
//                   height: 45,
//                   width: 50,
//                   child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Icon(
//                         Icons.arrow_back_ios_sharp,
//                         color: ColorResource.white,
//                         size: 20,
//                       ))),
//             ),
//           ),
//
//           // Title overlay
//           Positioned(
//             top: 30,
//             left: 20,
//             right: 20,
//             child: Text(
//               widget.video.title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//
//           // Controls overlay
//         ],
//       )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
//
//
// }



class VideoListPage extends StatelessWidget {
  final LiveClassDetailController videoController =
  Get.put(LiveClassDetailController());

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // print('dfvdfv${videoController.downloadedVideos.first.title}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offline Videos',
          style: TextStyle(fontSize: 20, color: ColorResource.white),
        ),
        centerTitle: true,
        backgroundColor: ColorResource.primaryColor,
      ),
      body: Obx(() {
        if (videoController.downloadedVideos.isEmpty) {
          return Center(
            child: Text(
              'No videos found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: videoController.downloadedVideos.length,
          itemBuilder: (context, index) {
            final video = videoController.downloadedVideos[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Get.to(VideoPlayerScreen(videoPath: video));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail


                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.file(
                            File(video.thumbnailPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Video Title and Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Tap to play video",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          videoController.deleteVideo(video.id);
                          // dbHelper.deleteVideo(video.id!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// Main App Widget