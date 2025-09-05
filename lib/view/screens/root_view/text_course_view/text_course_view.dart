import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/text_course_detail_view/text_course_detail_view.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/text_course_controller/text_course_controller.dart';

import '../../subscription_view/example_blog.dart';

class TextCourseView extends GetView<TextCourseController> {
  const TextCourseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.secondaryColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity,45),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10,left: DimensionResource.marginSizeDefault,bottom: DimensionResource.marginSizeSmall),
          color: ColorResource.secondaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: const Icon(Icons.arrow_back_ios_new,color: ColorResource.white,size: 18,),
                onTap: (){
                  Get.back();
                },
              ),

            ],
          ),
        ),
      ),
      body: buildTextViewAreaView(context),
      bottomNavigationBar: Container(
        height: 45,
        padding: const EdgeInsets.only(bottom: DimensionResource.marginSizeDefault),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //upDownButton(onTap: controller.onPageUp),
            Container(
              margin: const EdgeInsets.only(left: DimensionResource.marginSizeDefault+10),
              height: 28,
              width: 28,
              decoration: const BoxDecoration(
                color: ColorResource.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.keyboard_arrow_up,color: ColorResource.secondaryColor,),
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               upDownButton(onTap: controller.onUpButton),
               const SizedBox(
                 width: DimensionResource.marginSizeDefault,
               ),
               Obx(
                       () {
                     return Text(NumberFormat('00').format(controller.currentPage.value),style: StyleResource.instance.styleSemiBold(fontSize: DimensionResource.fontSizeLarge+2,color: ColorResource.white),);
                   }
               ),
               Obx(
                       () {
                     return Text(" / ${NumberFormat('00').format(controller.totalChapters.value)}",style: StyleResource.instance.styleRegular(fontSize: DimensionResource.fontSizeSmall,color: ColorResource.white),);
                   }
               ),
               const SizedBox(
                 width: DimensionResource.marginSizeDefault,
               ),
               upDownButton(onTap: controller.onDownButton,isUp: false),
             ],
           ),
            Obx(
                    () {
                  return InkWell(
                    splashColor: ColorResource.secondaryColor,
                    onTap: controller.currentChapters.value != 0 ?controller.scrollTop:null,
                    child: Container(
                      margin: const EdgeInsets.only(right: DimensionResource.marginSizeDefault+10),
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: controller.currentChapters.value != 0 ?ColorResource.white:ColorResource.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.keyboard_arrow_up,color:  controller.currentChapters.value != 0 ? ColorResource.primaryColor:ColorResource.secondaryColor,),
                    ),
                  );
                }
            ),

          ],
        ),
      ),
    );
  }

  Widget buildTextViewAreaView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            logPrint("message down");
           EasyDebounce.debounce(sensitivity.toString(),const  Duration(milliseconds: 50), () { controller.onUpButton();});
            // Down Swipe
          } else if(details.delta.dy < -sensitivity){
            // Up Swipe
            EasyDebounce.debounce(sensitivity.toString(),const  Duration(milliseconds: 50), () { controller.onDownButton();});
          }
        },
      child: Obx(
         () {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.scrollController.value,
              padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault,vertical: DimensionResource.marginSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeExtraSmall,vertical: DimensionResource.marginSizeExtraSmall-2),
                    decoration: BoxDecoration(
                        color: ColorResource.yellowColor,
                        borderRadius: BorderRadius.circular(3)
                    ),
                    child: Text(controller.categoryType.value,style: StyleResource.instance.styleMedium(fontSize: DimensionResource.fontSizeExtraSmall,),),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  ),
                  headlineText(controller.data.value.topicTitle??"",fontColor: ColorResource.white),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  ),
                  Obx(() {
                    double fontSize = screenWidth < 500 ? 12.0 : 18.0;
                    return HtmlCommonWidget( fontSize:fontSize ,htmlData: controller.data.value.courseContent??"",isDark: true,);
                  }),
                   Obx(
                    () {
                       return SizedBox(
                        height: DimensionResource.marginSizeDefault+controller.extendedViewPortValue.value,
                  );
                     }
                   ),
                ],
              ),
            );
        }
      ),
    );
  }

  Widget upDownButton({required Function() onTap, bool isUp = true}) {
    return InkWell(
      splashColor: Colors.transparent,
            onTap: onTap,
            child: Container(
              height: 28,
              width: 28,
              decoration: const BoxDecoration(
                color: ColorResource.primaryColor,
                shape: BoxShape.circle,
              ),
              child:  Icon(isUp ? Icons.keyboard_arrow_up_outlined:Icons.keyboard_arrow_down_outlined,color: ColorResource.white,),
            ),
          );
  }
}
