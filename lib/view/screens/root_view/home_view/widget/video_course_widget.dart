import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/app_constants.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../../../../view_model/routes/app_pages.dart';
import '../../../../widgets/image_provider/image_provider.dart';
import '../home_view_screen.dart';

class VideoCourseWidget extends StatelessWidget {
  final Function() onTap;
  final HomeDataModelDatum? homeDataModelDatum;
  final List<CommonDatum>? data;
  final Function()? onWishlist;
  const VideoCourseWidget(
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
        rowTile(onTap, homeDataModelDatum?.title ?? StringResource.videoCourses,
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
                  if (!Get.find<RootViewController>().videoCourseData.any(
                      (element) =>
                          element.id?.value.toString() ==
                          dataaa.id.toString())) {
                    Get.find<RootViewController>().videoCourseData.add(
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
                    right:
                        index == 6 ? 0 : DimensionResource.marginSizeSmall - 2),
                child: videoCourseContainer(index, dataa,
                    width: AppConstants.instance.containerWidth,
                    height: AppConstants.instance.containerWidth,
                    categoryType: "",
                    fontSize: DimensionResource.fontSizeExtraSmall),
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

Widget videoCourseContainer(int index, CommonDatum dataa,
    {double height = 120,
    double width = 120,
    double fontSize = DimensionResource.fontSizeSmall,
    required String categoryType,
    Function(CommonDatum data)? onItemTap,
    Function()? onWishlist,
    bool isTapEnable = true}) {
  final authService = Get.find<AuthService>();
  final userRole = authService.userRole.value;
  return InkWell(
    splashColor: Colors.transparent,
    onTap: isTapEnable
        ? () {
            AppConstants.instance.videoCourseId.value = (dataa.model?.id != null
                    ? dataa.model?.id.toString()
                    : dataa.id.toString()) ??
                "";
            try {
              Get.toNamed(
                  Routes.videoCourseDetail(
                      id: dataa.model?.id != null
                          ? dataa.model?.id.toString()
                          : dataa.id.toString()),
                  arguments: [
                    categoryType,
                    dataa.model?.id != null
                        ? dataa.model?.id.toString()
                        : dataa.id.toString()
                  ])?.then((value) {
                Get.find<HomeController>().getContinueLearning(isFirst: true);
              });
            } catch (e) {
              logPrint("error: $e");
            }
            if (onItemTap != null) {
              onItemTap(dataa);
            }
          }
        : null,
    child: SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              height: height,
              width: width,
              child: cachedNetworkImage(
                dataa.model?.id != null
                    ? dataa.model?.thumbnail ?? ""
                    : (dataa.thumbnail ?? dataa.image ?? ""),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              // height: height,
              // width: width,
              decoration: BoxDecoration(
                  color: dataa.themeColor?.withOpacity(0.24),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.only(
                  top: DimensionResource.marginSizeExtraSmall,
                  right: DimensionResource.marginSizeExtraSmall,
                  left: DimensionResource.marginSizeExtraSmall,
                  bottom: DimensionResource.marginSizeSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child:
                        //dataa.avgRating == 0.0?const SizedBox():
                        (dataa.model?.avgRating == null ||
                                    dataa.model?.avgRating == 0.0) &&
                                (dataa.avgRating == null ||
                                    dataa.avgRating == 0.0)
                            ? const SizedBox()
                            : StarContainer(
                                rating: dataa.model?.avgRating == null
                                    ? dataa.avgRating.toString()
                                    : dataa.model?.avgRating.toString() ?? "",
                                bgColor: ColorResource.white,
                                fontColor: ColorResource.secondaryColor,
                              ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userRole == "trial_user"
                          // ||
                          //     userRole == "trial_expired_user"
                          ? Visibility(
                              visible: (dataa.model?.id != null
                                  ? (dataa.model?.isFree == 0 &&
                                          dataa.model?.isTrial == 0
                                      ? true
                                      : false)
                                  : dataa.isFree == 0 && dataa.isTrial == 0
                                      ? true
                                      : false),
                              child: const ProContainerButton(
                                isCircle: true,
                              ),
                            )
                          : userRole != "pro_user"
                              ? const ProContainerButton(
                                  isCircle: true,
                                  isShow: true,
                                )
                              : Container(),
                      Text(
                        dataa.model?.id != null
                            ? dataa.model?.courseTitle ?? ""
                            : dataa.courseTitle == null
                                ? ""
                                : dataa.courseTitle.toString().capitalize ?? "",
                        style: StyleResource.instance.styleMedium(
                            fontSize: fontSize, color: ColorResource.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
