import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/service/video_hls_player/lecle_yoyo_player.dart';
import 'package:stockpathshala_beta/service/video_hls_player/src/model/m3u8.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/style_resource.dart';

class VideoQualityPicker extends StatelessWidget {
  final List<M3U8Data> videoData;
  final bool showPicker;
  final double? positionRight;
  final double? positionTop;
  final double? positionLeft;
  final double? positionBottom;
  final VideoStyle videoStyle;
  final void Function(M3U8Data data)? onQualitySelected;

  const VideoQualityPicker({
    Key? key,
    required this.videoData,
    this.videoStyle = const VideoStyle(),
    this.showPicker = false,
    this.positionRight,
    this.positionTop,
    this.onQualitySelected,
    this.positionLeft,
    this.positionBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // logPrint("videoData ${videoData.length}");
    return Visibility(
      visible: showPicker,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: videoStyle.qualityOptionsMargin ??  EdgeInsets.only(
            right: 15.0,
            top: MediaQuery.of(context).padding.top+45,),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: videoStyle.qualityOptionsRadius ?? BorderRadius.circular(4.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                  videoData.length,
                  (index) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: index == 0
                              ? BorderRadius.only(
                                  topLeft: videoStyle.qualityOptionsRadius?.topLeft ??
                                      const Radius.circular(4.0),
                                  topRight: videoStyle
                                          .qualityOptionsRadius?.topRight ??
                                      const Radius.circular(4.0),
                                )
                              : index == videoData.length - 1
                                  ? BorderRadius.only(
                                      bottomLeft: videoStyle
                                              .qualityOptionsRadius
                                              ?.bottomLeft ??
                                          const Radius.circular(4.0),
                                      bottomRight: videoStyle
                                              .qualityOptionsRadius
                                              ?.bottomRight ??
                                          const Radius.circular(4.0),
                                    )
                                  : BorderRadius.zero,
                          onTap: () {
                            onQualitySelected?.call(videoData[index]);
                          },
                          child: Container(
                            padding: videoStyle.qualityOptionsPadding ?? const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                            alignment: Alignment.center,
                            width: videoStyle.qualityOptionWidth,
                            child: Text(
                              ((videoData[index].dataQuality?.split("x").toList().length??0) < 2) ? videoData[index].dataQuality??"" : "${videoData[index].dataQuality?.split("x")[1]??""}p",
                              style: StyleResource.instance.styleRegular(fontSize: 10,color: ColorResource.white),
                            ),
                          ),
                        ),
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
