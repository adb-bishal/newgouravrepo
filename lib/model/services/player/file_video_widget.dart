import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart' as better;
import 'package:better_player/src/video_player/video_player_platform_interface.dart'
    as video_event;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stockpathshala_beta/model/services/player/widgets/custom_controls_widget.dart';
import 'package:stockpathshala_beta/service/video_hls_player/video_view.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../service/page_manager.dart';
import '../../network_calls/dio_client/get_it_instance.dart';
import '../../utils/color_resource.dart';

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
  VideoPlayerController? videoPlayerController;
  bool isBetterPlayer = false;
  bool isRecording = false;
  bool manualFullScreen = false;
  bool isFullscreenNow = false;
  bool _showThumbnail = true;
  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;

  // Create unique keys for this widget instance
  late final String _uniqueVisibilityKey;
  late final GlobalKey _betterPlayerKey;

  late better.BetterPlayerController betterPlayerController;
  late better.BetterPlayerDataSource dataSource;
  better.BetterPlayerTheme playerTheme = better.BetterPlayerTheme.custom;

  List<better.BetterPlayerEvent> events = [];
  final pageManager = getIt<PageManager>();

  @override
  void initState() {
    super.initState();

    _uniqueVisibilityKey =
        '${widget.url}_${DateTime.now().millisecondsSinceEpoch}_$hashCode';
    _betterPlayerKey = GlobalKey();

    manualFullScreen = false;
    isFullscreenNow = false;
    _showThumbnail = true;

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
            dataSource = better.BetterPlayerDataSource.memory(
              bytes,
              videoExtension: "mp4",
            );
          } catch (e) {
            dataSource = better.BetterPlayerDataSource.file(widget.url);
          }
        } else {
          dataSource = better.BetterPlayerDataSource.network(widget.url);
        }
      } else {
        dataSource = better.BetterPlayerDataSource.network(widget.url);
      }

      betterPlayerController = better.BetterPlayerController(
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
            showControls: true,
            showControlsOnInitialize: false,
            enableSkips: false,
            enablePlaybackSpeed: false,
            enableMute: true,
            enableFullscreen: !widget.isScalp,
            customControlsBuilder: (controller, onControlsVisibilityChanged) =>
                CustomControlsWidget(
              isScalp: widget.isScalp,
              isOrientation: widget.isOrientation,
              orientation: widget.orientation,
              controller: controller,
              onControlsVisibilityChanged: onControlsVisibilityChanged,
              onFullScreenTap: manualToggleFullScreen,
            ),
          ),
          aspectRatio: widget.isScalp ? 9 / 16 : 16 / 9,
          fit: BoxFit.contain,
        ),
      );

      betterPlayerController.setupDataSource(dataSource);
      betterPlayerController.addEventsListener(_handleEvent);
    }

    startOrientationListener();
  }

  void startOrientationListener() {
    accelerometerSubscription = accelerometerEvents.listen((event) {
      if (!manualFullScreen) {
        final isAutoRotateAllowed =
            Get.find<LiveClassDetailController>().isAutoRotateEnabled ?? false;

        if (!isAutoRotateAllowed) {
          return;
        }

        final x = event.x;
        final y = event.y;

        if (x.abs() < 3 && y.abs() > 7 && isFullscreenNow) {
          exitFullscreen(autoRotated: true);
        } else if (y.abs() < 3 && (x > 7 || x < -7) && !isFullscreenNow) {
          enterFullscreen(autoRotated: true);
        }
      }
    });
  }

  void stopOrientationListener() {
    accelerometerSubscription?.cancel();
  }

  Future<void> enterFullscreen({bool autoRotated = false}) async {
    if (!isFullscreenNow) {
      isFullscreenNow = true;
      betterPlayerController.enterFullScreen();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      if (!autoRotated) {
        manualFullScreen = true;
        stopOrientationListener();
      }
    }
  }

  Future<void> exitFullscreen({bool autoRotated = false}) async {
    if (isFullscreenNow) {
      isFullscreenNow = false;
      betterPlayerController.exitFullScreen();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      if (!autoRotated) {
        manualFullScreen = false;
        startOrientationListener();
      }
    }
  }

  void manualToggleFullScreen() {
    if (isFullscreenNow) {
      exitFullscreen();
    } else {
      enterFullscreen();
    }
  }

  Future<void> checkScreenRecording() async {
    if (!mounted) return;

    bool recording = await ScreenProtector.isRecording();
    if (recording != isRecording && mounted) {
      setState(() {
        isRecording = recording;
      });
      if (isRecording) showRecordingDetectedAlert();
    }

    if (mounted) {
      Future.delayed(const Duration(seconds: 2), checkScreenRecording);
    }
  }

  void showRecordingDetectedAlert() {
    if (!mounted) return;

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
    if (!mounted) return;

    events.insert(0, event);

    if (event.betterPlayerEventType == better.BetterPlayerEventType.progress) {
      widget.eventCallBack(
        event.parameters?['progress']?.inSeconds ?? 0,
        event.parameters?['duration']?.inSeconds ?? 0,
      );
    }

    if (event.betterPlayerEventType ==
            better.BetterPlayerEventType.initialized ||
        event.betterPlayerEventType == better.BetterPlayerEventType.play) {
      if (_showThumbnail && mounted) {
        setState(() {
          _showThumbnail = false;
        });
      }
    }

    if (event.betterPlayerEventType == better.BetterPlayerEventType.play) {
      WakelockPlus.enable();
    } else if (event.betterPlayerEventType ==
        better.BetterPlayerEventType.pause) {
      WakelockPlus.disable();
    }

    if (pageManager.playButtonNotifier.value == ButtonState.playing) {
      await betterPlayerController.pause();
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
    accelerometerSubscription?.cancel();
    if (isBetterPlayer) {
      betterPlayerController.dispose();
    }
    _disposePlayer();
  }

  Future<void> _pauseAndResetOrientation() async {
    if (!isBetterPlayer) {
      await videoPlayerController?.pause();
    } else {
      await betterPlayerController.pause();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.disable();
  }

  Future<void> _disposePlayer() async {
    ScreenProtector.protectDataLeakageOff();
    WakelockPlus.disable();
    if (!isBetterPlayer) {
      await videoPlayerController?.dispose();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
                key: Key(_uniqueVisibilityKey),
                onVisibilityChanged: (visibilityInfo) async {
                  if (!mounted) return;

                  double visiblePercentage =
                      visibilityInfo.visibleFraction * 100;
                  if (widget.autoPlay) {
                    if (visiblePercentage > 80) {
                      if (isBetterPlayer) {
                        await betterPlayerController.play();
                      } else {
                        await videoPlayerController?.play();
                      }
                      WakelockPlus.enable();
                    } else {
                      if (isBetterPlayer && widget.isScalp) {
                        await betterPlayerController.pause();
                      } else if (!isBetterPlayer) {
                        await videoPlayerController?.pause();
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
                          better.BetterPlayer(
                            key: _betterPlayerKey,
                            controller: betterPlayerController,
                          ),
                          if (!_showThumbnail && widget.isScalp)
                            GestureDetector(
                              onTap: () async {
                                bool isPlaying =
                                    betterPlayerController.isPlaying() ?? false;
                                if (isPlaying) {
                                  await betterPlayerController.pause();
                                  WakelockPlus.disable();
                                } else {
                                  await betterPlayerController.play();
                                  WakelockPlus.enable();
                                }
                                widget.onPlayButton?.call(!isPlaying);
                              },
                              child: Container(color: Colors.transparent),
                            ),
                          if (_showThumbnail)
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: ColorResource.secondaryColor,
                              child: widget.thumbnail == null ||
                                      widget.thumbnail!.isEmpty
                                  ? const Center(
                                      child: SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: CircularProgressIndicator(
                                          color: ColorResource.white,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: cachedNetworkImage(
                                        widget.thumbnail!,
                                        imageLoader: false,
                                      ),
                                    ),
                            ),
                          if (!_showThumbnail)
                            StreamBuilder(
                              stream: betterPlayerController
                                  .videoPlayerController
                                  ?.videoEventStreamController
                                  .stream,
                              builder: (context, snapshot) {
                                final event = snapshot.data;
                                final isBuffering = event?.eventType ==
                                    video_event.VideoEventType.bufferingStart;

                                if (isBuffering) {
                                  return Container(
                                    color: ColorResource.secondaryColor
                                        .withOpacity(0.8),
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
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                        ],
                      ))
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
