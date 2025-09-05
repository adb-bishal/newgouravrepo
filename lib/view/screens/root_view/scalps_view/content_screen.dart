import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/helper_util.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/scalp_controller/scalp_controller.dart';

import '../../../../model/models/scalp_model/comment_model.dart' as comment;
import '../../../../model/models/scalp_model/scalp_data_model.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/services/player/file_video_widget.dart';
import '../../../../model/services/player/video_player_widget.dart';
import '../../../../model/utils/app_constants.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../view_model/controllers/root_view_controller/scalp_controller/comment_controller.dart';
import '../../../widgets/button_view/animated_box.dart';
import '../home_view/widget/scalps_widget.dart';
import '../video_course_detail_view/video_course_detail_view.dart';
import '../widget/add_rating_widget.dart';

class ContentScreen extends StatefulWidget {
  final Datum data;
  const ContentScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data.fileType == null || widget.data.fileType == "") {
      return cachedNetworkImage(widget.data.thumbnail ?? "");
    } else if (widget.data.fileType != null && widget.data.fileType != "") {
      return videoViewWidget();
    } else {
      return const SizedBox();
    }
  }

  Widget videoViewWidget() {
    if (widget.data.fileType != null && widget.data.fileType == "Url") {
      return Stack(
        fit: StackFit.expand,
        children: [
          YouTubePlayerWidget(
              url: widget.data.videoUrl ?? "",
              isScalp: true,
              isPlaying: (isPlaying) {},
              eventCallBack: (event, totalDuration) async {
                logPrint("Duration $totalDuration event position $event");
                if (event == 10) {
                  logPrint('dfd');
                  Get.find<ScalpController>()
                      .onScalpHistory(widget.data.id.toString());
                }
              }),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Platform.isIOS
                    ? MediaQuery.of(context).padding.top + 7
                    : MediaQuery.of(context).padding.top +
                        (MediaQuery.of(context).size.height * 0.035),
                width: double.infinity,
                color: Colors.black,
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                width: double.infinity,
                color: Colors.black,
              )),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: OptionsScreen(
              data: widget.data,
            ),
          )
        ],
      );
    } else if (widget.data.fileType != null && widget.data.fileType != "Url") {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FileVideoWidget(
                  url: widget.data.videoUrl ?? "",
                  thumbnail: "",
                  isScalp: true,
                  onPlayButton: (isPlaying) {
                    setState(() {
                      isPaused = !isPlaying;
                    });
                  },
                  eventCallBack: (progress, totalDuration) async {
                    if (progress == 10) {
                      logPrint('dfd');
                      Get.find<ScalpController>()
                          .onScalpHistory(widget.data.id.toString());
                    }
                  }),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: OptionsScreen(
                data: widget.data,
              ),
            ),
            if (isPaused)
              const Center(
                child: ShowPlayIcon(),
              ),
          ],
        ),
      );
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }
}

class ShowPlayIcon extends StatelessWidget {
  const ShowPlayIcon({super.key});

  Future<int> tempFuture() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
            future: tempFuture(),
            builder: (context, snapshot) => AnimatedOpacity(
                  opacity:
                      snapshot.connectionState != ConnectionState.done ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: playIconButton(
                      onTap: () {},
                      icon: ImageResource.instance.playIcon,
                      isPlaying: false,
                      height: 20,
                      allPadding: 16),
                )));
  }
}

class OptionsScreen extends StatelessWidget {
  final Datum data;

  const OptionsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: data.category?.title != null,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: ColorResource.yellowColor),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    child: Text(
                      data.category?.title?.toUpperCase() ?? "",
                      style: StyleResource.instance.styleMedium(
                        fontSize: DimensionResource.fontSizeExtraSmall - 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeExtraSmall,
                ),
                Text(
                  data.title ?? "",
                  style: StyleResource.instance
                      .styleSemiBold(color: ColorResource.white),
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeExtraSmall,
                ),
                ReadMoreText(data.description ?? "",
                    trimLines: 3,
                    colorClickableText: ColorResource.primaryColor,
                    style: StyleResource.instance
                        .styleMedium(
                            color: ColorResource.white,
                            fontSize: DimensionResource.fontSizeSmall - 1)
                        .copyWith(letterSpacing: .2),
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'read more',
                    trimExpandedText: '  show less',
                    lessStyle: StyleResource.instance
                        .styleLight(
                          fontSize: 10,
                          color: ColorResource.mateRedColor,
                        )
                        .copyWith(letterSpacing: .2),
                    moreStyle: StyleResource.instance
                        .styleLight(
                          fontSize: 10,
                          color: ColorResource.primaryColor,
                        )
                        .copyWith(letterSpacing: .2),
                    textAlign: TextAlign.start),
                const SizedBox(
                  height: DimensionResource.marginSizeExtraSmall + 3,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: DimensionResource.marginSizeSmall,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() {
                return scalpsActionBuilder(
                    image: ImageResource.instance.heartIcon,
                    text:
                        "${data.totalLikes?.value ?? 0} ${((int.tryParse(data.totalLikes?.value ?? "0") ?? 0) > 1) ? StringResource.likes : StringResource.like}",
                    iconSize: 13,
                    allPadding: 8,
                    secondImage: data.isLiked?.value == 1
                        ? ImageResource.instance.filledHeartIcon
                        : null,
                    onTap: () {
                      Get.find<ScalpController>().onLike(data.id ?? 0,
                          onSuccess: (val) {
                        int totalLikes = 0;
                        if (int.tryParse(data.totalLikes?.value ?? "0") ==
                            null) {
                          //
                        } else {
                          totalLikes =
                              int.tryParse(data.totalLikes?.value ?? "0") ?? 0;
                        }
                        if (val.isNotEmpty && val['data']) {
                          data.isLiked?.value = 1;
                          totalLikes++;
                        } else {
                          data.isLiked?.value = 0;
                          totalLikes--;
                        }
                        logPrint("sfdsfsd ${data.isLiked?.value}");
                        if (int.tryParse(data.totalLikes?.value ?? "0") ==
                            null) {
                          //
                        } else {
                          data.totalLikes?.value = totalLikes.toString();
                        }
                      });
                    });
              }),
              Obx(() {
                return scalpsActionBuilder(
                    image: ImageResource.instance.commentIcon,
                    text:
                        "${data.totalComment?.value ?? 0} ${((int.tryParse(data.totalComment?.value ?? "0") ?? 0) > 1) ? StringResource.comments : StringResource.comment}",
                    iconColor: ColorResource.primaryColor,
                    iconSize: 13,
                    allPadding: 8,
                    onTap: () async {
                      await buildShowModalBottomSheet(
                              context,
                              CommentWidget(
                                courseDatum:
                                    CourseDatum(id: data.id.toString()),
                              ),
                              isDismissible: true)
                          .then((value) async {
                        data.totalComment?.value =
                            ((Get.find<CommentController>()
                                            .commentData
                                            .value
                                            .data
                                            ?.pagination
                                            ?.total ??
                                        0) >
                                    1000)
                                ? data.totalComment?.value ?? "0"
                                : Get.find<CommentController>()
                                        .commentData
                                        .value
                                        .data
                                        ?.pagination
                                        ?.total
                                        .toString() ??
                                    "0";
                        await Get.delete<CommentController>();
                      });
                    });
              }),
              Obx(() {
                return scalpsActionBuilder(
                    image: ImageResource.instance.shareIcon,
                    text:
                        "${data.totalShares?.value ?? 0} ${((int.tryParse(data.totalShares?.value ?? "0") ?? 0) > 1) ? StringResource.shares : StringResource.share}",
                    iconSize: 13,
                    allPadding: 8,
                    onTap: () async {
                      await HelperUtil.instance
                          .buildInviteLink(
                              isAppShare: false,
                              shareId: data.id.toString(),
                              type: AppConstants.shareScalp)
                          .then((value) async {
                        await HelperUtil.share(
                                referCode: "", url: value.shortUrl.toString())
                            .then((value) {
                          Get.find<ScalpController>().onShare(data.id ?? 0,
                              onSuccess: () {
                            int totalShare = data.totalShares?.value == ""
                                ? 0
                                : int.parse(data.totalShares?.value ?? "0");
                            data.totalShares?.value =
                                (totalShare + 1).toString();
                          });
                        });
                      });
                    });
              }),
            ],
          )
        ],
      ),
    );
  }
}

class CommentWidget extends GetView<CommentController> {
  final CourseDatum courseDatum;
  const CommentWidget({Key? key, required this.courseDatum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommentController contr;
    if (courseDatum.id != null && courseDatum.id != "") {
      contr = Get.put(CommentController(data: courseDatum));
    } else {
      contr = Get.put(CommentController(data: courseDatum));
    }

    return Container(
        height: Get.height * 0.55,
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                () => controller.isCommentDataLoading.value
                    ? const CommonCircularIndicator()
                    : controller.pagingController.value.list.isEmpty
                        ? const NoDataFound()
                        : PaginationView<comment.Datum>(
                            onRefresh: () async {
                              // controller.refreshOrder();
                            },
                            itemBuilder: (context, index, data) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: index ==
                                            controller.pagingController.value
                                                    .list.length -
                                                1
                                        ? DimensionResource.marginSizeSmall
                                        : 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: ColorResource.white
                                                .withOpacity(0.4)))),
                                padding: const EdgeInsets.symmetric(
                                    vertical:
                                        DimensionResource.marginSizeSmall),
                                child: commentContainer(
                                  true,
                                  context,
                                  data: data,
                                  showNameCircle: true,
                                  showAddIcon: false,
                                ),
                              );
                            },
                            errorBuilder: (context) => Container(),
                            bottomLoaderBuilder: (context) => const Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 30.0, top: 20),
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
                            pagingScrollController:
                                controller.pagingController.value),
              ),
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  color: ColorResource.white,
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(
                  bottom: DimensionResource.marginSizeSmall),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    cursorColor: ColorResource.white,
                    controller: contr.commentController,
                    style: StyleResource.instance.styleRegular(
                        fontSize: DimensionResource.fontSizeSmall,
                        color: ColorResource.primaryColor),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringResource.typeAComment,
                        hintStyle: StyleResource.instance.styleRegular(
                            fontSize: DimensionResource.fontSizeSmall,
                            color: ColorResource.primaryColor),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.marginSizeDefault)),
                  )),
                  Obx(() {
                    return contr.isCommentLoading.value
                        ? const Padding(
                            padding: EdgeInsets.only(
                                right: DimensionResource.marginSizeDefault),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: ColorResource.primaryColor,
                              ),
                            ),
                          )
                        : IconButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    DimensionResource.marginSizeDefault),
                            onPressed: contr.postComment,
                            icon: Image.asset(
                              ImageResource.instance.sendMessage,
                              color: ColorResource.primaryColor,
                              height: 18,
                            ));
                  })
                ],
              ),
            )
          ],
        ));
  }

  commentContainer(
    bool isDark,
    BuildContext context, {
    bool showAddIcon = true,
    bool showNameCircle = false,
    required comment.Datum data,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: showNameCircle,
          child: Padding(
            padding: const EdgeInsets.only(
                right: DimensionResource.marginSizeExtraSmall, top: 5),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ColorResource.lightBlack,
              child: Text(
                data.userName?.substring(0, 1).toUpperCase() ?? "",
                style: StyleResource.instance.styleSemiBold(
                    color: ColorResource.primaryColor,
                    fontSize: DimensionResource.fontSizeLarge),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: DimensionResource.marginSizeSmall - 4,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: DimensionResource.marginSizeSmall - 5,
              ),
              IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.userName?.capitalize ?? "",
                      style: StyleResource.instance.styleMedium(
                        fontSize: DimensionResource.fontSizeSmall,
                        color: isDark
                            ? ColorResource.white
                            : ColorResource.secondaryColor,
                      ),
                    ),
                    // VerticalDivider(
                    //   endIndent: 2.2,
                    //   indent: 2.2,
                    //   thickness: 1.2,
                    //   color: isDark
                    //       ? ColorResource.white
                    //       : ColorResource.secondaryColor,
                    // ),
                    Text(
                      AppConstants.formatDate(data.createdAt),
                      style: StyleResource.instance.styleRegular(
                        fontSize: DimensionResource.fontSizeExtraSmall - 2,
                        color: isDark
                            ? ColorResource.white
                            : ColorResource.secondaryColor,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: DimensionResource.marginSizeExtraSmall + 1,
              ),
              Text(
                data.comment.toString().capitalize ?? "",
                style: StyleResource.instance
                    .styleLight(
                        fontSize: DimensionResource.fontSizeExtraSmall,
                        color: isDark
                            ? ColorResource.white.withOpacity(0.6)
                            : ColorResource.lightTextColor)
                    .copyWith(letterSpacing: .4),
              ),
            ],
          ),
        )
      ],
    );
  }
}
