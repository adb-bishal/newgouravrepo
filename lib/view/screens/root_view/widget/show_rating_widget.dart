import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/screens/root_view/text_course_detail_view/text_course_detail_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/widget/add_rating_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../model/models/rating_model/rating_model.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../view_model/controllers/root_view_controller/widget_controllers/show_rating_controller.dart';
import '../../../widgets/button_view/animated_box.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';

class ShowRatingWidget extends GetView<ShowRatingController> {
  final CourseDatum courseDatum;
  const ShowRatingWidget({Key? key, required this.courseDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.65,
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Stack(
        children: [
          PaginationView<Datum>(
              onRefresh: () async {
                // controller.refreshOrder();
              },
              itemBuilder: (context, index, data) {
                logPrint("rating data ${data.toJson()}");
                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: ColorResource.white.withOpacity(0.4)))),
                  padding: const EdgeInsets.symmetric(
                      vertical: DimensionResource.marginSizeSmall),
                  child: ratingContainer(true, context,
                      courseDatum: courseDatum,
                      showNameCircle: true,
                      showAddIcon: false,
                      userRatingModel: UserRatingModel(
                          userName: data.user?.name ?? "",
                          rating: data.rating.toString(),
                          comment: data.comment ?? "",
                          ratingDate: data.createdAt,
                          replyDate: data.reviewable?.updatedAt,
                          reply: data.reply)),
                );
              },
              errorBuilder: (context) => Container(),
              bottomLoaderBuilder: (context) => const Padding(
                    padding: EdgeInsets.only(bottom: 30.0, top: 20),
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          color: ColorResource.secondaryColor,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
              pagingScrollController: controller.pagingController.value),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () async {
                if (!Get.find<AuthService>().isGuestUser.value) {
                  await buildShowModalBottomSheet(
                      context,
                      AddRatingWidget(
                        courseDatum: courseDatum,
                      ),
                      isDismissible: true);
                } else {
                  ProgressDialog().showFlipDialog(isForPro: false);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(
                    bottom: DimensionResource.marginSizeDefault),
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorResource.primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: ColorResource.primaryColor,
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]),
                child: const Icon(
                  Icons.add,
                  color: ColorResource.white,
                  size: 19,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
