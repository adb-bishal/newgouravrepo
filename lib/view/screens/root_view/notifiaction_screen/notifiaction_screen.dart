import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/promocode_model/notification_model.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/root_view_controller/notification_controller/notification_controller.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "Notifications",
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: NotificationController(),
      onPageBuilder: (context, controller) =>
          notificationList(controller: controller),
    );
  }

  Widget notificationList({required NotificationController controller}) {
    return Obx(() => controller.isDataLoading.value
        ? ShimmerEffect.instance.notificationScreenLoader()
        : controller.pagingController.value.list.isEmpty
            ? const NoDataFound(
                showText: true,
                text: "Currently you don't have any notification.",
              )
            : controller.pagingController.value.list.isNotEmpty
                ? PaginationView<Datum>(
                    onRefresh: () async {
                      await controller.getNotificationData(1);
                    },
                    itemBuilder: (context, index, data) {
                      //Datum data = controller.pagingController.value.list.elementAt(index);
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.marginSizeDefault),
                        padding: const EdgeInsets.symmetric(
                            vertical: DimensionResource.marginSizeDefault - 3),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: ColorResource.borderColor
                                        .withOpacity(0.4),
                                    width: 1.1))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 33,
                              width: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    ColorResource.greenColor.withOpacity(0.3),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Icon(
                                    Icons.check,
                                    color: ColorResource.white,
                                  )),
                            ),
                            const SizedBox(
                              width: DimensionResource.marginSizeSmall,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              data.data?.title?.toUpperCase() ??
                                                  "",
                                              style: StyleResource.instance
                                                  .styleSemiBold()
                                                  .copyWith(
                                                      fontSize: DimensionResource
                                                              .fontSizeExtraSmall -
                                                          1,
                                                      color: ColorResource
                                                          .lightSecondaryColor))),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 0, left: 5, right: 10),
                                        height: 7,
                                        width: 7,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: ColorResource.greenColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  data.data?.message ?? "",
                                  style: StyleResource.instance
                                      .styleLight()
                                      .copyWith(
                                          fontSize:
                                              DimensionResource.fontSizeSmall -
                                                  2),
                                  maxLines: 3,
                                ),
                              ],
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  data.createdAtFormat ?? "",
                                  style: StyleResource.instance
                                      .styleRegular()
                                      .copyWith(
                                          fontSize: DimensionResource
                                                  .fontSizeExtraSmall -
                                              1),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    errorBuilder: (context) => Container(),
                    bottomLoaderBuilder: (context) => const Padding(
                          padding: EdgeInsets.only(bottom: 100.0),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: ColorResource.secondaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                    pagingScrollController: controller.pagingController.value)
                : const NoDataFound(
                    showText: true,
                    text: "New Notifications to follow soon.",
                  ));
  }
}
