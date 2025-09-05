import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/models/scalp_model/scalp_data_model.dart';
import '../../../../../model/services/auth_service.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/image_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/scalp_controller/scalp_controller.dart';
import '../../../../widgets/button_view/common_button.dart';
import '../../../../widgets/view_helpers/progress_dialog.dart';
import '../home_view_screen.dart';

class ScalpsWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;
  const ScalpsWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(() {
          Get.toNamed(Routes.scalpScreen);
          // Get.find<RootViewController>().selectedTab.value = 3;
          // Get.find<ScalpController>().onRedirectView(List<Datum>.from(
          //     homeDataModelDatum.data?.map((e) => Datum.fromJson(e.toJson())) ??
          //         []));
        }, homeDataModelDatum.title ?? StringResource.scalps,
            showIcon: true, enableTopPadding: false),
        SizedBox(
          height: 220,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            child: Row(
              children:
                  List.generate(homeDataModelDatum.data?.length ?? 0, (index) {
                DatumDatum data = homeDataModelDatum.data!.elementAt(index);
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Get.find<RootViewController>().selectedTab.value = 3;
                    Get.find<ScalpController>().fromScalp.value = true;
                    Get.find<ScalpController>()
                        .onSingleRedirect(Datum.fromJson(data.toJson()));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SingleScalpView(
                    //             dataList: [Datum.fromJson(data.toJson())])));
                  },
                  child: AspectRatio(
                    aspectRatio: 1.25 / 2,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: EdgeInsets.only(
                          right: index == (homeDataModelDatum.data!.length - 1)
                              ? 0
                              : DimensionResource.marginSizeSmall),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: cachedNetworkImage(data.thumbnail ?? "",
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: ColorResource.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    DimensionResource.marginSizeExtraSmall + 2,
                                vertical: DimensionResource.marginSizeSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Expanded(
                                //     child: Column(
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   children: [
                                //     scalpsActionBuilder(
                                //         image: ImageResource.instance.likeIcon,
                                //         text:
                                //             "${data.totalLikes ?? 0} ${StringResource.likes}",
                                //         secondImage: data.isLiked?.value == 1
                                //             ? ImageResource
                                //                 .instance.filledLikeIcon
                                //             : null,
                                //         onTap: () {}),
                                //     scalpsActionBuilder(
                                //         image:
                                //             ImageResource.instance.commentIcon,
                                //         text:
                                //             "${data.totalComment ?? 0} ${StringResource.comments}",
                                //         iconColor: ColorResource.primaryColor,
                                //         onTap: () {}),
                                //     scalpsActionBuilder(
                                //         image: ImageResource.instance.shareIcon,
                                //         text:
                                //             "${data.totalShares ?? 0} ${StringResource.share}",
                                //         onTap: () {}),
                                //   ],
                                // )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ContainerButton(
                                      text:
                                          data.category?.title?.toUpperCase() ??
                                              "",
                                      onPressed: () {},
                                      color: ColorResource.yellowColor,
                                      textStyle: StyleResource.instance
                                          .styleMedium(
                                              fontSize: DimensionResource
                                                      .fontSizeExtraSmall -
                                                  3)
                                          .copyWith(letterSpacing: .3),
                                      radius: 3,
                                      padding: const EdgeInsets.all(3),
                                    ),
                                    const SizedBox(
                                      height: DimensionResource
                                          .marginSizeExtraSmall,
                                    ),
                                    Text(
                                      data.title ?? "",
                                      style: StyleResource.instance
                                          .styleSemiBold(
                                              fontSize: DimensionResource
                                                  .fontSizeExtraSmall,
                                              color: ColorResource.white),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall + 3,
        )
      ],
    );
  }
}

Column scalpsActionBuilder(
    {required String image,
    required String text,
    required Function() onTap,
    Color? iconColor,
    String? secondImage,
    double iconSize = 10,
    double allPadding = 5}) {
  logPrint(secondImage);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      IconButtonLayout(
        image: image,
        iconSize: iconSize,
        iconColor: iconColor,
        secondImage: secondImage,
        onTap: onTap,
        allPadding: allPadding,
      ),
      const SizedBox(
        height: DimensionResource.marginSizeExtraSmall - 2,
      ),
      Text(
        text,
        style: StyleResource.instance.styleMedium(
            fontSize: DimensionResource.fontSizeExtraSmall,
            color: ColorResource.white),
      ),
      const SizedBox(
        height: DimensionResource.marginSizeExtraSmall + 2,
      ),
    ],
  );
}

class IconButtonLayout extends StatelessWidget {
  final String image;
  final String? secondImage;
  final Color? iconColor;
  final Color? bgColor;
  final Color? shadowColor;
  final double iconSize;
  final double allPadding;
  final Function() onTap;
  const IconButtonLayout(
      {Key? key,
      required this.image,
      this.iconColor,
      this.secondImage,
      this.bgColor = ColorResource.white,
      this.shadowColor = ColorResource.black,
      this.iconSize = 10,
      this.allPadding = 5,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: image == ImageResource.instance.shareIcon
          ? onTap
          : () {
              if (!Get.find<AuthService>().isGuestUser.value) {
                onTap();
              } else {
                ProgressDialog().showFlipDialog(isForPro: false);
              }
            },
      splashColor: Colors.transparent,
      child: Material(
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: bgColor,
        child: CircleAvatar(
          radius: iconSize,
          backgroundColor: bgColor,
          child: Padding(
              padding: EdgeInsets.all(allPadding),
              child: Image.asset(
                secondImage ?? image,
                color: iconColor,
              )),
        ),
      ),
    );
  }
}

class LoaderButtonLayout extends StatelessWidget {
  final Color? iconColor;
  final Color? bgColor;
  final Color? shadowColor;
  final double iconSize;
  final double allPadding;
  final Function()? onTap;
  const LoaderButtonLayout(
      {Key? key,
      this.iconColor,
      this.bgColor = ColorResource.white,
      this.shadowColor = ColorResource.black,
      this.iconSize = 10,
      this.allPadding = 5,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          child: Material(
              shadowColor: shadowColor,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: bgColor,
              child: CircleAvatar(
                radius: iconSize,
                backgroundColor: bgColor,
                child: Padding(
                  padding: EdgeInsets.all(allPadding),
                  child: SizedBox(
                      height: iconSize - allPadding,
                      width: iconSize - allPadding,
                      child: CircularProgressIndicator(
                        color: iconColor,
                        strokeWidth: 2,
                      )),
                ),
              ))),
    );
  }
}
