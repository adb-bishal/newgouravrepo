import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/chat_controller/chat_controller.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../base_view/base_view_screen.dart';

class ChatViewScreen extends StatelessWidget {
  const ChatViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthView(
      leadingIcon: (BuildContext context, ChatController controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(left: DimensionResource.marginSizeDefault),
                  child: const Icon(Icons.arrow_back_ios,color: ColorResource.white,)),
            ),
            const SizedBox(
              height: DimensionResource.marginSizeSmall-3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
              child: Row(
                children: [
                  imageCircleContainer(
                    radius: 15,
                    showDot: true
                  ),
                  const SizedBox(
                    width: DimensionResource.marginSizeSmall-2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stockpathshala",
                        style: StyleResource.instance.styleSemiBold(
                            color: ColorResource.white,
                            fontSize: DimensionResource
                                .fontSizeDefault)),
                      Text(
                        "Online",
                        style: StyleResource.instance.styleRegular(
                            color: ColorResource.borderTextField2,
                            fontSize:
                            DimensionResource.fontSizeExtraSmall),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
      viewControl: ChatController(),
      onPageBuilder: (BuildContext context, ChatController controller) =>
          _buildLoginView(context, controller),
      backgroundImage: ImageResource.instance.chatBg,
      imageHeight: 120,
      imageBackGroundColor: ColorResource.secondaryColor,
    );
  }

  Widget _buildLoginView(BuildContext context, ChatController controller) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
          shrinkWrap: true,
          itemCount: 7,
          reverse: true,
          itemBuilder: (context,index){
            return const MessageContainer(isCurrentUser: false);
          }),
      bottomNavigationBar: Container(
        height: 45,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ColorResource.borderColor,
              width: 0.6
            )
          )
        ),
        child: Row(
          children: [
            Expanded(child: TextFormField(
              style: StyleResource.instance.styleRegular(fontSize: DimensionResource.fontSizeSmall,color: ColorResource.lightTextColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: StringResource.typeAMessage,
                hintStyle: StyleResource.instance.styleRegular(fontSize: DimensionResource.fontSizeSmall,color: ColorResource.lightTextColor),
                contentPadding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault)
              ),
            )),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
                onPressed: (){},
                icon: Image.asset(ImageResource.instance.sendMessage))
          ],
        ),
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    super.key,
    required this.isCurrentUser,
     this.isQuestion = true,
  });
  final bool isCurrentUser ;
  final bool isQuestion ;
  final double borderRadius = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: DimensionResource.marginSizeDefault),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          Visibility(
            visible: !isCurrentUser,
            child: Padding(
              padding: const EdgeInsets.only(bottom: DimensionResource.marginSizeLarge),
              child: imageCircleContainer(radius: 14),
            ),
          ),
          Visibility(
            visible: !isCurrentUser,
            child: const SizedBox(
              width: DimensionResource.marginSizeExtraSmall,
            ),
          ),
          Column(
            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width*0.75
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      topLeft: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(isCurrentUser ? 0:borderRadius),
                      bottomLeft: Radius.circular(isCurrentUser ?borderRadius:0),
                    ),
                    color: isCurrentUser ? ColorResource.primaryColor: ColorResource.chatBoxBackGroundColor
                ),
                child: isQuestion ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    questionBox(isFirst: true,isLast: false,onTap: (){}),
                    ...List.generate(4, (index) {
                      return questionBox(isFirst: false,isLast: index ==3,boxColor: ColorResource.white,textColor: ColorResource.primaryColor,onTap: (){});
                    })
                  ],
                ) : textContainerBox(),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: DimensionResource.marginSizeExtraSmall),
                  child: Text('11:06 AM',style: StyleResource.instance.styleRegular(fontSize: DimensionResource.fontSizeExtraSmall),))
            ],
          ),
          Visibility(
            visible: isCurrentUser,
            child: const SizedBox(
              width: DimensionResource.marginSizeExtraSmall,
            ),
          ),
          Visibility(
            visible: isCurrentUser,
            child: Padding(
              padding: const EdgeInsets.only(bottom: DimensionResource.marginSizeLarge),
              child: imageCircleContainer(radius: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget questionBox({required bool isFirst, required bool isLast,Color? boxColor,Color textColor = ColorResource.secondaryColor,required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
                      decoration: BoxDecoration(
                        color: boxColor??ColorResource.borderColor.withOpacity(0.4),
                        borderRadius: isFirst ? BorderRadius.only(
                          topRight: Radius.circular(isFirst ? borderRadius:0),
                          topLeft: Radius.circular(isFirst ? borderRadius:0),
                          bottomRight: Radius.circular(isLast ?borderRadius:0),
                          bottomLeft: Radius.circular(isLast ?borderRadius:0),
                        ):null,
                        border: isFirst ? null: const Border(
                          // top: BorderSide(
                          //     color: ColorResource.borderColor,
                          //     width: isLast ? 0: 0.6
                          // ),
                         bottom: BorderSide(
                             color: ColorResource.borderColor,
                             width: 0.6
                         ),
                          left: BorderSide(
                              color: ColorResource.borderColor,
                              width: 0.6
                          ),
                          right: BorderSide(
                              color: ColorResource.borderColor,
                              width: 0.6
                          ),
                        )
                      ),
                      padding: const EdgeInsets.all(DimensionResource.marginSizeSmall),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Text("kindly selects the question which best suits to your queries",style: StyleResource.instance.styleRegular(fontSize: DimensionResource.fontSizeExtraSmall,color: textColor).copyWith(fontWeight: isFirst ? FontWeight.w400:FontWeight.w500),textAlign: isFirst ? TextAlign.start:TextAlign.center,),
                    ),
    );
  }

  Widget textContainerBox() {
    return Padding(
      padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
      child:  Text("Hi, I am Ajit. How can I assist you.",style: StyleResource.instance.styleMedium(fontSize: DimensionResource.fontSizeSmall,color:isCurrentUser ? ColorResource.white:ColorResource.secondaryColor),),
    );
  }
}

Widget imageCircleContainer({required double radius, String url = ImageResource.defaultUser,bool showDot = false}) {
  return Stack(
    children: [
      CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(url),
        onBackgroundImageError: (e,s){

        },
        // child:  ClipRRect(
        //   clipBehavior: Clip.antiAliasWithSaveLayer,
        //     borderRadius: BorderRadius.circular(0),
        //     child: cachedNetworkImage(url,fit: BoxFit.fill)),
      ),
      Visibility(
        visible: showDot,
        child: const Positioned(
            bottom: 0,
            right: 0,
            child: Icon(Icons.circle,color: ColorResource.greenColor,size: 11,)
        ),
      )
    ],
  );
}
