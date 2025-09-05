import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pulsator/pulsator.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

class LiveDot extends StatefulWidget {
  LiveDot(
      {super.key,
        required this.left,
        required this.top,
        required this.height,
        required this.width});
  double? left;
  double? top;
  double? width;
  double? height;

  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> {
  Timer? timer;
  bool isShow = false;

  void timerForLive() {
    if (timer != null) {
      timer?.cancel();
    }

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (isShow) {
        setState(() {
          isShow = false;
        });
      } else {
        setState(() {
          isShow = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerForLive();
  }

  @override
  Widget build(BuildContext context) {
    return

      // Positioned(
      //     left: widget.left,
      //     top: widget.top,
      //     child:

      SizedBox(
        width: widget.width,
        height: widget.height,
        child: Pulsator(
          style: const PulseStyle(color: Colors.red),
          count: 4,
          duration: const Duration(seconds: 4),
          repeat: 0,
          startFromScratch: false,
          autoStart: true,
          fit: PulseFit.contain,
          child: CircleAvatar(
              backgroundColor: ColorResource.redColor,
              radius: 9,
              child: CircleAvatar(
                backgroundColor: ColorResource.white,
                radius: 7.75,
                child: CircleAvatar(
                    backgroundColor: ColorResource.redColor,
                    radius: 6,
                    child: CircleAvatar(
                      backgroundColor: ColorResource.white,
                      radius: 4.75,
                      child: Visibility(
                        visible: isShow,
                        child: const CircleAvatar(
                          backgroundColor: ColorResource.redColor,
                          radius: 3,
                        ),
                      ),
                    )),
              )),
        ),
      )
    // )
        ;
  }
}
