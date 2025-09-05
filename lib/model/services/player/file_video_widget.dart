// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:better_player/better_player.dart' as better;
// import 'package:better_player/src/video_player/video_player_platform_interface.dart' as video_event;
// import 'package:screen_protector/screen_protector.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
//
// import '../../../service/page_manager.dart';
// import '../../network_calls/dio_client/get_it_instance.dart';
// import '../../utils/color_resource.dart';
// import 'package:stockpathshala_beta/model/services/player/widgets/custom_controls_widget.dart';
// import 'package:stockpathshala_beta/service/video_hls_player/video_view.dart';
//
// class FileVideoWidget extends StatefulWidget {
//   final String url;
//   final String? thumbnail;
//   final void Function(bool)? onPlayButton;
//   final Function(int, int) eventCallBack;
//   final bool isScalp;
//   final bool isOrientation;
//   final bool orientation;
//   final bool isVideo;
//   final bool autoPlay;
//   final bool showQualityPicker;
//
//   const FileVideoWidget({
//     super.key,
//     required this.url,
//     this.thumbnail,
//     this.onPlayButton,
//     required this.eventCallBack,
//     this.isScalp = false,
//     this.isOrientation = true,
//     this.orientation = true,
//     this.isVideo = true,
//     this.autoPlay = true,
//     this.showQualityPicker = true,
//   });
//
//   @override
//   State<FileVideoWidget> createState() => _FileVideoWidgetState();
// }
//
// class _FileVideoWidgetState extends State<FileVideoWidget> {
//   bool isBetterPlayer = false;
//   better.BetterPlayerDataSource? _dataSource;
//   better.BetterPlayerController? _betterPlayerController;
//   final pageManager = getIt<PageManager>();
//   bool isRecording = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Maintain orientation if specified
//     if (!widget.orientation) {
//       SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     }
//
//     // Detect screen recording, but do not block playback
//     checkScreenRecording();
//
//     // Use BetterPlayer for non-m3u8 URLs
//     isBetterPlayer = !widget.url.contains('.m3u8');
//     if (isBetterPlayer) {
//       _dataSource = widget.isVideo
//           ? better.BetterPlayerDataSource.network(widget.url)
//           : better.BetterPlayerDataSource.file(widget.url);
//
//       Future.delayed(const Duration(milliseconds: 200), () {
//         _betterPlayerController = better.BetterPlayerController(
//           better.BetterPlayerConfiguration(
//             autoPlay: widget.autoPlay,
//             looping: true,
//             autoDispose: true,
//             allowedScreenSleep: false,
//             handleLifecycle: true,
//             aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
//             fit: BoxFit.contain,
//             deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//             deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeRight],
//             controlsConfiguration: better.BetterPlayerControlsConfiguration(
//               playerTheme: better.BetterPlayerTheme.custom,
//               customControlsBuilder: (controller, visibilityFn) =>
//                   CustomControlsWidget(
//                     isScalp: widget.isScalp,
//                     isOrientation: widget.isOrientation,
//                     orientation: widget.orientation,
//                     controller: controller,
//                     onControlsVisibilityChanged: visibilityFn,
//                   ),
//             ),
//           ),
//         );
//
//         _betterPlayerController!
//           ..setupDataSource(_dataSource!)
//           ..addEventsListener(_handleEvent);
//         setState(() {}); // Refresh to show player
//       });
//     }
//   }
//
//   Future<void> checkScreenRecording() async {
//     final rec = await ScreenProtector.isRecording();
//     if (rec != isRecording) {
//       setState(() => isRecording = rec);
//       if (rec) {
//         showDialog(
//           context: context,
//           useRootNavigator: false,
//           builder: (_) => AlertDialog(
//             title: const Text('Screen Recording Detected'),
//             content: const Text('Please stop screen recording to continue.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//     Future.delayed(const Duration(seconds: 2), checkScreenRecording);
//   }
//
//   Future<void> _handleEvent(better.BetterPlayerEvent event) async {
//     if (event.betterPlayerEventType == better.BetterPlayerEventType.progress) {
//       widget.eventCallBack(
//         event.parameters?['progress']?.inSeconds ?? 0,
//         event.parameters?['duration']?.inSeconds ?? 0,
//       );
//     }
//     if (event.betterPlayerEventType == better.BetterPlayerEventType.play) {
//       WakelockPlus.enable();
//     } else if (event.betterPlayerEventType == better.BetterPlayerEventType.pause) {
//       WakelockPlus.disable();
//     }
//     if (pageManager.playButtonNotifier.value == ButtonState.playing) {
//       await _betterPlayerController?.pause();
//     }
//   }
//
//   @override
//   void dispose() {
//     WakelockPlus.disable();
//     _betterPlayerController?.dispose();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: VisibilityDetector(
//         key: Key(widget.url),
//         onVisibilityChanged: (info) async {
//           final vis = info.visibleFraction * 100;
//           if (widget.autoPlay) {
//             if (vis > 80) {
//               await _betterPlayerController?.play();
//               WakelockPlus.enable();
//             } else {
//               await _betterPlayerController?.pause();
//               WakelockPlus.disable();
//             }
//           }
//         },
//         child: isBetterPlayer
//             ? (_betterPlayerController == null
//             ? const Center(child: CircularProgressIndicator())
//             : better.BetterPlayer(controller: _betterPlayerController!))
//             : HlsVideoPlayer(
//           thumbnail: widget.thumbnail,
//           m3u8Show: widget.showQualityPicker,
//           showControllers: !widget.isScalp,
//           aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
//           videoUrl: widget.url,
//           onVideoPosition: widget.eventCallBack,
//           onVideoInitCompleted: (controller) async {
//             await controller.setLooping(true);
//             if (widget.autoPlay) {
//               WakelockPlus.enable();
//             } else {
//               await controller.pause();
//               WakelockPlus.disable();
//             }
//           },
//           onPlayButtonTap: (val) {
//             widget.onPlayButton?.call(val);
//             val ? WakelockPlus.enable() : WakelockPlus.disable();
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:better_player/better_player.dart' as better;
import 'package:better_player/src/video_player/video_player_platform_interface.dart'
    as video_event;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:stockpathshala_beta/model/services/player/widgets/custom_controls_widget.dart';
import 'package:stockpathshala_beta/service/video_hls_player/video_view.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../service/page_manager.dart';
import '../../network_calls/dio_client/get_it_instance.dart';
import '../../utils/color_resource.dart';

// proper code
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:better_player/better_player.dart' as better;
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// NOTE: Replace below imports with your actual imports in project
// import 'your_cached_network_image.dart';
// import 'your_screen_protector.dart';
// import 'your_page_manager.dart';
// import 'your_hls_video_player.dart';
// import 'your_color_resource.dart';
// import 'your_custom_controls_widget.dart';
// import 'your_video_event.dart';

class FileVideoWidget extends StatefulWidget {
  final String url;
  final String? thumbnail;
  final void Function(bool)? onPlayButton;
  final Function(int, int) eventCallBack;
  final bool isScalp;
  final bool isOrientation;
  final bool orientation;
  final bool isVideo;
  final bool autoPlay;
  final bool showQualityPicker;

  const FileVideoWidget({
    super.key,
    required this.url,
    this.isScalp = false,
    this.isOrientation = true,
    this.orientation = true,
    this.autoPlay = true,
    this.isVideo = true,
    this.showQualityPicker = true,
    required this.eventCallBack,
    this.thumbnail,
    this.onPlayButton,
  });

  @override
  FileVideoWidgetState createState() => FileVideoWidgetState();
}

class FileVideoWidgetState extends State<FileVideoWidget> {
  late VideoPlayerController videoPlayerController;
  bool isBetterPlayer = false;
  bool isRecording = false;

  late better.BetterPlayerController _betterPlayerController;
  late better.BetterPlayerDataSource _dataSource;
  better.BetterPlayerTheme playerTheme = better.BetterPlayerTheme.custom;

  List<better.BetterPlayerEvent> events = [];
  final pageManager =
      getIt<PageManager>(); // Replace with your actual pageManager

  @override
  void initState() {
    super.initState();

    ScreenProtector.protectDataLeakageOn();
    checkScreenRecording();
    changeOrient();

    // Initially show system UI and enable edgeToEdge mode
      SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,    // Status bar
      SystemUiOverlay.bottom, // Navigation bar
    ],
  );

    if (!widget.url.contains(".m3u8")) {
      isBetterPlayer = true;

      if (!widget.isScalp) {
        if (!widget.isVideo) {
          try {
            File file = File(widget.url);
            List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
            _dataSource = better.BetterPlayerDataSource.memory(
              bytes,
              videoExtension: "mp4",
            );
          } catch (e) {
            _dataSource = better.BetterPlayerDataSource.file(widget.url);
          }
        } else {
          _dataSource = better.BetterPlayerDataSource.network(widget.url);
        }
      } else {
        _dataSource = better.BetterPlayerDataSource.network(widget.url);
      }

      _betterPlayerController = better.BetterPlayerController(
        better.BetterPlayerConfiguration(
          autoPlay: widget.autoPlay,
          looping: true,
          autoDispose: true,
          allowedScreenSleep: false,
          deviceOrientationsOnFullScreen: [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          controlsConfiguration: better.BetterPlayerControlsConfiguration(
            playerTheme: playerTheme,
            customControlsBuilder: (controller, onControlsVisibilityChanged) =>
                CustomControlsWidget(
              isScalp: widget.isScalp,
              isOrientation: widget.isOrientation,
              orientation: widget.orientation,
              controller: controller,
              onControlsVisibilityChanged: onControlsVisibilityChanged,
              onFullScreenTap: _toggleFullScreen,
            ),
          ),
          aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
          fit: BoxFit.contain,
        ),
      );

      _betterPlayerController.setupDataSource(_dataSource);
      _betterPlayerController.addEventsListener(_handleEvent);
    }
  }

  void _toggleFullScreen() {
    if (_betterPlayerController.isFullScreen) {
      _betterPlayerController.exitFullScreen();

      // Show system UI overlays and allow portrait orientation
        SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,    // Status bar
      SystemUiOverlay.bottom, // Navigation bar
    ],
  );
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      _betterPlayerController.enterFullScreen();

      // Show system UI overlays and allow landscape orientations
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  Future<void> checkScreenRecording() async {
    bool recording = await ScreenProtector.isRecording();
    if (recording != isRecording) {
      setState(() {
        isRecording = recording;
      });
      if (isRecording) showRecordingDetectedAlert();
    }
    Future.delayed(const Duration(seconds: 2), checkScreenRecording);
  }

  void showRecordingDetectedAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Screen Recording Detected'),
        content: const Text(
            'Please stop screen recording to continue using the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

 void changeOrient() {
    if (!widget.orientation) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
  }

  Future<void> _handleEvent(better.BetterPlayerEvent event) async {
    events.insert(0, event);

    if (event.betterPlayerEventType == better.BetterPlayerEventType.progress) {
      widget.eventCallBack(
        event.parameters?['progress']?.inSeconds ?? 0,
        event.parameters?['duration']?.inSeconds ?? 0,
      );
    }

    if (event.betterPlayerEventType == better.BetterPlayerEventType.play) {
      WakelockPlus.enable();
    } else if (event.betterPlayerEventType ==
        better.BetterPlayerEventType.pause) {
      WakelockPlus.disable();
    }

    if (pageManager.playButtonNotifier.value == ButtonState.playing) {
      await _betterPlayerController.pause();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _pauseAndResetOrientation();
  }

  @override
  void dispose() {
    super.dispose();
    _disposePlayer();
  }

  Future<void> _pauseAndResetOrientation() async {
    if (!isBetterPlayer) {
      await videoPlayerController.pause();
    } else {
      await _betterPlayerController.pause();
    }
      SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,    // Status bar
      SystemUiOverlay.bottom, // Navigation bar
    ],
  );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.disable();
  }

  Future<void> _disposePlayer() async {
    ScreenProtector.protectDataLeakageOff();
    WakelockPlus.disable();
    if (!isBetterPlayer) {
      await videoPlayerController.dispose();
    }
      SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,    // Status bar
      SystemUiOverlay.bottom, // Navigation bar
    ],
  );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: VisibilityDetector(
                key: Key(widget.url.toString()),
                onVisibilityChanged: (visibilityInfo) async {
                  double visiblePercentage =
                      visibilityInfo.visibleFraction * 100;
                  if (widget.autoPlay) {
                    if (visiblePercentage > 80) {
                      if (isBetterPlayer) {
                        await _betterPlayerController.play();
                      } else {
                        await videoPlayerController.play();
                      }
                      WakelockPlus.enable();
                    } else {
                      if (isBetterPlayer && widget.isScalp) {
                        await _betterPlayerController.pause();
                      } else {
                        await videoPlayerController.pause();
                      }
                      WakelockPlus.disable();
                    }
                  }
                },
                child: isBetterPlayer
                    ? SafeArea(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            GestureDetector(
                              onTap: widget.isScalp
                                  ? () async {
                                      if (await _betterPlayerController
                                              .isPlaying() ??
                                          false) {
                                        await _betterPlayerController.pause();
                                        WakelockPlus.disable();
                                      } else {
                                        await _betterPlayerController.play();
                                        WakelockPlus.enable();
                                      }
                                      bool isPlaying =
                                          await _betterPlayerController
                                                  .isPlaying() ??
                                              false;
                                      widget.onPlayButton?.call(isPlaying);
                                    }
                                  : null,
                              child: better.BetterPlayer(
                                controller: _betterPlayerController,
                              ),
                            ),
                            StreamBuilder(
                              stream: _betterPlayerController
                                  .videoPlayerController
                                  ?.videoEventStreamController
                                  .stream,
                              builder: (context, snapshot) {
                                return Visibility(
                                  visible: snapshot.data?.eventType == null ||
                                      snapshot.data?.eventType ==
                                          video_event
                                              .VideoEventType.bufferingStart,
                                  child: widget.thumbnail == null ||
                                          widget.thumbnail == ""
                                      ? Container(
                                          color: ColorResource.secondaryColor,
                                          child: const Center(
                                            child: SizedBox(
                                              height: 70,
                                              width: 70,
                                              child: CircularProgressIndicator(
                                                color: ColorResource.white,
                                                strokeWidth: 1,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: cachedNetworkImage(
                                            widget.thumbnail ?? "",
                                            imageLoader: false,
                                          ),
                                        ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : SafeArea(
                        child: HlsVideoPlayer(
                          thumbnail: widget.thumbnail,
                          m3u8Show: widget.showQualityPicker,
                          showControllers: !widget.isScalp,
                          aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
                          videoUrl: widget.url,
                          onVideoPosition: (position, duration) {
                            widget.eventCallBack(position, duration);
                          },
                          onVideoInitCompleted: (cont) async {
                            videoPlayerController = cont;
                            await cont.setLooping(true);
                            if (!widget.autoPlay) {
                              await cont.pause();
                              WakelockPlus.disable();
                            } else {
                              WakelockPlus.enable();
                            }
                          },
                          onPlayButtonTap: (val) {
                            widget.onPlayButton?.call(val);
                            if (val) {
                              WakelockPlus.enable();
                            } else {
                              WakelockPlus.disable();
                            }
                          },
                        ),
                      ),
              ),
            ),
            if (isRecording)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    "please off screen recording",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/*class FileVideoWidget extends StatefulWidget {
  final String url;
  final String? thumbnail;
  final void Function(bool)? onPlayButton;
  final Function(int, int) eventCallBack;
  final bool isScalp;
  final bool isOrientation;
  final bool orientation;
  final bool isVideo;
  final bool autoPlay;
  final bool showQualityPicker;

  const FileVideoWidget({
    super.key,
    required this.url,
    this.isScalp = false,
    this.isOrientation = true,
    this.orientation = true,
    this.autoPlay = true,
    this.isVideo = true,
    this.showQualityPicker = true,
    required this.eventCallBack,
    this.thumbnail,
    this.onPlayButton,
  });

  @override
  FileVideoWidgetState createState() => FileVideoWidgetState();
}

class FileVideoWidgetState extends State<FileVideoWidget> {
  late VideoPlayerController videoPlayerController;
  bool fullscreen = false;
  bool isBetterPlayer = false;
  bool isRecording = false;
  late better.BetterPlayerController _betterPlayerController;
  late better.BetterPlayerDataSource _dataSource;
  better.BetterPlayerTheme playerTheme = better.BetterPlayerTheme.custom;

  List<better.BetterPlayerEvent> events = [];
  final pageManager = getIt<PageManager>();

  @override
  void initState() {
    super.initState();
    ScreenProtector.protectDataLeakageOn();
    checkScreenRecording();
    changeOrient();

    if (!widget.url.contains(".m3u8")) {
      isBetterPlayer = true;

      if (!widget.isScalp) {
        if (!widget.isVideo) {
          try {
            File file = File(widget.url);
            List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
            _dataSource = better.BetterPlayerDataSource.memory(
              bytes,
              videoExtension: "mp4",
            );
          } catch (e) {
            _dataSource = better.BetterPlayerDataSource.file(widget.url);
          }
        } else {
          _dataSource = better.BetterPlayerDataSource.network(widget.url);
        }
      } else {
        _dataSource = better.BetterPlayerDataSource.network(widget.url);
      }

      _betterPlayerController = better.BetterPlayerController(
        better.BetterPlayerConfiguration(
          autoPlay: widget.autoPlay,
          looping: true,
          autoDispose: true,
          allowedScreenSleep: false,
          deviceOrientationsOnFullScreen: [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          controlsConfiguration: better.BetterPlayerControlsConfiguration(
            playerTheme: playerTheme,
            customControlsBuilder: (controller, onControlsVisibilityChanged) =>
                CustomControlsWidget(
                  isScalp: widget.isScalp,
                  isOrientation: widget.isOrientation,
                  orientation: widget.orientation,
                  controller: controller,
                  onControlsVisibilityChanged: onControlsVisibilityChanged,
                  onFullScreenTap: () {
                    if (_betterPlayerController.isFullScreen) {
                      _betterPlayerController.exitFullScreen();
                    } else {
                      _betterPlayerController.enterFullScreen();
                    }
                  },
                ),
          ),
          aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
          fit: BoxFit.contain,
        ),
      );

      _betterPlayerController.setupDataSource(_dataSource);
      _betterPlayerController.addEventsListener(_handleEvent);
    }
  }

  Future<void> checkScreenRecording() async {
    bool recording = await ScreenProtector.isRecording();
    if (recording != isRecording) {
      setState(() {
        isRecording = recording;
      });
      if (isRecording) showRecordingDetectedAlert();
    }
    Future.delayed(const Duration(seconds: 2), checkScreenRecording);
  }

  void showRecordingDetectedAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Screen Recording Detected'),
        content: const Text('Please stop screen recording to continue using the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void changeOrient() {
    if (!widget.orientation) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
  }

  Future<void> _handleEvent(better.BetterPlayerEvent event) async {
    events.insert(0, event);
    if (event.betterPlayerEventType == better.BetterPlayerEventType.progress) {
      widget.eventCallBack(
        event.parameters?['progress']?.inSeconds ?? 0,
        event.parameters?['duration']?.inSeconds ?? 0,
      );
    }

    if (event.betterPlayerEventType == better.BetterPlayerEventType.play) {
      WakelockPlus.enable();
    } else if (event.betterPlayerEventType == better.BetterPlayerEventType.pause) {
      WakelockPlus.disable();
    }

    if (pageManager.playButtonNotifier.value == ButtonState.playing) {
      await _betterPlayerController.pause();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _pauseAndResetOrientation();
  }

  @override
  void dispose() {
    super.dispose();
    _disposePlayer();
  }

  Future<void> _pauseAndResetOrientation() async {
    if (!isBetterPlayer) {
      await videoPlayerController.pause();
    } else {
      await _betterPlayerController.pause();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.disable();
  }

  Future<void> _disposePlayer() async {
    ScreenProtector.protectDataLeakageOff();
    WakelockPlus.disable();
    if (!isBetterPlayer) {
      await videoPlayerController.dispose();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: VisibilityDetector(
              key: Key(widget.url.toString()),
              onVisibilityChanged: (visibilityInfo) async {
                double visiblePercentage = visibilityInfo.visibleFraction * 100;
                if (widget.autoPlay) {
                  if (visiblePercentage > 80) {
                    if (isBetterPlayer) {
                      await _betterPlayerController.play();
                    } else {
                      await videoPlayerController.play();
                    }
                    WakelockPlus.enable();
                  } else {
                    if (isBetterPlayer && widget.isScalp) {
                      await _betterPlayerController.pause();
                    } else {
                      await videoPlayerController.pause();
                    }
                    WakelockPlus.disable();
                  }
                }
              },
              child: isBetterPlayer
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: widget.isScalp
                        ? () async {
                      if (await _betterPlayerController.isPlaying() ?? false) {
                        await _betterPlayerController.pause();
                        WakelockPlus.disable();
                      } else {
                        await _betterPlayerController.play();
                        WakelockPlus.enable();
                      }

                      bool isPlaying =
                          await _betterPlayerController.isPlaying() ?? false;
                      widget.onPlayButton?.call(isPlaying);
                    }
                        : null,
                    child: better.BetterPlayer(
                      controller: _betterPlayerController,
                    ),
                  ),
                  StreamBuilder(
                    stream: _betterPlayerController
                        .videoPlayerController?.videoEventStreamController.stream,
                    builder: (context, snapshot) {
                      return Visibility(
                        visible: snapshot.data?.eventType == null ||
                            snapshot.data?.eventType ==
                                video_event.VideoEventType.bufferingStart,
                        child: widget.thumbnail == null || widget.thumbnail == ""
                            ? Container(
                          color: ColorResource.secondaryColor,
                          child: const Center(
                            child: SizedBox(
                              height: 70,
                              width: 70,
                              child: CircularProgressIndicator(
                                color: ColorResource.white,
                                strokeWidth: 1,
                              ),
                            ),
                          ),
                        )
                            : Center(
                          child: cachedNetworkImage(
                            widget.thumbnail ?? "",
                            imageLoader: false,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
                  : HlsVideoPlayer(
                thumbnail: widget.thumbnail,
                m3u8Show: widget.showQualityPicker,
                showControllers: !widget.isScalp,
                aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
                videoUrl: widget.url,
                onVideoPosition: (position, duration) {
                  widget.eventCallBack(position, duration);
                },
                onVideoInitCompleted: (cont) async {
                  videoPlayerController = cont;
                  await cont.setLooping(true);
                  if (!widget.autoPlay) {
                    await cont.pause();
                    WakelockPlus.disable();
                  } else {
                    WakelockPlus.enable();
                  }
                },
                onPlayButtonTap: (val) {
                  widget.onPlayButton?.call(val);
                  if (val) {
                    WakelockPlus.enable();
                  } else {
                    WakelockPlus.disable();
                  }
                },
              ),
            ),
          ),
          if (isRecording)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey,
              child: const Center(
                child: Text(
                  "please off screen recording",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}*/

//corrected code below
// import 'dart:async';
// import 'dart:io';
// import 'package:better_player/better_player.dart' as better;
// import 'package:better_player/src/video_player/video_player_platform_interface.dart' as video_event;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:screen_protector/screen_protector.dart';
// import 'package:stockpathshala_beta/model/services/player/widgets/custom_controls_widget.dart';
// import 'package:stockpathshala_beta/service/video_hls_player/video_view.dart';
// import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
// import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
// import '../../../service/page_manager.dart';
// import '../../network_calls/dio_client/get_it_instance.dart';
// import '../../utils/color_resource.dart';
//
// class FileVideoWidget extends StatefulWidget {
//   final String url;
//   final String? thumbnail;
//   final void Function(bool)? onPlayButton;
//   final Function(int, int) eventCallBack;
//   final bool isScalp;
//   final bool isOrientation;
//   final bool orientation;
//   final bool isVideo;
//   final bool autoPlay;
//   final bool showQualityPicker;
//
//   const FileVideoWidget({
//     super.key,
//     required this.url,
//     this.isScalp = false,
//     this.isOrientation = true,
//     this.orientation = true,
//     this.autoPlay = true,
//     this.isVideo = true,
//     this.showQualityPicker = true,
//     required this.eventCallBack,
//     this.thumbnail,
//     this.onPlayButton,
//   });
//
//   @override
//   FileVideoWidgetState createState() => FileVideoWidgetState();
// }
//
// class FileVideoWidgetState extends State<FileVideoWidget> {
//   late VideoPlayerController videoPlayerController;
//   bool fullscreen = false;
//   bool isBetterPlayer = false;
//   bool isRecording = false;
//   late better.BetterPlayerController _betterPlayerController;
//   late better.BetterPlayerDataSource _dataSource;
//   better.BetterPlayerTheme playerTheme = better.BetterPlayerTheme.custom;
//
//   List<better.BetterPlayerEvent> events = [];
//   final pageManager = getIt<PageManager>();
//
//   @override
//   void initState() {
//     super.initState();
//     logPrint("i am in FileVideoWidget");
//     logPrint("widget.url:: ${widget.url}");
//     ScreenProtector.protectDataLeakageOn();
//     checkScreenRecording();
//     changeOrient();
//
//     if (!widget.url.contains(".m3u8")) {
//       isBetterPlayer = true;
//       if (!widget.isScalp) {
//         if (!widget.isVideo) {
//           try {
//             File file = File(widget.url);
//             List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
//             _dataSource = better.BetterPlayerDataSource.memory(
//               bytes,
//               videoExtension: "mp4",
//             );
//           } catch (e) {
//             if (e is PathNotFoundException) {
//               logPrint("message ${e.message}");
//             }
//             _dataSource = better.BetterPlayerDataSource.file(widget.url);
//           }
//         } else {
//           _dataSource = better.BetterPlayerDataSource.network(widget.url);
//         }
//       } else {
//         _dataSource = better.BetterPlayerDataSource.network(widget.url);
//       }
//
//       _betterPlayerController = better.BetterPlayerController(
//         better.BetterPlayerConfiguration(
//           autoPlay: widget.autoPlay,
//           looping: true,
//           autoDispose: true,
//           allowedScreenSleep: false,
//           deviceOrientationsOnFullScreen: [
//             DeviceOrientation.landscapeLeft,
//             DeviceOrientation.landscapeRight,
//           ],
//           deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//           //deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//           // deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeRight],
//           controlsConfiguration: better.BetterPlayerControlsConfiguration(
//             playerTheme: playerTheme,
//             customControlsBuilder: (controller, onControlsVisibilityChanged) =>
//                 CustomControlsWidget(
//                   isScalp: widget.isScalp,
//                   isOrientation: widget.isOrientation,
//                   orientation: widget.orientation,
//                   controller: controller,
//                   onControlsVisibilityChanged: onControlsVisibilityChanged,
//                 ),
//           ),
//           aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
//           fit: BoxFit.contain,
//         ),
//       );
//
//       _betterPlayerController.setupDataSource(_dataSource);
//       _betterPlayerController.addEventsListener(_handleEvent);
//     }
//   }
//
//   Future<void> checkScreenRecording() async {
//     bool recording = await ScreenProtector.isRecording();
//     if (recording != isRecording) {
//       setState(() {
//         isRecording = recording;
//       });
//       if (isRecording) showRecordingDetectedAlert();
//     }
//     Future.delayed(const Duration(seconds: 2), checkScreenRecording);
//   }
//
//   void showRecordingDetectedAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Screen Recording Detected', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         content: const Text('Please stop screen recording to continue using the app.', style: TextStyle(fontSize: 14)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void changeOrient() {
//     if (!widget.orientation) {
//       SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     }
//   }
//
//   Future<void> _handleEvent(better.BetterPlayerEvent event) async {
//     events.insert(0, event);
//     if (event.betterPlayerEventType == better.BetterPlayerEventType.progress) {
//       widget.eventCallBack(
//         event.parameters?['progress']?.inSeconds ?? 0,
//         event.parameters?['duration']?.inSeconds ?? 0,
//       );
//     }
//
//     if (event.betterPlayerEventType == better.BetterPlayerEventType.play) {
//       WakelockPlus.enable();
//     } else if (event.betterPlayerEventType == better.BetterPlayerEventType.pause) {
//       WakelockPlus.disable();
//     }
//
//     if (pageManager.playButtonNotifier.value == ButtonState.playing) {
//       await _betterPlayerController.pause();
//     }
//   }
//
//   @override
//   Future<void> deactivate() async {
//     if (!isBetterPlayer) {
//       await videoPlayerController.pause();
//     } else {
//       await _betterPlayerController.pause();
//     }
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     WakelockPlus.disable();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() async {
//     ScreenProtector.protectDataLeakageOff();
//     WakelockPlus.disable();
//     if (!isBetterPlayer) {
//       await videoPlayerController.dispose();
//     }
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 0),
//             child: VisibilityDetector(
//               key: Key(widget.url.toString()),
//               onVisibilityChanged: (visibilityInfo) async {
//                 double visiblePercentage = visibilityInfo.visibleFraction * 100;
//                 if (widget.autoPlay) {
//                   if (visiblePercentage > 80) {
//                     if (isBetterPlayer) {
//                       await _betterPlayerController.play();
//                     } else {
//                       await videoPlayerController.play();
//                     }
//                     WakelockPlus.enable();
//                   } else {
//                     if (isBetterPlayer && widget.isScalp) {
//                       await _betterPlayerController.pause();
//                     } else {
//                       await videoPlayerController.pause();
//                     }
//                     WakelockPlus.disable();
//                   }
//                 }
//               },
//               child: isBetterPlayer
//                   ? Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   GestureDetector(
//                     onTap: widget.isScalp
//                         ? () async {
//                       if (_betterPlayerController.isPlaying() ?? false) {
//                         await _betterPlayerController.pause();
//                         WakelockPlus.disable();
//                       } else {
//                         await _betterPlayerController.play();
//                         WakelockPlus.enable();
//                       }
//                       widget.onPlayButton?.call(_betterPlayerController.isPlaying() ?? false);
//                     }
//                         : null,
//                     child: better.BetterPlayer(
//                       controller: _betterPlayerController,
//                     ),
//                   ),
//
//                   /// ✅ Fullscreen button on wide screens
//                   if (screenWidth > 600)
//                     Positioned(
//                       top: 16,
//                       right: 16,
//                       child: IconButton(
//                         icon: Icon(Icons.fullscreen, color: Colors.white),
//                         onPressed: () {
//                           _betterPlayerController.enterFullScreen();
//                         },
//                       ),
//                     ),
//
//                   StreamBuilder(
//                     stream: _betterPlayerController.videoPlayerController?.videoEventStreamController.stream,
//                     builder: (context, snapshot) {
//                       return Visibility(
//                         visible: snapshot.data?.eventType == null ||
//                             snapshot.data?.eventType == video_event.VideoEventType.bufferingStart,
//                         child: widget.thumbnail == null || widget.thumbnail == ""
//                             ? Container(
//                           color: ColorResource.secondaryColor,
//                           child: const Center(
//                             child: SizedBox(
//                               height: 70,
//                               width: 70,
//                               child: CircularProgressIndicator(color: ColorResource.white, strokeWidth: 1),
//                             ),
//                           ),
//                         )
//                             : Center(
//                           child: cachedNetworkImage(
//                             widget.thumbnail ?? "",
//                             imageLoader: false,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               )
//                   : HlsVideoPlayer(
//                 thumbnail: widget.thumbnail,
//                 m3u8Show: widget.showQualityPicker,
//                 showControllers: !widget.isScalp,
//                 aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
//                 videoUrl: widget.url,
//                 onVideoPosition: (position, duration) {
//                   widget.eventCallBack(position, duration);
//                 },
//                 onVideoInitCompleted: (cont) async {
//                   videoPlayerController = cont;
//                   await cont.setLooping(true);
//                   if (!widget.autoPlay) {
//                     await cont.pause();
//                     WakelockPlus.disable();
//                   } else {
//                     WakelockPlus.enable();
//                   }
//                 },
//                 onPlayButtonTap: (val) {
//                   widget.onPlayButton?.call(val);
//                   if (val) {
//                     WakelockPlus.enable();
//                   } else {
//                     WakelockPlus.disable();
//                   }
//                 },
//               ),
//             ),
//           ),
//
//           if (isRecording)
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Colors.grey,
//               child: const Center(
//                 child: Text(
//                   "please off screen recording",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:io';
//
// import 'package:better_player/better_player.dart' as better;
// import 'package:better_player/src/video_player/video_player_platform_interface.dart'
// as video_event;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:screen_protector/screen_protector.dart';
// import 'package:wakelock/wakelock.dart';
//
// import 'package:stockpathshala_beta/model/services/player/widgets/custom_controls_widget.dart';
// import 'package:stockpathshala_beta/service/video_hls_player/video_view.dart';
// import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
// import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
//
// import '../../../service/page_manager.dart';
// import '../../network_calls/dio_client/get_it_instance.dart';
// import '../../utils/color_resource.dart';
//
// class FileVideoWidget extends StatefulWidget {
//   final String url;
//   final String? thumbnail;
//   final void Function(bool)? onPlayButton;
//   final Function(int, int) eventCallBack;
//   final bool isScalp;
//   final bool isOrientation;
//   final bool orientation;
//   final bool isVideo;
//   final bool autoPlay;
//   final bool showQualityPicker;
//
//   const FileVideoWidget({
//     super.key,
//     required this.url,
//     this.isScalp = false,
//     this.isOrientation = true,
//     this.orientation = true,
//     this.autoPlay = true,
//     this.isVideo = true,
//     this.showQualityPicker = true,
//     required this.eventCallBack,
//     this.thumbnail,
//     this.onPlayButton,
//   });
//
//   @override
//   FileVideoWidgetState createState() => FileVideoWidgetState();
// }
//
// class FileVideoWidgetState extends State<FileVideoWidget> {
//   late VideoPlayerController videoPlayerController;
//   bool fullscreen = false;
//   bool isBetterPlayer = false;
//   bool isRecording = false;
//   late better.BetterPlayerController _betterPlayerController;
//   late better.BetterPlayerDataSource _dataSource;
//   better.BetterPlayerTheme playerTheme = better.BetterPlayerTheme.custom;
//
//   List<better.BetterPlayerEvent> events = [];
//
//   final pageManager = getIt<PageManager>();
//
//   void _protectDataLeakageWithBlur() async =>
//       await ScreenProtector.protectDataLeakageWithBlur();
//
//   @override
//   void initState() {
//     super.initState();
//     logPrint("i am in FileVideoWidget");
//     logPrint("widget.url:: ${widget.url}");
//
//     ScreenProtector.protectDataLeakageOn();
//     _protectDataLeakageWithBlur();
//     checkScreenRecording();
//     changeOrient();
//
//     // 🔐 Prevent screen from sleeping
//     Wakelock.enable();
//
//     if (!widget.url.contains(".m3u8")) {
//       isBetterPlayer = true;
//
//       if (!widget.isScalp) {
//         if (!widget.isVideo) {
//           try {
//             File file = File(widget.url);
//             List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
//             _dataSource = better.BetterPlayerDataSource.memory(
//               bytes,
//               videoExtension: "mp4",
//             );
//           } catch (e) {
//             if (e is PathNotFoundException) {
//               logPrint("message ${e.message}");
//             }
//             _dataSource = better.BetterPlayerDataSource.file(widget.url);
//           }
//         } else {
//           _dataSource = better.BetterPlayerDataSource.network(widget.url);
//         }
//       } else {
//         _dataSource = better.BetterPlayerDataSource.network(widget.url);
//       }
//
//       _betterPlayerController = better.BetterPlayerController(
//         better.BetterPlayerConfiguration(
//           autoPlay: widget.autoPlay,
//           looping: true,
//           autoDispose: true,
//           allowedScreenSleep: false,
//           deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//           deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeRight],
//           controlsConfiguration: better.BetterPlayerControlsConfiguration(
//             playerTheme: playerTheme,
//             customControlsBuilder: (controller, onControlsVisibilityChanged) =>
//                 CustomControlsWidget(
//                   isScalp: widget.isScalp,
//                   isOrientation: widget.isOrientation,
//                   orientation: widget.orientation,
//                   controller: controller,
//                   onControlsVisibilityChanged: onControlsVisibilityChanged,
//                 ),
//           ),
//           aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
//           fit: BoxFit.contain,
//         ),
//       );
//       _betterPlayerController.setupDataSource(_dataSource);
//       _betterPlayerController.addEventsListener(_handleEvent);
//     }
//   }
//
//   Future<void> checkScreenRecording() async {
//     bool recording = await ScreenProtector.isRecording();
//     if (recording != isRecording) {
//       setState(() {
//         isRecording = recording;
//       });
//       print('Is screen recording happening? $isRecording');
//       if (isRecording) {
//         showRecordingDetectedAlert();
//       }
//     }
//     Future.delayed(const Duration(seconds: 2), checkScreenRecording);
//   }
//
//   void showRecordingDetectedAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Screen Recording Detected',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         content: const Text(
//           'Please stop screen recording to continue using the app.',
//           style: TextStyle(fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void changeOrient() {
//     if (!widget.orientation) {
//       SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     }
//   }
//
//   Future<void> _handleEvent(better.BetterPlayerEvent event) async {
//     events.insert(0, event);
//     if (event.betterPlayerEventType == better.BetterPlayerEventType.progress) {
//       widget.eventCallBack(
//         event.parameters?['progress'].inSeconds,
//         event.parameters?['duration']?.inSeconds ?? 0,
//       );
//     }
//     if (pageManager.playButtonNotifier.value == ButtonState.playing) {
//       await _betterPlayerController.pause();
//     }
//   }
//
//   @override
//   Future<void> deactivate() async {
//     if (!isBetterPlayer) {
//       await videoPlayerController.pause();
//     } else {
//       await _betterPlayerController.pause();
//     }
//
//     logPrint("deactivate file");
//
//     // 🔓 Allow screen to sleep again
//     Wakelock.disable();
//
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     ScreenProtector.protectDataLeakageOff();
//
//     if (!isBetterPlayer) {
//       videoPlayerController.removeListener(() async {
//         await videoPlayerController.dispose();
//       });
//     }
//
//     logPrint("dispose file");
//
//     // 🔓 Allow screen sleep again
//     Wakelock.disable();
//
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 0),
//             child: VisibilityDetector(
//               key: Key(widget.url.toString()),
//               onVisibilityChanged: (visibilityInfo) async {
//                 double visiblePercentage =
//                     visibilityInfo.visibleFraction * 100;
//                 logPrint("visiblePercentage $visiblePercentage");
//
//                 if (widget.autoPlay) {
//                   if (visiblePercentage > 80) {
//                     if (isBetterPlayer) {
//                       await _betterPlayerController.play();
//                     } else {
//                       await videoPlayerController.play();
//                     }
//                   } else {
//                     if (isBetterPlayer && widget.isScalp) {
//                       await _betterPlayerController.pause();
//                     } else {
//                       await videoPlayerController.pause();
//                     }
//                   }
//                 }
//               },
//               child: isBetterPlayer
//                   ? Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   GestureDetector(
//                     onTap: widget.isScalp
//                         ? () async {
//                       if (_betterPlayerController.isPlaying() ??
//                           false) {
//                         await _betterPlayerController.pause();
//                       } else {
//                         await _betterPlayerController.play();
//                       }
//                       if (widget.onPlayButton != null) {
//                         widget.onPlayButton!(
//                             _betterPlayerController.isPlaying() ??
//                                 false);
//                       }
//                     }
//                         : null,
//                     child: better.BetterPlayer(
//                       controller: _betterPlayerController,
//                     ),
//                   ),
//                   StreamBuilder(
//                     stream: _betterPlayerController
//                         .videoPlayerController
//                         ?.videoEventStreamController
//                         .stream,
//                     builder: (context, snapshot) {
//                       return Visibility(
//                         visible: snapshot.data?.eventType == null ||
//                             snapshot.data?.eventType ==
//                                 video_event.VideoEventType
//                                     .bufferingStart,
//                         child: widget.thumbnail == null ||
//                             widget.thumbnail == ""
//                             ? Container(
//                           color: ColorResource.secondaryColor,
//                           child: const Center(
//                             child: SizedBox(
//                               height: 70,
//                               width: 70,
//                               child: CircularProgressIndicator(
//                                 color: ColorResource.white,
//                                 strokeWidth: 1,
//                               ),
//                             ),
//                           ),
//                         )
//                             : Center(
//                           child: cachedNetworkImage(
//                               widget.thumbnail ?? "",
//                               imageLoader: false),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               )
//                   : HlsVideoPlayer(
//                 thumbnail: widget.thumbnail,
//                 m3u8Show: widget.showQualityPicker,
//                 showControllers: !widget.isScalp,
//                 aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
//                 videoUrl: widget.url,
//                 onVideoPosition: (position, duration) {
//                   widget.eventCallBack(position, duration);
//                 },
//                 onVideoInitCompleted: (cont) async {
//                   videoPlayerController = cont;
//                   if (!widget.autoPlay) {
//                     await videoPlayerController.pause();
//                   }
//                   if (pageManager.playButtonNotifier.value ==
//                       ButtonState.playing) {
//                     await videoPlayerController.pause();
//                   }
//                   await cont.setLooping(true);
//                 },
//                 onPlayButtonTap: (val) {
//                   if (widget.onPlayButton != null) {
//                     widget.onPlayButton!(val);
//                   }
//                 },
//               ),
//             ),
//           ),
//           if (isRecording)
//             Center(
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.grey,
//                 child: const Center(
//                   child: Text(
//                     "please off screen recording",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// ----------------------------

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:screen_protector/screen_protector.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// class FileVideoWidget extends StatefulWidget {
//   final String url;
//   final String? thumbnail;
//   final void Function(bool)? onPlayButton;
//   final Function(int, int) eventCallBack;
//   final bool isScalp;
//   final bool isOrientation;
//   final bool orientation;
//   final bool isVideo;
//   final bool autoPlay;
//   final bool showQualityPicker;
//
//   const FileVideoWidget({
//     super.key,
//     required this.url,
//     this.isScalp = false,
//     this.isOrientation = true,
//     this.orientation = true,
//     this.autoPlay = true,
//     this.isVideo = true,
//     this.showQualityPicker = true,
//     required this.eventCallBack,
//     this.thumbnail,
//     this.onPlayButton,
//   });
//
//   @override
//   State<FileVideoWidget> createState() => _FileVideoWidgetState();
// }
//
// class _FileVideoWidgetState extends State<FileVideoWidget> {
//   late VideoPlayerController _controller;
//   bool isRecording = false;
//   bool isInitialized = false;
//   bool isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initPlayer();
//     ScreenProtector.protectDataLeakageOn();
//     _protectDataLeakageWithBlur();
//     _checkScreenRecording();
//     _changeOrientation();
//   }
//
//   void _changeOrientation() {
//     if (!widget.orientation) {
//       SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     }
//   }
//
//   void _protectDataLeakageWithBlur() async {
//     await ScreenProtector.protectDataLeakageWithBlur();
//   }
//
//   void _initPlayer() async {
//     if (widget.url.contains('.m3u8')) {
//       _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
//     } else {
//       _controller = widget.url.startsWith("http")
//           ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
//           : VideoPlayerController.file(File(widget.url));
//     }
//
//     await _controller.initialize();
//     await _controller.setLooping(true);
//
//     if (widget.autoPlay) {
//       await _controller.play();
//       isPlaying = true;
//       WakelockPlus.enable();
//     }
//
//     _controller.addListener(() {
//       if (_controller.value.isInitialized) {
//         final position = _controller.value.position.inSeconds;
//         final duration = _controller.value.duration.inSeconds;
//         widget.eventCallBack(position, duration);
//         if (isPlaying != _controller.value.isPlaying) {
//           setState(() => isPlaying = _controller.value.isPlaying);
//         }
//       }
//     });
//
//     setState(() => isInitialized = true);
//   }
//
//   void _checkScreenRecording() async {
//     bool recording = await ScreenProtector.isRecording();
//     if (recording != isRecording) {
//       setState(() => isRecording = recording);
//       if (isRecording) _showRecordingDetectedAlert();
//     }
//     Future.delayed(const Duration(seconds: 2), _checkScreenRecording);
//   }
//
//   void _showRecordingDetectedAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Screen Recording Detected'),
//         content: const Text('Please stop screen recording to continue using the app.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _togglePlay() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//       WakelockPlus.disable();
//     } else {
//       _controller.play();
//       WakelockPlus.enable();
//     }
//     widget.onPlayButton?.call(_controller.value.isPlaying);
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     ScreenProtector.protectDataLeakageOff();
//     _controller.dispose();
//     WakelockPlus.disable();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           VisibilityDetector(
//             key: Key(widget.url),
//             onVisibilityChanged: (info) {
//               final visible = info.visibleFraction * 100;
//               if (visible > 80 && widget.autoPlay) {
//                 _controller.play();
//                 WakelockPlus.enable();
//               } else {
//                 _controller.pause();
//                 WakelockPlus.disable();
//               }
//             },
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
//                 child: isInitialized
//                     ? Stack(
//                   children: [
//                     VideoPlayer(_controller),
//                     if (!_controller.value.isPlaying)
//                       Positioned.fill(
//                         child: widget.thumbnail != null
//                             ? CachedNetworkImage(imageUrl: widget.thumbnail!)
//                             : const ColoredBox(
//                           color: Colors.black,
//                           child: Center(child: CircularProgressIndicator()),
//                         ),
//                       ),
//                     GestureDetector(
//                       onTap: _togglePlay,
//                       child: Center(
//                         child: Icon(
//                           _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
//                           color: Colors.white,
//                           size: 60,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//                     : const Center(child: CircularProgressIndicator()),
//               ),
//             ),
//           ),
//           if (isRecording)
//             Container(
//               color: Colors.black54,
//               child: const Center(
//                 child: Text("Please stop screen recording", style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
