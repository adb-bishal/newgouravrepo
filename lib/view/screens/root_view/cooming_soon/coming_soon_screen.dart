import 'package:flutter/material.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/style_resource.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.backGroundColor,
      body: Center(
        child: Text(
          "Coming Soon",
          style: StyleResource.instance.styleMedium(),
        ),
      ),
    );
  }
}
