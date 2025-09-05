import 'package:flutter/material.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/style_resource.dart';

class ErrorPage extends StatelessWidget {
  final String? text;
  final String? image;

  const ErrorPage({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: ColorResource.white),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image != null ? Image.asset(image!,height: 200,width: 200,) : Container(),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                text ?? '',
                textAlign: TextAlign.center,
                style: StyleResource.instance.styleRegular(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
