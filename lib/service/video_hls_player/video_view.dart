import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/service/video_hls_player/lecle_yoyo_player.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:video_player/video_player.dart';

class HlsVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final String? thumbnail;
  final bool showControllers;
  final bool m3u8Show;
  final double aspectRatio;
  final void Function(VideoPlayerController cont) onVideoInitCompleted;
  final void Function(int controller, int duration) onVideoPosition;
  final void Function(bool isPlaying) onPlayButtonTap;

  const HlsVideoPlayer(
      {super.key,
      required this.videoUrl,
      this.showControllers = true,
      this.thumbnail,
      required this.m3u8Show,
      required this.aspectRatio,
      required this.onVideoInitCompleted,
      required this.onVideoPosition,
      required this.onPlayButtonTap});

  @override
  Widget build(BuildContext context) {
    logPrint("i am in HlsVideoPlayer");

    return YoYoPlayer(
      url: videoUrl,
      allowCacheFile: true,
      aspectRatio: aspectRatio,
      hideControls: !showControllers,
      onPlayButtonTap: onPlayButtonTap,
      onVideoPosition: onVideoPosition,
      onVideoInitCompleted: onVideoInitCompleted,
      onCacheFileCompleted: (files) {
        logPrint('Cached file length ::: ${files?.length}');
        if (files != null && files.isNotEmpty) {
          for (var file in files) {
            logPrint('File path ::: ${file.path}');
          }
        }
      },
      onCacheFileFailed: (error) {
        logPrint('Cache file error ::: $error');
      },
      videoStyle: const VideoStyle(
        qualityStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        progressIndicatorColors: VideoProgressColors(
            bufferedColor: Colors.white,
            playedColor: ColorResource.primaryColor,
            backgroundColor: Colors.white54),
        qualityOptionsBgColor: Colors.black45,
        forwardAndBackwardBtSize: 30.0,
        playButtonIconSize: 40.0,
        videoQualityPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
        // showLiveDirectButton: true,
        // enableSystemOrientationsOverride: false,
      ),
      videoLoadingStyle: const VideoLoadingStyle(
        loading: Center(
          child: SizedBox(
              height: 70,
              width: 70,
              child: CircularProgressIndicator(
                color: ColorResource.white,
                strokeWidth: 1,
              )),
        ),
      ),
    );
  }
}
