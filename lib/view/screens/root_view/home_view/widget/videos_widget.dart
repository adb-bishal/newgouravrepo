import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/scalps_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/image_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../widgets/image_provider/image_provider.dart';
import '../home_view_screen.dart';

class VideosWidget extends StatelessWidget {
  final Function() onTap;
  final HomeDataModelDatum? homeDataModelDatum;
  final List<CommonDatum>? data;
  final Function()? onWishlist;
  const VideosWidget(
      {Key? key,
      required this.onTap,
      this.data,
      this.onWishlist,
      this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(
          onTap,
          homeDataModelDatum?.title ?? StringResource.videos,
          showIcon: true,
          enableTopPadding: false,
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: DimensionResource.marginSizeDefault),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                homeDataModelDatum?.data?.length ?? data?.length ?? 0, (index) {
              CommonDatum dataa;
              if (homeDataModelDatum != null) {
                dataa = CommonDatum.fromJson(
                    homeDataModelDatum?.data?.elementAt(index).toJson() ?? {});
                for (var dataaa in homeDataModelDatum?.data ?? []) {
                  if (!Get.find<RootViewController>().videoData.any((element) =>
                      element.id?.value.toString() == dataaa.id.toString())) {
                    Get.find<RootViewController>().videoData.add(CourseWishlist(
                        id: RxInt(dataaa.id ?? 0),
                        isWishList: dataaa.isWishlist ?? 0.obs));
                  }
                }
              } else {
                dataa = data!.elementAt(index);
              }
              return GestureDetector(
                onTap: () {
                  AppConstants.instance.singleCourseId.value =
                      (dataa.model?.id != null
                              ? dataa.model?.id.toString()
                              : dataa.id.toString()) ??
                          "";

                  Get.toNamed(
                          Routes.continueWatchScreen(
                              id: dataa.model?.id != null
                                  ? dataa.model?.id.toString()
                                  : dataa.id.toString()),
                          arguments: [
                        dataa.model?.id != null
                            ? dataa.model?.id.toString()
                            : dataa.id.toString(),
                        dataa.model?.categoryId != null
                            ? dataa.model?.categoryId.toString()
                            : dataa.categoryId.toString()
                      ])!
                      .then((value) {
                    Get.find<HomeController>()
                        .getContinueLearning(isFirst: true);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: index != 0 ? DimensionResource.marginSizeSmall : 0),
                  child: videoContainer(index, dataa,
                      width: AppConstants.instance.containerWidth,
                      height: AppConstants.instance.containerHeight,
                      isAudio: false,
                      fontSize: DimensionResource.fontSizeExtraSmall,
                      onWishlist: onWishlist),
                ),
              );
            }),
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )
      ],
    );
  }
}

Widget videoContainer(int index, CommonDatum dataa,
    {double height = 120,
    double width = 120,
    required bool isAudio,
    double fontSize = DimensionResource.fontSizeSmall,
    Function()? onWishlist,
    bool showWishlist = true}) {
  return SizedBox(
    height: height,
    width: width,
    child: Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              // child:  SvgPicture.network("https://stockpathshala-live.s3.ap-south-1.amazonaws.com/public/1695775102elephant_DG-RA_FreeSVG.svg")
              child: cachedNetworkImage(
                dataa.model?.thumbnail ??
                    dataa.thumbnail ??
                    dataa.thumbnails ??
                    "",
                fit: BoxFit.cover,
              )),
          Container(
            color: Colors.black.withOpacity(0.15),
            padding: const EdgeInsets.only(
                top: DimensionResource.marginSizeExtraSmall + 2,
                right: DimensionResource.marginSizeExtraSmall,
                left: DimensionResource.marginSizeExtraSmall + 2,
                bottom: DimensionResource.marginSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  CourseWishlist courseWishlist;
                  if (isAudio) {
                    courseWishlist = Get.find<RootViewController>()
                        .audioData
                        .firstWhere(
                            (p0) =>
                                p0.id?.value == (dataa.model?.id ?? dataa.id),
                            orElse: () => CourseWishlist());
                  } else {
                    courseWishlist = Get.find<RootViewController>()
                        .videoData
                        .firstWhere(
                            (p0) =>
                                p0.id?.value == (dataa.model?.id ?? dataa.id),
                            orElse: () => CourseWishlist());
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!showWishlist) const Spacer(),
                      ((dataa.model?.avgRating == null ||
                                  dataa.model?.avgRating == 0.0) &&
                              (dataa.avgRating == null ||
                                  dataa.avgRating == 0.0))
                          ? const SizedBox()
                          : StarContainer(
                              rating: dataa.model?.avgRating == null
                                  ? dataa.avgRating.toString()
                                  : dataa.model?.avgRating.toString() ?? "",
                              bgColor: ColorResource.white,
                              fontColor: ColorResource.secondaryColor,
                            ),
                      if (showWishlist)
                        IconButtonLayout(
                          onTap: () async {
                            await Get.find<RootViewController>()
                                .saveToWatchLater(
                                    id: (dataa.model?.id != null
                                        ? dataa.model?.id ?? 0
                                        : dataa.id ?? 0),
                                    type: isAudio ? "audio" : "video",
                                    response: (WishListSaveModel wishListData) {
                                      //  HomeDataModelDatum data = Get.find<HomeController>().homeData.value.data?.firstWhere((element) => element.key == "video_courses")??HomeDataModelDatum();
                                      if (wishListData.data ?? false) {
                                        if (dataa.model?.id != null) {
                                          dataa.model?.isWishlist?.value = 1;
                                          // data.data?.firstWhere((element) => element.id == dataa.id).isWishlist?.value = 1;
                                        } else {
                                          dataa.isWishlist!.value = 1;
                                          // data.data?.firstWhere((element) => element.id == dataa.id).isWishlist?.value = 1;
                                        }
                                      } else {
                                        if (dataa.model?.id != null) {
                                          dataa.model?.isWishlist?.value = 0;
                                          // data.data?.firstWhere((element) => element.id == dataa.id).isWishlist?.value = 0;
                                        } else {
                                          dataa.isWishlist!.value = 0;
                                          // data.data?.firstWhere((element) => element.id == dataa.id).isWishlist?.value = 0;
                                        }
                                      }
                                      if (onWishlist != null) {
                                        onWishlist();
                                      }
                                    });
                          },
                          secondImage: courseWishlist.id?.value != null
                              ? courseWishlist.isWishList?.value == 1
                                  ? ImageResource.instance.filledLikeIcon
                                  : null
                              : dataa.model?.id != null
                                  ? dataa.model?.isWishlist!.value == 1
                                      ? ImageResource.instance.filledLikeIcon
                                      : null
                                  : dataa.isWishlist!.value == 1
                                      ? ImageResource.instance.filledLikeIcon
                                      : null,
                          image: ImageResource.instance.likeIcon,
                          iconSize: 9,
                          iconColor: ColorResource.redColor,
                        )
                    ],
                  );
                }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: (dataa.isFree == 0 ? true : false),
                      child: const ProContainerButton(
                        isCircle: true,
                      ),
                    ),
                    Text(
                      dataa.model?.title ??
                          dataa.courseTitle ??
                          dataa.title ??
                          "",
                      style: StyleResource.instance.styleMedium(
                          fontSize: fontSize, color: ColorResource.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: isAudio ? TextAlign.left : TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: isAudio,
            child: Align(
              alignment: Alignment.bottomRight,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(210 / 360),
                child: Image.asset(
                  ImageResource.instance.volumeIcon,
                  height: height >= 85 ? 20 : 26,
                  color: ColorResource.white.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
