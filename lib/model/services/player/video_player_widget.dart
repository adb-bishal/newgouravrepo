import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/audio_course_detail_view/audio_course_detail_view.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
// import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as scalp;

// import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart'
//     as scalp;
import '../../../service/page_manager.dart';
import '../../../view/screens/root_view/scalps_view/content_screen.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String url;
  final bool isScalp;
  final bool autoPlay;
  final Function(bool)? isPlaying;

  final Function(int, int) eventCallBack;
  const YouTubePlayerWidget(
      {Key? key,
      required this.url,
      this.isScalp = false,
      this.autoPlay = true,
      this.isPlaying,
      required this.eventCallBack})
      : super(key: key);

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool isManualSlide = false;
  // scalp.YoutubePlayerController? controller ;
  ProgressBarState progressVideoNotifier = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );

  String convertUrlToID(String url) {
    try {
      return YoutubePlayer.convertUrlToId(url) ?? "";
    } catch (e) {
      return "Unable to convert";
    }
  }

  late scalp.YoutubePlayerController controller =
      scalp.YoutubePlayerController.fromVideoId(
    videoId: convertUrlToID(widget.url),
    autoPlay: widget.autoPlay,
    params: scalp.YoutubePlayerParams(
        strictRelatedVideos: false,
        showFullscreenButton: !widget.isScalp,
        enableCaption: false,
        loop: true,
        pointerEvents: scalp.PointerEvents.initial,
        showControls: !widget.isScalp,
        showVideoAnnotations: false),
  );

  // enableWakeLock() async {
  //   if (!await Wakelock.enabled) {
  //     await Wakelock.enable();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    if (!widget.isScalp) {
      // enableWakeLock();
    }
    if (!widget.isScalp) {
      _controller = YoutubePlayerController(
        initialVideoId: convertUrlToID(widget.url),
        flags: YoutubePlayerFlags(
          mute: false,
          hideThumbnail: false,
          autoPlay: widget.autoPlay,
          disableDragSeek: true,
          loop: false,
          isLive: false,
          forceHD: true,
          enableCaption: false,
        ),
      )..addListener(listener);
    } else {
      controller = scalp.YoutubePlayerController.fromVideoId(
        videoId: convertUrlToID(widget.url),
        autoPlay: widget.autoPlay,
        params: scalp.YoutubePlayerParams(
            strictRelatedVideos: true,
            showFullscreenButton: !widget.isScalp,
            enableCaption: false,
            loop: true,
            pointerEvents: scalp.PointerEvents.initial,
            showControls: !widget.isScalp,
            showVideoAnnotations: false),
      );
      // controller.loadVideoById(
      //     videoId: convertUrlToID(widget.url), startSeconds: 1);
      controller.videoStateStream.listen((event) async {
        widget.eventCallBack(event.position.inSeconds,
            int.parse((await controller.duration).round().toString()));
      });
      // controller?.listen((event)async{
      //   if(widget.isPlaying != null){
      //     logPrint("playing state ${event.playerState} ${(event.playerState == PlayerState.playing)}");
      //     widget.isPlaying!((event.playerState == PlayerState.playing));
      //   }
      //   if(event.playerState == PlayerState.ended){
      //     controller?.seekTo(Duration.zero);
      //     controller?.play();
      //   }
      //   widget.eventCallBack(event.position.inSeconds,int.parse((controller?.metadata.duration.inSeconds)?.round().toString()??""));
      // });
    }
  }

  void listener() {
    if (_isPlayerReady && mounted) {
      widget.eventCallBack(_controller.value.position.inSeconds,
          _controller.metadata.duration.inSeconds);
      if (!isManualSlide) {
        final oldState = progressVideoNotifier;
        progressVideoNotifier = ProgressBarState(
          current: _controller.value.position,
          buffered: oldState.buffered,
          total: _controller.metadata.duration,
        );
        setState(() {});
      }
    }
  }

  onChangeEnd(double value) async {
    // Duration msec = Duration(seconds: value.round());
    // widget.controller!.seekTo(msec);
    //logPrint("onChangeEnd 333 $value");
    final oldState = progressVideoNotifier;
    progressVideoNotifier = ProgressBarState(
      current: Duration(seconds: value.ceil()),
      buffered: oldState.buffered,
      total: oldState.total,
    );
    _controller.seekTo(Duration(seconds: value.ceil()));
    _controller.play();
    isManualSlide = false;
    setState(() {});
  }

  onChange(double value) async {
    //logPrint("value 333 $value");
    _controller.pause();
    isManualSlide = true;
    final oldState = progressVideoNotifier;
    progressVideoNotifier = ProgressBarState(
      current: Duration(seconds: value.ceil()),
      buffered: oldState.buffered,
      total: oldState.total,
    );
    setState(() {});
  }

  @override
  void deactivate() async {
    if (!widget.isScalp) {
      _controller.pause();
    } else {
      await controller.pauseVideo();
      // controller.videoData.pa
    }
    //disableWakeLock();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.deactivate();
  }

  @override
  Future<void> dispose() async {
    //_controller.dispose();
    if (!widget.isScalp) {
      _controller.pause();
    } else {
      await controller.pauseVideo();
      controller.stopVideo();
    }
    //disableWakeLock();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
    // await controller.pauseVideo();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(widget.url.toString()),
        onVisibilityChanged: (visibilityInfo) async {
          double visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (widget.autoPlay) {
            if (visiblePercentage > 70) {
              if (widget.isScalp) {
                await controller.playVideo();
              } else {
                _isPlayerReady ? _controller.play() : null;
              }
            } else {
              if (widget.isScalp) {
                await controller.pauseVideo();
              } else {
                _controller.pause();
              }
            }
          }
        },
        child: widget.isScalp
            ? scalp.YoutubePlayerScaffold(
                enableFullScreenOnVerticalDrag: !widget.isScalp,
                controller: controller,
                backgroundColor: Colors.black,
                aspectRatio: 1.8,
                builder: (context, player) {
                  return StreamBuilder(
                    stream: controller.stream,
                    builder: (context, snap) {
                      if (snap.data?.playerState == scalp.PlayerState.ended) {
                        controller.seekTo(seconds: 0);
                        controller.playVideo();
                      }
                      return Stack(
                        children: [
                          Positioned.fill(child: player),
                          if (snap.data?.playerState !=
                                  scalp.PlayerState.playing &&
                              snap.data?.playerState !=
                                  scalp.PlayerState.paused &&
                              snap.data?.playerState != scalp.PlayerState.ended)
                            Container(
                              color: ColorResource.secondaryColor,
                              child: const CommonCircularIndicator(
                                color: ColorResource.lightGrey,
                              ),
                            ),
                          if (snap.data?.playerState ==
                              scalp.PlayerState.unStarted)
                            Container(
                              color: ColorResource.secondaryColor,
                              child: const CommonCircularIndicator(
                                color: ColorResource.lightGrey,
                              ),
                            ),
                          Visibility(
                            visible: snap.data?.playerState ==
                                scalp.PlayerState.paused,
                            child: InkWell(
                              onTap: () => controller.playVideo(),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: cachedNetworkImage(''
                                      // controller.getThumbnail(
                                      //     videoId: convertUrlToID(widget.url)),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          if (snap.data?.playerState ==
                              scalp.PlayerState.paused)
                            const Center(
                              child: ShowPlayIcon(),
                            ),
                        ],
                      );
                      // if (snap.data?.playerState == PlayerState.playing) {
                      //   return player;
                      // } else {
                      //   return const CommonCircularIndicator();
                      // }
                    },
                  );
                  // return player;
                },
              )
            : YoutubePlayerBuilder(
                player: YoutubePlayer(
                  //width: MediaQuery.of(context).size.width,
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: ColorResource.mateGreenColor,
                  progressColors: const ProgressBarColors(
                    backgroundColor: ColorResource.borderColor,
                    playedColor: ColorResource.primaryColor,
                    bufferedColor: ColorResource.white,
                    handleColor: ColorResource.white,
                  ),
                  bottomActions: [
                    const SizedBox(width: 10.0),
                    SizedBox(width: 37.0, child: CurrentPosition()),
                    //const SizedBox(width: 8.0),
                    Expanded(
                      child: audioSlider(context,
                          value: double.parse(progressVideoNotifier
                              .current.inSeconds
                              .toString()),
                          max: double.parse(
                              progressVideoNotifier.total.inSeconds.toString()),
                          min: 0.0,
                          onChanged: onChange,
                          onChangedEnd: onChangeEnd),
                    ),
                    SizedBox(width: 37.0, child: RemainingDuration()),
                    //const PlaybackSpeedButton(),
                    FullScreenButton(
                      color: const Color(0xff8276F4),
                    ),
                  ],
                  onReady: () {
                    _isPlayerReady = true;
                  },
                  onEnded: (data) {
                    _controller.seekTo(Duration.zero);
                    _controller.pause();
                  },
                ),
                builder: (context, player) => const SizedBox(),
              ));
  }
}
