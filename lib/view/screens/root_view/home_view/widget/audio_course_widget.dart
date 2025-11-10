import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/scalps_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';

import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/image_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../enum/routing/routes/app_pages.dart';
import '../home_view_screen.dart';

class AudioCourseWidget extends StatelessWidget {
  final Function() onSeeAll;
  final List<CommonDatum>? data;
  final HomeDataModelDatum? homeDataModelDatum;
  final Function()? onWishlist;
  const AudioCourseWidget(
      {Key? key,
      required this.onSeeAll,
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
            onSeeAll, homeDataModelDatum?.title ?? StringResource.audioCourses,
            showIcon: true, enableTopPadding: false),
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
                  if (!Get.find<RootViewController>().audioCourseData.any(
                      (element) =>
                          element.id?.value.toString() ==
                          dataaa.id.toString())) {
                    Get.find<RootViewController>().audioCourseData.add(
                        CourseWishlist(
                            id: RxInt(dataaa.id),
                            isWishList: dataaa.isWishlist ?? 0.obs));
                  }
                }
              } else {
                dataa = data!.elementAt(index);
              }
              return Padding(
                padding: EdgeInsets.only(
                    right: index == 6 ? 0 : DimensionResource.marginSizeSmall),
                child: audioCourseContainer(index, dataa,
                    width: AppConstants.instance.containerWidth,
                    height: 78,
                    categoryType: "",
                    fontSize: DimensionResource.fontSizeExtraSmall,
                    onWishlist: onWishlist),
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

Widget audioCourseContainer(int index, CommonDatum dataa,
    {double height = 87,
    double width = 132,
    required String categoryType,
    double fontSize = DimensionResource.marginSizeSmall + 1,
    Function()? onWishlist}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: () {
      // Get.toNamed(Routes.audioCourseDetail(id: dataa.id.toString()), arguments: ["",dataa.id.toString(),dataa.tagId.toString(),dataa.title]);
      Get.toNamed(
              Routes.audioCourseDetail(
                  id: dataa.model?.id != null
                      ? dataa.model?.id.toString()
                      : dataa.id.toString()),
              arguments: [
            CourseDetailViewType.audioCourse,
            dataa.model?.id != null
                ? dataa.model?.id.toString()
                : dataa.id.toString(),
            dataa.model?.categoryId != null
                ? dataa.model?.categoryId.toString()
                : dataa.categoryId.toString(),
            dataa.courseTitle.toString()
          ])!
          .then((value) {
        Get.find<HomeController>().getContinueLearning(isFirst: true);
      });
    },
    child: Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: dataa.model?.themeColor ?? dataa.themeColor,
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.only(
            top: DimensionResource.marginSizeExtraSmall + 2,
            right: DimensionResource.marginSizeExtraSmall,
            left: DimensionResource.marginSizeExtraSmall + 2,
            bottom: DimensionResource.marginSizeSmall),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                ImageResource.instance.volumeIcon,
                color: ColorResource.white.withOpacity(0.6),
                height: height <= 78 ? 14 : 18,
              ),
            ),
            Visibility(
              visible: (dataa.model?.isFree == 0 || dataa.isFree == 0
                  ? true
                  : false),
              child: const Center(
                child: ProContainerButton(
                  isCircle: true,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (dataa.model?.avgRating == null ||
                                dataa.model?.avgRating == 0.0) &&
                            (dataa.avgRating == null || dataa.avgRating == 0.0)
                        ? const SizedBox()
                        : StarContainer(
                            vertical: 1,
                            rating: dataa.model?.avgRating == null
                                ? (dataa.avgRating.toString())
                                : (dataa.model?.avgRating.toString() ?? ""),
                            bgColor: ColorResource.white,
                            fontColor: ColorResource.secondaryColor,
                          ),
                    Obx(() {
                      CourseWishlist courseWishlist =
                          Get.find<RootViewController>()
                              .audioCourseData
                              .firstWhere(
                                  (p0) =>
                                      p0.id?.value ==
                                      (dataa.model?.id ?? dataa.id),
                                  orElse: () => CourseWishlist());
                      return IconButtonLayout(
                        onTap: () async {
                          await Get.find<RootViewController>().saveToWatchLater(
                              id: (dataa.model?.id != null
                                  ? dataa.model?.id ?? 0
                                  : dataa.id ?? 0),
                              type: AppConstants.audioCourse,
                              response: (WishListSaveModel wishListData) {
                                if (wishListData.data ?? false) {
                                  if (dataa.model?.id != null) {
                                    dataa.model?.isWishlist?.value = 1;
                                  } else {
                                    dataa.isWishlist!.value = 1;
                                  }
                                } else {
                                  if (dataa.model?.id != null) {
                                    dataa.model?.isWishlist?.value = 0;
                                  } else {
                                    dataa.isWishlist!.value = 0;
                                  }
                                }
                                if (onWishlist != null) {
                                  onWishlist();
                                }
                              });
                        },
                        secondImage: courseWishlist.id != null
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
                      );
                    })
                  ],
                ),
                const Spacer(),
                Text(
                  dataa.model?.id != null
                      ? dataa.model?.title ?? dataa.model?.courseTitle ?? ""
                      : dataa.courseTitle ?? dataa.title ?? "",
                  style: StyleResource.instance.styleMedium(
                      fontSize: fontSize, color: ColorResource.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
