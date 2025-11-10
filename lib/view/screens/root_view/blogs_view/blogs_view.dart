import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/text_course_detail_view/widget/more_like_this_widget.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/blogs_view_controller/blogs_view_controller.dart';

import '../../../../model/services/player/file_video_widget.dart';
import '../../../../model/services/player/video_player_widget.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../service/page_manager.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../enum/routing/routes/app_pages.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../base_view/video_base_view.dart';
import '../../subscription_view/example_blog.dart';
import '../audio_course_detail_view/audio_course_detail_view.dart';
import '../live_classes_view/live_class_detail/live_class_detail.dart';
import '../text_course_detail_view/text_course_detail_view.dart';
import '../video_course_detail_view/video_course_detail_view.dart';
import '../widget/add_rating_widget.dart';

class BlogsView extends StatelessWidget {
  const BlogsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoBaseView(
      screenType: AppConstants.blog,
      pinned: false,
      isDataLoading: Get.find<BlogsViewController>().isDataLoading,
      viewControl: BlogsViewController(),
      onBackClicked: (context, controller) {
        Get.back();
      },
      actionBuilder: (context, controller) => [
        Obx(() => controller.blogData.value.data?.blogRating == 0.0 ||
                controller.blogData.value.data?.blogRating == null
            ? const SizedBox()
            : StarContainer(
                rating:
                    controller.blogData.value.data?.blogRating.toString() ?? "",
                vertical: 3,
                horizontal: 6,
                isDark: true,
              )),
      ],
      videoViewHeight: 180,
      onVideoBuilder: (context, controller) => Obx(() {
        return controller.isDataLoading.value
            ? const CommonCircularIndicator()
            : (Get.find<AuthService>().isGuestUser.value) ||
                    (!Get.find<AuthService>().isPro.value &&
                        controller.blogData.value.data?.isFree != 1) ||
                    (controller.selectedVideo.value.fileUrl == null ||
                        controller.selectedVideo.value.fileUrl == "")
                ? Stack(
                    children: [
                      Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: cachedNetworkImage(
                              controller.blogData.value.data?.image ?? "",
                              fit: BoxFit.cover)),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      DimensionResource.marginSizeDefault,
                                  vertical:
                                      DimensionResource.marginSizeDefault),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return ContainerButton(
                                      onPressed: () {},
                                      text: controller.blogData.value.data
                                              ?.category?.title
                                              ?.toUpperCase() ??
                                          "",
                                      color: ColorResource.white,
                                      textStyle: StyleResource.instance
                                          .styleRegular(
                                              fontSize: DimensionResource
                                                      .fontSizeSmall -
                                                  2,
                                              color:
                                                  ColorResource.primaryColor),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: DimensionResource
                                                  .marginSizeExtraSmall +
                                              3,
                                          vertical: 3),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : controller.selectedVideo.value.fileType == "Url"
                    ? YouTubePlayerWidget(
                        // isFullScreen:(isFullScreen){
                        //   controller.isFullScreen.value = isFullScreen;
                        // },
                        autoPlay: false,
                        url: controller.selectedVideo.value.fileUrl ?? "",
                        eventCallBack: (event, totalDuration) async {})
                    : FileVideoWidget(
                        autoPlay: false,
                        url: controller.selectedVideo.value.fileUrl ?? "",
                        eventCallBack: (progress, totalDuration) async {});
      }),
      onPageBuilder: (context, controller) =>
          mainBodyBuilder(context, controller),
    );
  }

  List<Widget> mainBodyBuilder(
      BuildContext context, BlogsViewController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    return [
      Obx(() {
        return CourseBoxWithDate(
          extraWidget:
              Obx(() => controller.blogData.value.data?.audioUrl != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: controller.pageManager.playButtonNotifier.value ==
                              ButtonState.loading
                          ? playLoaderButton(height: 9, allPadding: 7)
                          : playIconButton(
                              bgColor: ColorResource.primaryColor,
                              iconColor: ColorResource.white,
                              onTap: controller.onPlayButton,
                              icon: ImageResource.instance.volumeIcon,
                              isPlaying: (controller
                                      .pageManager.playButtonNotifier.value ==
                                  ButtonState.playing),
                              height: (controller.pageManager.playButtonNotifier
                                          .value ==
                                      ButtonState.playing)
                                  ? 9
                                  : 14,
                              allPadding: (controller.pageManager
                                          .playButtonNotifier.value ==
                                      ButtonState.playing)
                                  ? 5
                                  : 3),
                    )
                  : const SizedBox()),
          showShare: false,
          dateAndTime: AppConstants.formatDateAndTime(
              controller.blogData.value.data?.createdAt),
          courseImage: controller.blogData.value.data?.image ?? "",
          courseName: controller.blogData.value.data?.title ?? "",
          rating: controller.blogData.value.data?.blogRating.toString() ?? "",
        );
      }),
      Obx(() => Visibility(
          visible: !controller.isDataLoading.value,
          child: UserAccessWidget(
              isPro: controller.blogData.value.data?.isFree != 1))),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault,
        ),
        child: Obx(() {
          double fontSize = screenWidth < 500 ? 12.0 : 18.0;
          return HtmlCommonWidget(fontSize: fontSize,
            htmlData: controller.blogData.value.data?.description ?? "",
            isDark: false,
          );
        }),
      ),
      Obx(() {
        return Visibility(
          visible: controller.moreLikeData.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: DimensionResource.marginSizeDefault),
            child: MoreLikeWidget(
              onTap: () {
                Get.toNamed(Routes.courseDetail, arguments: [
                  controller.blogData.value.data?.category?.title ?? "",
                  CourseDetailViewType.blogs,
                  controller.blogData.value.data?.description ?? "",
                  controller.blogData.value.data?.category?.id
                ]);
              },
              isBlog: true,
              onItemTap: (data) {
                controller.blogId.value = data.id.toString();
                controller.catId.value = data.categoryId.toString();
                // controller.getBlogById();
              },
              dataList: controller.moreLikeData,
            ),
          ),
        );
      }),
      Padding(
        padding:
            const EdgeInsets.only(bottom: DimensionResource.marginSizeDefault),
        child: Obx(() {
          if (controller.blogData.value.data?.id != null) {
            return AllRatingAndReviews(
              contest: context,
              enableVerticalMargin: true,
              isCourse: false,
              courseDatum: CourseDatum(
                  type: "blog",
                  id: controller.blogData.value.data?.id.toString(),
                  name: controller.blogData.value.data?.title ?? "",
                  rating:
                      controller.blogData.value.data?.blogRating.toString() ??
                          ""),
            );
          } else {
            return const SizedBox();
          }
        }),
      ),
    ];
  }
}

// CustomRenderMatcher tableMatcher() => (context) => context.tree.element?.localName == "table";
//
// CustomRender tableRender() =>
//     CustomRender.widget(widget: (context, buildChildren) {
//       return CssBoxWidget(
//         key: context.key,
//         style: context.style,
//         child: LayoutBuilder(
//           builder: (_, constraints) => layoutCells(context, constraints),
//         ),
//       );
//     });
//
// Widget layoutCells(RenderContext context, BoxConstraints constraints) {
//   logPrint("dsgsdgs 1");
//   final rows = <TableRowLayoutElement>[];
//   List<TrackSize> columnSizes = <TrackSize>[];
//   for (var child in context.tree.children) {
//     logPrint("dsgsdgs  ${child.runtimeType}");
//     if (child is TableStyleElement) {
//       // Map <col> tags to predetermined column track sizes
//       columnSizes = child.children
//           .where((c) => c.name == "col")
//           .map((c) {
//         final span = int.tryParse(c.attributes["span"] ?? "1") ?? 1;
//         final colWidth = c.attributes["width"];
//         return List.generate(span, (index) {
//           if (colWidth != null && colWidth.endsWith("%")) {
//             if (!constraints.hasBoundedWidth) {
//               // In a horizontally unbounded container; always wrap content instead of applying flex
//               return const FlexibleTrackSize(10);
//             }
//             final percentageSize =
//             double.tryParse(colWidth.substring(0, colWidth.length - 1));
//             return percentageSize != null && !percentageSize.isNaN
//                 ? FlexibleTrackSize(percentageSize * 0.01)
//                 : const FlexibleTrackSize(10);
//           } else if (colWidth != null) {
//             final fixedPxSize = double.tryParse(colWidth);
//             return fixedPxSize != null
//                 ? FixedTrackSize(fixedPxSize)
//                 : const FlexibleTrackSize(10);
//           } else {
//             return const FlexibleTrackSize(10);
//           }
//         });
//       })
//           .expand((element) => element)
//           .toList(growable: false);
//     } else if (child is TableSectionLayoutElement) {
//       rows.addAll(child.children.whereType());
//     } else if (child is TableRowLayoutElement) {
//       rows.add(child);
//     }else if(child is TextContentElement){
//       rows.addAll(child.children.whereType());
//     }
//   }
//
//   // All table rows have a height intrinsic to their (spanned) contents
//   final rowSizes =
//   List.generate(rows.length, (_) => const FlexibleTrackSize(10));
//
//   // Calculate column bounds
//   int columnMax = 0;
//   List<int> rowSpanOffsets = [];
//   for (final row in rows) {
//     final cols = row.children
//         .whereType<TableCellElement>()
//         .fold(0, (int value, child) => value + child.colspan) +
//         rowSpanOffsets.fold<int>(0, (int offset, child) => child);
//     columnMax = max(cols, columnMax);
//     rowSpanOffsets = [
//       ...rowSpanOffsets.map((value) => value - 1).where((value) => value > 0),
//       ...row.children
//           .whereType<TableCellElement>()
//           .map((cell) => cell.rowspan - 1),
//     ];
//   }
//
//   // Place the cells in the rows/columns
//   final cells = <GridPlacement>[];
//   final columnRowOffset = List.generate(columnMax, (_) => 0);
//   final columnColspanOffset = List.generate(columnMax, (_) => 0);
//   int rowi = 0;
//   for (var row in rows) {
//     int columni = 0;
//     for (var child in row.children) {
//       if (columni > columnMax - 1) {
//         break;
//       }
//       if (child is TableCellElement) {
//         while (columnRowOffset[columni] > 0) {
//           columnRowOffset[columni] = columnRowOffset[columni] - 1;
//           columni +=
//               columnColspanOffset[columni].clamp(1, columnMax - columni - 1);
//         }
//         cells.add(GridPlacement(
//           columnStart: columni,
//           columnSpan: min(child.colspan, columnMax - columni),
//           rowStart: rowi,
//           rowSpan: min(child.rowspan, rows.length - rowi),
//           child: CssBoxWidget(
//             style: child.style
//                 .merge(row.style), //TODO padding/decoration(color/border)
//             child: SizedBox.expand(
//               child: Container(
//                 alignment: child.style.alignment ??
//                     context.style.alignment ??
//                     Alignment.centerLeft,
//                 child: CssBoxWidget.withInlineSpanChildren(
//                   children: [context.parser.parseTree(context, child)],
//                   style: child.style, //TODO updated this. Does it work?
//                 ),
//               ),
//             ),
//           ),
//         ));
//         columnRowOffset[columni] = child.rowspan - 1;
//         columnColspanOffset[columni] = child.colspan;
//         columni += child.colspan;
//       }
//     }
//     while (columni < columnRowOffset.length) {
//       columnRowOffset[columni] = columnRowOffset[columni] - 1;
//       columni++;
//     }
//     rowi++;
//   }
//
//   // Create column tracks (insofar there were no colgroups that already defined them)
//   List<TrackSize> finalColumnSizes = columnSizes.take(columnMax).toList();
//   finalColumnSizes += List.generate(max(0, columnMax - finalColumnSizes.length),
//           (_) => const FlexibleTrackSize(10));
//
//   if (finalColumnSizes.isEmpty || rowSizes.isEmpty) {
//     // No actual cells to show
//     logPrint("dsgsdgs 2");
//     return const SizedBox();
//   }
//
//   return LayoutGrid(
//     gridFit: GridFit.loose,
//     columnSizes: finalColumnSizes,
//     rowSizes: rowSizes,
//     children: cells,
//   );
// }

// return Html(
// shrinkWrap: true,
// data: r""+ (controller.blogData.value.data?.description??"").replaceAll(r'\', r'').replaceAll("\r\n", "<br>").replaceAll("\n", "<br>"),
// customRenders: {
// tableMatcher():  CustomRender.widget(
// widget: (context, buildChildren) => SingleChildScrollView(
// physics: const ClampingScrollPhysics(),
// scrollDirection: Axis.vertical,
// child: SingleChildScrollView(
// physics: const ClampingScrollPhysics(),
// scrollDirection: Axis.horizontal,
// child: tableRender
//     .call()
//     .widget!
//     .call(context, buildChildren),
// ),
// )
// ),
// tagMatcher("img"): CustomRender.widget(widget: (context, child) {
// return Expanded(child: Padding(padding:const EdgeInsets.only(top: 10,bottom: 10),child: cachedNetworkImage(context.tree.element!.attributes["src"]??'',fit: BoxFit.cover,)));
// }),
// networkSourceMatcher(domains: ["flutter.dev"]):
// CustomRender.widget(widget: (context, child) {
// return FlutterLogo(size: 36);
// }),
// networkSourceMatcher(domains: ["mydomain.com"]):
// networkImageRender(
// headers: {"Custom-Header": "some-value"},
// altWidget: (alt) => Text(alt ?? ""),
// loadingWidget: () => const Text("Loading...")),
// // Custom placeholder image for broken links
// networkSourceMatcher():
// networkImageRender(altWidget: (_) => FlutterLogo()),
// },
// style: {
// 'figure':Style(margin: Margins.zero, padding:EdgeInsets.zero,width: Width.auto(),height: Height.auto()),
// 'img': Style(
// margin: Margins(top: Margin(10), bottom: Margin(10)),
// width: Width.auto(),
// height: Height.auto()),
// "table": Style(
// margin: Margins.zero,
// padding:EdgeInsets.zero,
// width: Width.auto(),
// height: Height.auto(),
// textAlign: TextAlign.start,
// border: const Border(
// bottom: BorderSide(color: Colors.grey),
// right: BorderSide(color: Colors.grey),
// left: BorderSide(color: Colors.grey),
// top: BorderSide(color: Colors.grey),
// ),
// ),
// "tr": Style(
// border: const Border(
// bottom: BorderSide(color: Colors.grey,)
// ,right: BorderSide(color: Colors.grey)),
// ),
// "th": Style(
// padding: const EdgeInsets.all(6),
// ),
//
// "td": Style(
// padding: const EdgeInsets.all(6),
// alignment: Alignment.topLeft,
//
// ),
// },
// onLinkTap:  (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) async{
// if (!await launchUrl(Uri.parse(url!))) throw 'Could not launch $url';
// },
// );