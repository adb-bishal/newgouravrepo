import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';

import '../../../../../../../model/utils/color_resource.dart';
import '../../../../../../../model/utils/dimensions_resource.dart';
import '../../../../../../../model/utils/image_resource.dart';
import '../../../../../../../model/utils/style_resource.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/services/auth_service.dart';
import '../../../../widgets/view_helpers/progress_dialog.dart';
import '../home_view_screen.dart';

class QuizWidget extends StatelessWidget {
  final HomeDataModelDatum? homeDataModelDatum;
  const QuizWidget({Key? key, this.homeDataModelDatum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(
          () {},
          homeDataModelDatum?.title ?? StringResource.quickQuiz,
          showIcon: false,
          enableTopPadding: false,
        ),
        SizedBox(
          //aspectRatio: 5/1.75,
          height: 72,
          width: Get.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            child: Row(
              children:
                  List.generate(homeDataModelDatum?.data?.length ?? 0, (index) {
                DatumDatum data = homeDataModelDatum!.data!.elementAt(index);
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    logPrint(data.toJson());
                    if (!Get.find<AuthService>().isGuestUser.value) {
                      Get.find<RootViewController>().getPopUpData4(data);
                    } else {
                      ProgressDialog().showFlipDialog(
                          isForPro: Get.find<AuthService>().isGuestUser.value
                              ? false
                              : true);
                    }

                    // Get.find<QuizController>().getQuizById(data.id.toString());
                    // Get.find<QuizController>().quizType.value = data.isScholarship == 1 ? QuizType.scholarship:QuizType.free;
                    // Get.find<QuizController>().isTimeUp.value = false;
                  },
                  child: SizedBox(
                    width:MediaQuery.of(Get.context!).size.width<500? 270:260,
                    height: 72,
                    child: Card(
                      color: ColorResource.white,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: ColorResource.borderColor.withOpacity(0.3),
                          )),
                      margin: EdgeInsets.only(
                          left: index != 0
                              ? DimensionResource.marginSizeDefault
                              : 0),
                      // padding:  EdgeInsets.only(left: index != 0 ? DimensionResource.marginSizeExtraSmall:0 ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: cachedNetworkImage(data.banner ?? "")),
                            Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: DimensionResource
                                                  .marginSizeSmall),
                                          child: Text(
                                            "FINAL QUIZ",
                                            style: StyleResource.instance
                                                .styleSemiBold(
                                                    color: ColorResource
                                                        .greenColor,
                                                    fontSize:MediaQuery.of(Get.context!).size.width<500? DimensionResource.fontSizeSmall:DimensionResource.fontSizeDefault-1),
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: ColorResource.primaryColor,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          padding: const EdgeInsets.all(5),
                                          child: Image.asset(
                                            ImageResource.instance.topArrowIcon,
                                            height:MediaQuery.of(Get.context!).size.width<500? 14:18,
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: DimensionResource
                                              .marginSizeSmall),
                                      child: Text(
                                        data.title ?? "",
                                        style: StyleResource.instance
                                            .styleMedium(
                                                fontSize: DimensionResource.fontSizeSmall),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )
      ],
    );
  }
}
