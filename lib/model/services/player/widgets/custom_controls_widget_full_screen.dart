import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../service/page_manager.dart';
import '../../../utils/color_resource.dart';
import '../../../utils/style_resource.dart';

class CustomControlsWidgetFullScreen extends StatefulWidget {
  final bool isScalp;
  final bool? isOrientation; // Optional parameter, can be null
  final bool? orientation; // Optional parameter, can be null
  final BetterPlayerController? controller;
  final VoidCallback? onFullScreenTap;
  final Function(bool visibility)? onControlsVisibilityChanged;

  // Constructor with optional isOrientation
  CustomControlsWidgetFullScreen({
    Key? key,
    required this.isScalp,
    this.controller,
    this.isOrientation, // No need to mark it as required if it can be null
    this.orientation, // No need to mark it as required if it can be null
    this.onControlsVisibilityChanged,
    this.onFullScreenTap,
  }) : super(key: key);

  @override
  State<CustomControlsWidgetFullScreen> createState() =>
      _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidgetFullScreen> {
  //double slider = 0.0;
  double opacity = 1.0;
  //int? position = 0;
  bool isManualSlide = false;
  double selectedSpeed = 1.0; // Default speed

  ProgressBarState progressVideoNotifier = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );

  @override
  void initState() {
    widget.controller!.videoPlayerController!.addListener(updateSeeker);
    // orientationChange();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!(widget.controller?.isFullScreen ?? false)) {
        widget.controller?.enterFullScreen();
        widget.controller?.play();
      }
    });

    super.initState();
  }

  orientationChange() {
    if (widget.orientation == false) {
      widget.controller?.enterFullScreen();
      widget.controller?.play();
    } else {
      Get.back();
    }
  }

  Future<void> updateSeeker() async {
    final newPosition =
        await widget.controller?.videoPlayerController?.position;
    //print(newPosition);
    // if(mounted){
    //   setState(() {
    //     // position = newPosition?.inSeconds;
    //     // slider = newPosition?.inSeconds.toDouble() ?? 0.0;
    //   });
    // }
    if (!isManualSlide) {
      final oldState = progressVideoNotifier;
      progressVideoNotifier = ProgressBarState(
        current: newPosition ?? Duration.zero,
        buffered: oldState.buffered,
        total: oldState.total,
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isScalp) {
      return const SizedBox();
    } else {
      return Visibility(
        visible: !widget.isScalp,
        child: SafeArea(
          // Added SafeArea here
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: onHideControllers,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.fastOutSlowIn,
                          opacity: opacity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: double.infinity,
                                    child: Material(
                                      color: Colors.transparent,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(300),
                                          bottomRight: Radius.circular(300),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,

                                      /// Rewind button
                                      child: InkWell(
                                        onTap: onHideControllers,
                                        splashColor: ColorResource.white
                                            .withOpacity(0.3),
                                        onDoubleTap: () async {
                                          Duration? videoDuration = await widget
                                              .controller!
                                              .videoPlayerController!
                                              .position;
                                          if (videoDuration != null) {
                                            Duration rewindDuration =
                                                videoDuration -
                                                    const Duration(seconds: 10);
                                            widget.controller!.seekTo(
                                              rewindDuration < Duration.zero
                                                  ? Duration.zero
                                                  : rewindDuration,
                                            );
                                          }
                                          onHideControllers();
                                        },
                                        child: const Icon(
                                          Icons.fast_rewind,
                                          color: ColorResource.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// Play/Pause button
                                Expanded(
                                  child: SizedBox(
                                    height: double.infinity,
                                    child: Center(
                                      child: Transform.translate(
                                        offset: const Offset(0.0, -4.0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (widget.controller!
                                                  .isPlaying()!) {
                                                widget.controller!.pause();
                                              } else {
                                                widget.controller!.play();
                                              }
                                            });
                                            onHideControllers();
                                          },
                                          child: () {
                                            var defaultIcon = Icon(
                                              widget.controller?.isPlaying() ??
                                                      false
                                                  ? Icons.pause
                                                  : Icons.play_arrow_sharp,
                                              color: ColorResource.primaryColor,
                                              size: 50,
                                            );
                                            return defaultIcon;
                                          }(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// Fast forward button
                                Expanded(
                                  child: SizedBox(
                                    height: double.infinity,
                                    child: Material(
                                      color: Colors.transparent,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(300),
                                          bottomLeft: Radius.circular(300),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: InkWell(
                                        onTap: onHideControllers,
                                        splashColor: ColorResource.white
                                            .withOpacity(0.3),
                                        onDoubleTap: () async {
                                          Duration? videoDuration = await widget
                                              .controller!
                                              .videoPlayerController!
                                              .position;
                                          setState(() {
                                            if (widget.controller!
                                                .isPlaying()!) {
                                              Duration forwardDuration =
                                                  Duration(
                                                      seconds: (videoDuration!
                                                              .inSeconds +
                                                          10));
                                              if (forwardDuration >
                                                  widget
                                                      .controller!
                                                      .videoPlayerController!
                                                      .value
                                                      .duration!) {
                                                widget.controller!.seekTo(
                                                    const Duration(seconds: 0));
                                                widget.controller!.pause();
                                              } else {
                                                widget.controller!
                                                    .seekTo(forwardDuration);
                                              }
                                            }
                                          });
                                          onHideControllers();
                                        },
                                        child: const Icon(
                                          Icons.fast_forward,
                                          color: ColorResource.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// Rest of the controls (progress bar, fullscreen, etc.)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.fastOutSlowIn,
                        opacity: opacity,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: (widget.controller?.isFullScreen ?? false)
                                ? 25
                                : 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              /// Progress Bar
                              Expanded(
                                child: songProgress(
                                  context,
                                  controller: widget.controller!,
                                ),
                              ),

                              /// Playback Speed Button
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 3),
                                child: PopupMenuButton<double>(
                                  offset: const Offset(0, 40),
                                  onSelected: (speed) {
                                    setState(() {
                                      selectedSpeed = speed;
                                      widget.controller?.setSpeed(speed);
                                    });
                                  },
                                  itemBuilder: (context) => [
                                    buildPopupMenuItem(
                                      value: 0.5,
                                      text: "0.5x",
                                      icon: Icons.slow_motion_video,
                                      selectedSpeed: selectedSpeed,
                                    ),
                                    buildPopupMenuItem(
                                      value: 1.0,
                                      text: "1.0x (Normal)",
                                      icon: Icons.play_arrow,
                                      selectedSpeed: selectedSpeed,
                                    ),
                                    buildPopupMenuItem(
                                      value: 1.5,
                                      text: "1.5x",
                                      icon: Icons.fast_forward,
                                      selectedSpeed: selectedSpeed,
                                    ),
                                    buildPopupMenuItem(
                                      value: 2.0,
                                      text: "2.0x",
                                      icon: Icons.fast_forward,
                                      selectedSpeed: selectedSpeed,
                                    ),
                                  ],
                                  child: const Icon(
                                    Icons.speed,
                                    color: ColorResource.primaryColor,
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: () async {
                                  final isFullScreen =
                                      widget.controller?.isFullScreen ?? false;
                                  logPrint("isFullScreen: $isFullScreen");

                                  if (isFullScreen) {
                                    widget.controller?.exitFullScreen();
                                  } else {
                                    widget.controller?.enterFullScreen();
                                    await Future.delayed(
                                        const Duration(milliseconds: 400));
                                    await widget
                                        .controller?.videoPlayerController
                                        ?.play();
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 6, bottom: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    (widget.controller?.isFullScreen ?? false)
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: ColorResource.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  onHideControllers() {
    setState(() {
      opacity = opacity == 0.0 ? 1 : 0;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          opacity = 0.0;
        });
      }
    });
  }

  onChangeEnd(double value) async {
    // Duration msec = Duration(seconds: value.round());
    // widget.controller!.seekTo(msec);

    final oldState = progressVideoNotifier;
    progressVideoNotifier = ProgressBarState(
      current: Duration(seconds: value.ceil()),
      buffered: oldState.buffered,
      total: oldState.total,
    );
    await widget.controller!.seekTo(Duration(seconds: value.ceil()));
    await widget.controller!.play();
    isManualSlide = false;
    setState(() {});
    onHideControllers();
  }

  onChange(double value) async {
    await widget.controller!.pause();
    isManualSlide = true;
    final oldState = progressVideoNotifier;
    progressVideoNotifier = ProgressBarState(
      current: Duration(seconds: value.ceil()),
      buffered: oldState.buffered,
      total: oldState.total,
    );
    setState(() {});
  }

  Widget songProgress(BuildContext context,
      {required BetterPlayerController controller}) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 35,
          child: Text(
            formatDuration(progressVideoNotifier.current.inSeconds),
            style: StyleResource.instance.styleMedium(
                fontSize: DimensionResource.fontSizeExtraSmall,
                color: ColorResource.primaryColor),
          ),
        ),
        Expanded(
          child: audioSlider(
            context,
            value: progressVideoNotifier.current.inSeconds
                .toDouble(), // Ensure it's a double
            maxVal: widget.controller?.videoPlayerController?.value.duration
                    ?.inSeconds
                    .toDouble() ??
                30.0, // Convert to double
            onChanged: onChange,
            onChangedEnd: onChangeEnd,
          ),
        ),
        Text(
          formatDuration(
              controller.videoPlayerController!.value.duration?.inSeconds ?? 0),
          style: StyleResource.instance.styleMedium(
              fontSize: DimensionResource.fontSizeExtraSmall,
              color: ColorResource.primaryColor),
        ),
      ],
    );
  }

  SliderTheme audioSlider(
    BuildContext context, {
    required double value,
    required double maxVal,
    required Function(double) onChanged,
    required Function(double) onChangedEnd,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2.0,
        thumbColor: ColorResource.white,
        overlayColor:
            ColorResource.white.withOpacity(0.2), // Subtle overlay effect
        thumbShape: const RoundSliderThumbShape(
          disabledThumbRadius: 2.0,
          enabledThumbRadius: 8.0,
          pressedElevation: 10.0,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 8.0, // Increased for better UX
        ),
        activeTrackColor: ColorResource.primaryColor,
        inactiveTrackColor: Colors.grey, // Slightly lighter grey
      ),
      child: Slider(
        value: value.clamp(
            0.0, maxVal), // Ensures the value stays within the range
        max: maxVal,
        min: 0.0,
        onChanged:
            maxVal > 0 ? onChanged : null, // Disables slider if maxVal is 0
        onChangeEnd: maxVal > 0 ? onChangedEnd : null, // Ensures safe behavior
      ),
    );
  }

  // SliderTheme audioSlider(BuildContext context,
  //     {required double value,
  //     required double maxVal,
  //     required Function(double) onChanged,
  //     required Function(double) onChangedEnd}) {
  //   return SliderTheme(
  //       data: SliderTheme.of(context).copyWith(
  //         trackHeight: 2,
  //         thumbColor: ColorResource.white,
  //         overlayColor: ColorResource.white,
  //         thumbShape: const RoundSliderThumbShape(
  //             disabledThumbRadius: 2,
  //             enabledThumbRadius: 8,
  //             pressedElevation: 10),
  //         overlayShape: const RoundSliderOverlayShape(
  //           overlayRadius: 8,
  //         ),
  //         activeTrackColor: ColorResource.primaryColor,
  //         inactiveTrackColor: Colors.grey,
  //       ),
  //       child: Slider(
  //         value: value,
  //         max: maxVal,
  //         min: 0.0,
  //         onChanged: onChanged,
  //         onChangeEnd: onChangedEnd,
  //       ));
  // }

  @override
  void dispose() {
    widget.controller!.videoPlayerController!.removeListener(updateSeeker);
    super.dispose();
  }
}

String formatDuration(int seconds) {
  Duration d = Duration(seconds: seconds);
  if (d == const Duration(seconds: 0)) return "--:--";
  int minute = d.inMinutes;
  int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
  String format =
      "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
  return format;
}

PopupMenuItem<double> buildPopupMenuItem({
  required double value,
  required String text,
  required IconData icon,
  required double selectedSpeed,
}) {
  return PopupMenuItem<double>(
    value: value,
    height: 35, // Adjust height for compactness
    child: Row(
      children: [
        Icon(
          icon,
          color: selectedSpeed == value
              ? ColorResource.primaryColor
              : Colors.grey.shade700,
          size: 14, // Smaller icon size
        ),
        SizedBox(width: 6), // Reduced spacing between icon and text
        Text(
          text,
          style: TextStyle(
            fontSize: 12, // Smaller font size for compact appearance
            fontWeight: FontWeight.bold, // Bold text for emphasis
            color: selectedSpeed == value
                ? ColorResource.primaryColor
                : Colors.grey.shade900,
          ),
        ),
      ],
    ),
  );
}
