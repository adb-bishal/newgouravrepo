import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/image_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../../../widgets/image_provider/image_provider.dart';
import '../home_view_screen.dart';

class TextCourseWidget extends StatelessWidget {
  final Function() onTap;
  final List<CommonDatum>? data;
  final HomeDataModelDatum? homeDataModelDatum;
  final String? categoryType;
  const TextCourseWidget(
      {Key? key,
      required this.onTap,
      this.categoryType,
      this.data,
      this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(onTap, homeDataModelDatum?.title ?? StringResource.textCourses,
            showIcon: true,enableTopPadding: false),
        SizedBox(
          height: homeDataModelDatum != null ? (homeDataModelDatum?.data?.isNotEmpty??false) && homeDataModelDatum?.data?.length == 1 ? 100:200 : (data?.isNotEmpty??false)&& data?.length == 1 ? 100:200,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            itemCount: homeDataModelDatum?.data?.length ?? data?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: homeDataModelDatum != null ? (homeDataModelDatum?.data?.isNotEmpty??false) && homeDataModelDatum?.data?.length == 1 ? 1:2:(data?.isNotEmpty??false)&& data?.length == 1 ? 1:2,
                childAspectRatio: 2 / 6.6,
                mainAxisSpacing: DimensionResource.marginSizeSmall+10,
                crossAxisSpacing: DimensionResource.marginSizeSmall - 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              CommonDatum dataaa;
              if (homeDataModelDatum != null) {
                dataaa = CommonDatum.fromJson(
                    homeDataModelDatum?.data?.elementAt(index).toJson() ?? {});
                // for(var dataaa in homeDataModelDatum?.data??[]){
                //   if(!Get.find<RootViewController>().textCourseData.any((element) => element.id?.value.toString() == dataaa.id.toString())){
                //     Get.find<RootViewController>().textCourseData.add(CourseWishlist(id: RxInt(dataaa.id??0)??0.obs,isWishList: dataaa.isWishlist??0.obs));
                //   }
                // }
              } else {
                dataaa = data!.elementAt(index);
                // for(var dataaa in data??[]){
                //   if(!Get.find<RootViewController>().textCourseData.any((element) => element.id?.value.toString() == dataaa.id.toString())){
                //     Get.find<RootViewController>().textCourseData.add(CourseWishlist(id: RxInt(dataaa.id??0)??0.obs,isWishList: dataaa.isWishlist??0.obs));
                //   }
                // }
              }
              return Padding(
                padding: EdgeInsets.only(
                    bottom: index ==
                            ((homeDataModelDatum?.data?.length ??
                                    data?.length) ??
                                1 - 1)
                        ? 0
                        : DimensionResource.marginSizeDefault),
                child: textCourseContainer(index, dataaa, categoryType ?? ""),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget textCourseContainer(int index, CommonDatum dataa, String category) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
            Routes.textCourseDetail(
                id: dataa.model?.id != null
                    ? dataa.model?.id.toString()
                    : dataa.id.toString()),
            arguments: [
              category,
              dataa.model?.id != null
                  ? dataa.model?.id.toString()
                  : dataa.id.toString()
            ])!.then((value) {
          Get.find<HomeController>().getContinueLearning(isFirst: true);
        });
      },
      child: SizedBox(
        height: 70,
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: ColorResource.borderColor.withOpacity(0.3),
              )),
          margin: EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          child: dataa.image == null
                              ? Image.asset(
                                  ImageResource.instance.cBg1Icon,
                                  fit: BoxFit.cover,
                                )
                              : cachedNetworkImage(
                                  dataa.thumbnail??dataa.image ?? "",
                                  fit: BoxFit.cover,
                                )),
                    )),
                Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeSmall,
                          vertical: DimensionResource.marginSizeExtraSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              Visibility(
                                visible: (dataa.isFree == 0 ? true:false),
                                child: const ProContainerButton(
                                  isCircle: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: DimensionResource.marginSizeSmall - 5,
                          ),
                          Text(
                            dataa.courseTitle.toString().capitalize ?? "",
                            style: StyleResource.instance.styleMedium(
                                fontSize: DimensionResource.fontSizeSmall),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
