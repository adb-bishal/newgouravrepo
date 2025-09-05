import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageResource.instance.noInternetIcon),
      ),
    );
  }
}
