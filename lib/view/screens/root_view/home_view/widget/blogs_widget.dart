import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';

import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../view_model/routes/app_pages.dart';
import '../../../../widgets/image_provider/image_provider.dart';
import '../home_view_screen.dart';

class BlogsWidget extends StatelessWidget {
  final Function() onTap;
  final HomeDataModelDatum? homeDataModelDatum;
  final List<CommonDatum>? data;
  const BlogsWidget(
      {Key? key, required this.onTap, this.data, this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(onTap, homeDataModelDatum?.title ?? StringResource.blogs,
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
                  if (!Get.find<RootViewController>().blogsData.any((element) =>
                      element.id?.value.toString() == dataaa.id.toString())) {
                    Get.find<RootViewController>().blogsData.add(CourseWishlist(
                        id: RxInt(dataaa.id),
                        isWishList: dataaa.isWishlist ?? 0.obs));
                  }
                }
              } else {
                dataa = data!.elementAt(index);
                for (var dataaa in data ?? []) {
                  if (!Get.find<RootViewController>().blogsData.any((element) =>
                      element.id?.value.toString() == dataaa.id.toString())) {
                    Get.find<RootViewController>().blogsData.add(CourseWishlist(
                        id: RxInt(dataaa.id),
                        isWishList: dataaa.isWishlist ?? 0.obs));
                  }
                }
              }
              return Padding(
                padding: EdgeInsets.only(
                    right: index ==
                            (homeDataModelDatum?.data?.length ??
                                data?.length ??
                                0 - 1)
                        ? 0
                        : DimensionResource.marginSizeSmall),
                child: blogsContainer(dataa,
                    width: AppConstants.instance.containerWidth, height: 123),
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

Widget blogsContainer(CommonDatum data,
    {double height = 150,
    double width = 152,
    Function(CommonDatum data)? onItemTap}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: () {
      AppConstants.instance.blogId.value = (data.model?.id != null
              ? data.model?.id.toString()
              : data.id.toString()) ??
          "";

      Get.toNamed(
              Routes.blogsView(
                  id: data.model?.id != null
                      ? data.model?.id.toString()
                      : data.id.toString()),
              arguments: [
            data.model?.id != null
                ? data.model?.id.toString()
                : data.id.toString(),
            data.model?.categoryId != null
                ? data.model?.categoryId.toString()
                : data.categoryId.toString()
          ])!
          .then((value) {
        Get.find<HomeController>().getContinueLearning(isFirst: true);
      });
      if (onItemTap != null) {
        onItemTap(data);
      }
    },
    child: SizedBox(
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
                child: cachedNetworkImage(
                  data.thumbnail ?? data.image ?? "",
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.only(
                  top: DimensionResource.marginSizeExtraSmall + 2,
                  right: DimensionResource.marginSizeExtraSmall,
                  left: DimensionResource.marginSizeExtraSmall + 2,
                  bottom: DimensionResource.marginSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //data.avgRating == 0.0?const SizedBox():
                  (data.model?.avgRating == null ||
                              data.model?.avgRating == 0.0) &&
                          (data.avgRating == null || data.avgRating == 0.0)
                      ? const SizedBox()
                      : StarContainer(
                          rating: data.model?.avgRating == null
                              ? data.avgRating.toString()
                              : data.model?.avgRating.toString() ?? "",
                          bgColor: ColorResource.white,
                          fontColor: ColorResource.secondaryColor,
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color:
                                ColorResource.secondaryColor.withOpacity(0.88),
                            borderRadius: BorderRadius.circular(9)),
                        padding: const EdgeInsets.symmetric(
                            vertical: DimensionResource.marginSizeExtraSmall,
                            horizontal: DimensionResource.marginSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.category?.title?.toUpperCase() ?? "",
                              style: StyleResource.instance.styleMedium(
                                  fontSize:
                                      DimensionResource.fontSizeExtraSmall -
                                          (width < 152 ? 3.5 : 2),
                                  color: ColorResource.accentYellowColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height:
                                  DimensionResource.marginSizeExtraSmall - 2,
                            ),
                            Text(
                              data.title == null
                                  ? "Secret Option Buying Strategies"
                                  : data.title.toString().capitalize ??
                                      "Secret Option Buying Strategies",
                              style: StyleResource.instance.styleRegular(
                                  fontSize:
                                      DimensionResource.fontSizeExtraSmall -
                                          (width < 152 ? 2 : 0),
                                  color: ColorResource.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
            Visibility(
              visible: (data.isFree == 0 ? true : false),
              child: const Center(
                child: ProContainerButton(
                  isCircle: true,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
