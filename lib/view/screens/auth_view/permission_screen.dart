import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view_model/controllers/auth_controllers/permission_controller.dart';
import '../../widgets/button_view/common_button.dart';
import '../base_view/base_view_screen.dart';
class PermissionScreen extends StatelessWidget {
  const PermissionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView(
        onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
          titleColor: ColorResource.secondaryColor,
          titleText: "",
        ),
        onActionBuilder: (context, controller) => [],
        onBackClicked: (context, controller) {
          Get.back();
        },
        viewControl: PermissionController(), onPageBuilder: (BuildContext context ,PermissionController controller)=>_buildPermissionView(context,controller));
  }
}
Widget _buildPermissionView(BuildContext context,PermissionController controller){
  return Padding(
    padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
    child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height*.15,),
        Image.asset(ImageResource.instance.appLogo,height: 55,),
        SizedBox(height: MediaQuery.of(context).size.height*.05,),
        Center(child: Text("To have great experience with ${StringResource.instance.appName},\nplease allow us the following\npermission",style: StyleResource.instance.styleMedium(),textAlign: TextAlign.center,)),
        SizedBox(height: MediaQuery.of(context).size.height*.08,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: ColorResource.lightBorderColor)
          ),
          child:Column(
            children: [
              _buildPermissionRow(ImageResource.instance.camaraPermissionIcon,"Camera","To allow you to capture photos from your camera,\nIn order to create receipts and expense reports, this is necessary."),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height*.08,),
        CommonButton(text: "Allow Permission",color: ColorResource.primaryColor,onPressed:controller.onPermissionAllow,loading: false,),
        const SizedBox(height: 20,),
        CommonButton(text: "Ignore, Take Me to Home",color: ColorResource.white,onPressed:controller.ignoreTap,textColor: ColorResource.black,loading: false,)

      ],
    ),
  );
}
Widget _buildPermissionRow(String image,String title,String description){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
    child: Column(
      children: [
        Image.asset(image,height:50,width: 50,),
        const SizedBox(height: 10,),
        Text(title,style: StyleResource.instance.styleMedium(),),
        const SizedBox(height: 5,),
        Text(description,style:StyleResource.instance.styleLight(),textAlign: TextAlign.center,),

      ],
    ),
  );
}