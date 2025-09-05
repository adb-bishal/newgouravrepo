import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/service/video_hls_player/lecle_yoyo_player.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:video_player/video_player.dart';

import '../../../page_manager.dart';

/// Widget use to display the bottom bar buttons and the time texts
class PlayerBottomBar extends StatelessWidget {
  /// Constructor
  const PlayerBottomBar({
    Key? key,
    required this.controller,
    required this.showBottomBar,
    this.onPlayButtonTap,
    this.videoDuration = "00:00:00",
    this.videoSeek = "00:00:00",
    this.videoStyle = const VideoStyle(),
    this.onFastForward,
    this.onRewind,
  }) : super(key: key);

  /// The controller of the playing video.
  final VideoPlayerController controller;

  /// If set to [true] the bottom bar will appear and if you want that user can not interact with the bottom bar you can set it to [false].
  /// Default value is [true].
  final bool showBottomBar;

  /// The text to display the current position progress.
  final String videoSeek;

  /// The text to display the video's duration.
  final String videoDuration;

  /// The callback function execute when user tapped the play button.
  final void Function()? onPlayButtonTap;

  /// The model to provide custom style for the video display widget.
  final VideoStyle videoStyle;

  /// The callback function execute when user tapped the rewind button.
  final ValueChanged<VideoPlayerValue>? onRewind;

  /// The callback function execute when user tapped the forward button.
  final ValueChanged<VideoPlayerValue>? onFastForward;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showBottomBar,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              //color: Colors.red,
              width: 35,
              child: Text(
                videoSeek,
                style: StyleResource.instance
                    .styleRegular(fontSize: 10, color: ColorResource.primaryColor),
              ),
            ),
            //const SizedBox(width: 10,),
            Expanded(
                child: VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              colors: videoStyle.progressIndicatorColors ??
                  const VideoProgressColors(
                    playedColor: Color.fromARGB(250, 0, 255, 112),
                  ),
              padding: videoStyle.progressIndicatorPadding ?? EdgeInsets.zero,
            )),
            const SizedBox(
              width: 10,
            ),
            Text(videoDuration,
                style: StyleResource.instance
                    .styleRegular(fontSize: 10, color: ColorResource.primaryColor))
          ],
        ),
      ),
    );
  }
}

class VideoProgressIndicator extends StatefulWidget {
  /// Construct an instance that displays the play/buffering status of the video
  /// controlled by [controller].
  ///
  /// Defaults will be used for everything except [controller] if they're not
  /// provided. [allowScrubbing] defaults to false, and [padding] will default
  /// to `top: 5.0`.
  const VideoProgressIndicator(
    this.controller, {
    super.key,
    this.colors = const VideoProgressColors(),
    required this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  });

  /// The [VideoPlayerController] that actually associates a video with this
  /// widget.
  final VideoPlayerController controller;

  /// The default colors used throughout the indicator.
  ///
  /// See [VideoProgressColors] for default values.
  final VideoProgressColors colors;

  /// When true, the widget will detect touch input and try to seek the video
  /// accordingly. The widget ignores such input when false.
  ///
  /// Defaults to false.
  final bool allowScrubbing;

  /// This allows for visual padding around the progress indicator that can
  /// still detect gestures via [allowScrubbing].
  ///
  /// Defaults to `top: 5.0`.
  final EdgeInsets padding;

  @override
  State<VideoProgressIndicator> createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<VideoProgressIndicator> {
  ProgressBarState progressVideoNotifier = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration(milliseconds: 0),
  );

  bool isManualSlide = false;

  listener() {
    if (!mounted) {
      logPrint("listener listener if not mounted");
      return;
    }
    if (controller.value.isInitialized) {
      // final int duration = controller.value.duration.inMilliseconds;
      // position.value = controller.value.position.inMilliseconds;
      if (!isManualSlide) {
        final oldState = progressVideoNotifier;
        progressVideoNotifier = ProgressBarState(
          current:
              Duration(milliseconds: controller.value.position.inMilliseconds),
          buffered: oldState.buffered,
          total:
              Duration(milliseconds: controller.value.duration.inMilliseconds),
        );
        setState(() {});
      }
    }
  }

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    //RxInt position = 0.obs;
    if (controller.value.isInitialized) {
      // int maxBuffering = 0;
      // for (final DurationRange range in controller.value.buffered) {
      //   final int end = range.end.inMilliseconds;
      //   if (end > maxBuffering) {
      //     maxBuffering = end;
      //   }
      // }
      progressIndicator = SizedBox(
        height: 20,
        child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbColor: ColorResource.white,
              overlayColor: ColorResource.white,
              thumbShape: const RoundSliderThumbShape(
                  disabledThumbRadius: 2,
                  enabledThumbRadius: 8,
                  pressedElevation: 10),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 8,
              ),
              activeTrackColor: ColorResource.primaryColor,
              inactiveTrackColor: Colors.grey,
            ),
            child: Slider(
              // activeColor: colors.playedColor,
              // inactiveColor: Colors.transparent,
              // thumbColor: Colors.white,
              min: 0.0,
              max: progressVideoNotifier.total.inMilliseconds.toDouble(),
              value: progressVideoNotifier.current.inMilliseconds.toDouble(),
              onChanged: (value) async {
                await controller.pause();
                isManualSlide = true;
                final oldState = progressVideoNotifier;
                progressVideoNotifier = ProgressBarState(
                  current: Duration(milliseconds: value.ceil()),
                  buffered: oldState.buffered,
                  total: oldState.total,
                );
                setState(() {});
                //controller.pause().then((c) => position.value = value.toInt());
              },
              onChangeEnd: (value) async {
                final oldState = progressVideoNotifier;
                progressVideoNotifier = ProgressBarState(
                  current: Duration(milliseconds: value.ceil()),
                  buffered: oldState.buffered,
                  total: oldState.total,
                );
                await controller.seekTo(Duration(milliseconds: value.ceil()));
                await controller.play();
                isManualSlide = false;
                //controller.seekTo(Duration(milliseconds: value.toInt())).then((value) async => await controller.play());
              },
            )),
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return VideoScrubber(
        controller: controller,
        child: paddedProgressIndicator,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
