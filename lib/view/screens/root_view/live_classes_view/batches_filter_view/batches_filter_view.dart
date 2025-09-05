import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/service/utils/Session.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/video_course_detail_view/video_course_detail_view.dart';
import '../../../../../model/services/auth_service.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../widgets/button_view/common_button.dart';
import '../../../../widgets/button_view/radio_button_widget.dart';
import '../../../../widgets/log_print/log_print_condition.dart';

class LiveFilterScreen extends StatefulWidget {
  final bool isPastFilter;
  final bool isHideCategory;
  final bool isHideLanguage;
  final bool isHideLevel;
  final bool isHideTime;
  final bool isHideTeacher;
  final bool isHideRating;
  final bool isHideSubscription;
  final bool isForCoursesTab;
  final String? title;
  final DropDownData? selectedSubscription;
  final List<DropDownData> listOFSelectedDuration;
  final List<RatingDataVal> listOFSelectedRating;
  final List<DropDownData> listOfSelectedTeacher;
  final List<DropDownData> listOFSelectedLang;
  final List<DropDownData> listOFSelectedLevel;
  final List<DropDownData> listOFSelectedCat;
  final List<DropDownData> listOFSelectedDays;
  final List<DropDownData>? listOFMentorShip;
  final Function(Map<String, dynamic> map) onApply;
  final Function(Map<String, dynamic>)? onClear;
  final String? type;
  final int? indexOfTab;
  final bool? mentorship;

  const LiveFilterScreen({
    Key? key,
    required this.isPastFilter,
    required this.onApply,
    this.onClear,
    this.selectedSubscription,
    required this.listOFSelectedRating,
    required this.listOfSelectedTeacher,
    this.title,
    this.isHideCategory = false,
    this.isHideLanguage = true,
    this.isHideTeacher = true,
    this.isHideLevel = false,
    this.isHideRating = false,
    this.isHideTime = false,
    this.isForCoursesTab = false,
    this.listOFMentorShip,
    required this.listOFSelectedDuration,
    required this.listOFSelectedLang,
    required this.listOFSelectedCat,
    required this.listOFSelectedLevel,
    required this.listOFSelectedDays,
    this.isHideSubscription = true,
    this.type,
    this.indexOfTab, this. mentorship,
  }) : super(key: key);

  @override
  State<LiveFilterScreen> createState() => _LiveFilterScreenState();
}

class _LiveFilterScreenState extends State<LiveFilterScreen> {
  late ClassesFilterController controller;
  DropDownData? selectedSubscription;

  @override
  void initState() {
    if (widget.selectedSubscription?.optionName != null) {
      selectedSubscription = widget.selectedSubscription;
    }

    controller = Get.put(ClassesFilterController(
      selectedSubscription: selectedSubscription,
      listOSelectedCat: widget.listOFSelectedCat,
    ));

    controller.selectedLevel.clear();
    controller.selectedLevel.addAll(widget.listOFSelectedLevel);

    controller.listOFSelectedDays.clear();
    controller.listOFSelectedDays.addAll(widget.listOFSelectedDays);

    controller.listOFMentorShip.clear();
    controller.listOFMentorShip.addAll(widget.listOFMentorShip ?? []);

    controller.selectedRating.clear();
    if (widget.listOFSelectedRating.isEmpty) {
      controller.selectedRating
          .add(RatingDataVal(ratingName: "All", ratingValue: "all"));
    } else {
      controller.selectedRating.addAll(widget.listOFSelectedRating);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomScrollView(
        primary: true,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: DimensionResource.marginSizeSmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShadowContainer(
                            onTap: () {},
                            isCircle: true,
                            text: "",
                            textColor: ColorResource.white,
                            color: ColorResource.white,
                          ),
                          Text(
                            widget.title ??
                                (widget.isPastFilter
                                    ? "Class Recording Filter"
                                    : "Live Class Filter"),
                            style: StyleResource.instance.styleSemiBold(
                                fontSize: DimensionResource.fontSizeSmall),
                          ),
                          ShadowContainer(
                            onTap: () {
                              if (widget.onClear != null) {
                                widget.onClear!(controller.onClearAll());
                              }
                            },
                            isCircle: true,
                            text: "CLEAR ALL",
                            textColor: ColorResource.redColor,
                            color: ColorResource.mateRedColor,
                          )
                        ],
                      ),
                      const SizedBox(height: DimensionResource.marginSizeSmall),
                      if (widget.indexOfTab != 0)
                        Visibility(
                          visible: true,
                          child: CustomLabeledDropDown(
                            title: "By Months",
                            isLoading: controller.isDaysLoading.value,
                            listOfData: widget.type != 'past'
                                ? controller.upcomingBatchesDaysList
                                : controller.batchesDaysList,
                            listOfSelectedData: widget.listOFSelectedDays,
                            selectedList: (val) {
                              controller.isDaysLoading.value = true;
                              if (controller.listOFSelectedDays
                                  .any((element) => element.id == val.id)) {
                                controller.listOFSelectedDays.removeWhere(
                                    (element) => element.id == val.id);
                              } else {
                                controller.listOFSelectedDays.add(val);
                                Session.setItem(val.optionName.toString());
                                logPrint(
                                    "getDateFilterData select date ${val.optionName}");
                              }
                              controller.isDaysLoading.value = false;
                            },
                          ),
                        ),
                      if (widget.mentorship==true )
                        Visibility(
                          visible: true,
                          child: CustomLabeledDropDown(
                            title: "Mentorship Type",
                            isLoading: controller.isMentorShipTypeLoading.value,
                            listOfData: controller.mentorShipList,
                            listOfSelectedData: widget.listOFMentorShip ?? [],
                            selectedList: (val) {
                              controller.isMentorShipTypeLoading.value = true;
                              if (controller.listOFMentorShip
                                  .any((element) => element.id == val.id)) {
                                controller.listOFMentorShip.removeWhere(
                                    (element) => element.id == val.id);
                              } else {
                                controller.listOFMentorShip.add(val);
                                Session.setItem(val.optionName.toString());
                                logPrint(
                                    "Mentorship select date ${val.optionName}");
                              }
                              controller.isMentorShipTypeLoading.value = false;
                            },
                          ),
                        ),
                      const SizedBox(height: DimensionResource.marginSizeSmall),
                      Visibility(
                        visible: !widget.isHideCategory,
                        child: CustomLabeledDropDown(
                          title: "By Category",
                          isLoading: controller.isCategoryLoading.value,
                          listOfData: controller.categoryList,
                          listOfSelectedData: widget.listOFSelectedCat,
                          selectedList: (val) {
                            controller.isCategoryLoading.value = true;
                            if (controller.listOFSelectedCat
                                .any((element) => element.id == val.id)) {
                              controller.listOFSelectedCat.removeWhere(
                                  (element) => element.id == val.id);
                            } else {
                              controller.listOFSelectedCat.add(val);
                            }
                            controller.isCategoryLoading.value = false;
                          },
                        ),
                      ),
                      Visibility(
                        visible: !widget.isHideTeacher,
                        child: CustomRadioDropdown(
                          title: 'By Teacher',
                          isLoading: controller.isTeacherLoading.value,
                          listOfData: controller.teacherList,
                          listOfSelectedData: widget.listOfSelectedTeacher,
                          selectedList: (val) {
                            controller.isTeacherLoading.value = true;
                            if (controller.listOfSelectedTeacher
                                .any((element) => element.id == val.id)) {
                              controller.listOfSelectedTeacher.removeWhere(
                                  (element) => element.id == val.id);
                            } else {
                              controller.listOfSelectedTeacher.clear();
                              controller.listOfSelectedTeacher.add(val);
                            }
                            controller.isTeacherLoading.value = false;
                          },
                        ),
                      ),
                      Visibility(
                        visible: !widget.isHideLevel,
                        child: levelSection(controller),
                      ),
                      Visibility(
                        visible: !widget.isHideTime,
                        child: CustomLabeledDropDown(
                          isLoading: false,
                          title: "By Time Duration",
                          listOfData: controller.durationList,
                          listOfSelectedData: widget.listOFSelectedDuration,
                          selectedList: (val) {
                            if (controller.listOFSelectedDuration
                                .any((element) => element.id == val.id)) {
                              controller.listOFSelectedDuration.removeWhere(
                                  (element) => element.id == val.id);
                            } else {
                              controller.listOFSelectedDuration.add(val);
                            }
                            logPrint("selected time $val");
                          },
                        ),
                      ),
                      Visibility(
                        visible: !widget.isHideRating,
                        child: ratingSection(controller),
                      ),
                      Visibility(
                        visible: !widget.isHideSubscription,
                        child: subscriptionSection(controller),
                      ),
                    ],
                  ),
                ),
                CommonButton(
                  text: "APPLY",
                  loading: false,
                  onPressed: () async {
                    final hasSelectedFilters =
                        controller.listOFSelectedCat.isNotEmpty ||
                            controller.listOFMentorShip.isNotEmpty ||
                            controller.listOFSelectedDays.isNotEmpty;

                    if (hasSelectedFilters) {
                      await Get.find<AuthService>()
                          .saveClassLevel(controller.selectedLevel);
                      Get.back();
                      widget.onApply(controller.onApply());
                      logPrint(
                          "listOFMentorShip onApply ${controller.listOFMentorShip.first.optionName}");
                    }
                  },
                  radius: 0,
                  color: (controller.listOFSelectedCat.isEmpty &&
                          controller.listOFSelectedDays.isEmpty &&
                          controller.listOFMentorShip.isEmpty)
                      ? ColorResource.textColor_8
                      : ColorResource.primaryColor,
                  style: StyleResource.instance
                      .styleSemiBold(color: ColorResource.white),
                ),
                const SizedBox(height: 85),
                Container(
                  height: Platform.isIOS ? 10 : 0,
                  color: ColorResource.primaryColor,
                )
              ],
            ),
          )
        ],
      );
    });
  }

  Widget ratingSection(ClassesFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "By Rating",
          style: StyleResource.instance
              .styleMedium(fontSize: DimensionResource.fontSizeDefault - 0.5),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall + 3,
        ),
        Obx(() {
          return Wrap(
            spacing: DimensionResource.marginSizeSmall,
            runSpacing: DimensionResource.marginSizeSmall,
            children: List.generate(controller.ratingData.length, (index) {
              RatingDataVal data = controller.ratingData[index];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ContainerButton(
                    onPressed: () {
                      if (data.ratingValue == "all") {
                        controller.selectedRating.clear();
                        try {
                          for (RatingDataVal? dataa in controller.ratingData) {
                            controller.selectedRating.add(RatingDataVal(
                                ratingValue: dataa?.ratingValue.toString(),
                                ratingName: dataa?.ratingName?.toLowerCase()));
                          }
                        } catch (e) {
                          logPrint("message fd $e");
                        }
                      } else {
                        if (controller.selectedRating.length >= 4 &&
                            !controller.selectedRating.any((element) =>
                                element.ratingValue ==
                                data.ratingValue.toString())) {
                          logPrint("selected level all");
                          if (controller.selectedRating
                              .any((element) => element.ratingValue == "all")) {
                            logPrint("selected level 0");
                            controller.selectedRating.removeWhere(
                                (element) => element.ratingValue == "all");
                            if (controller.selectedRating.any((element) =>
                                element.ratingValue ==
                                data.ratingValue.toString())) {
                              controller.selectedRating.removeWhere((element) =>
                                  element.ratingValue ==
                                  data.ratingValue.toString());
                            } else {
                              controller.selectedRating.add(RatingDataVal(
                                  ratingValue: data.ratingValue.toString(),
                                  ratingName: data.ratingName?.toLowerCase()));
                            }
                          } else {
                            controller.selectedRating.clear();
                            try {
                              for (RatingDataVal dataa
                                  in controller.ratingData) {
                                controller.selectedRating.add(RatingDataVal(
                                    ratingValue: dataa.ratingValue.toString(),
                                    ratingName:
                                        dataa.ratingName?.toLowerCase()));
                              }
                            } catch (e) {
                              logPrint("message fd $e");
                            }
                          }
                        } else {
                          if (controller.selectedRating
                              .any((element) => element.ratingValue == "all")) {
                            controller.selectedRating.removeWhere(
                                (element) => element.ratingValue == "all");
                          }
                          if (controller.selectedRating.any((element) =>
                              element.ratingValue ==
                              data.ratingValue.toString())) {
                            controller.selectedRating.removeWhere((element) =>
                                element.ratingValue ==
                                data.ratingValue.toString());
                          } else {
                            controller.selectedRating.add(RatingDataVal(
                                ratingValue: data.ratingValue.toString(),
                                ratingName: data.ratingName?.toLowerCase()));
                          }
                        }
                      }
                    },
                    text: data.ratingName,
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeSmall,
                        vertical: DimensionResource.marginSizeExtraSmall),
                    radius: 7,
                    color: controller.selectedRating.any((element) =>
                            element.ratingValue == data.ratingValue)
                        ? ColorResource.primaryColor
                        : ColorResource.white,
                    borderColor: ColorResource.borderColor.withOpacity(0.5),
                    fontSize: DimensionResource.fontSizeExtraSmall + 1,
                    fontColor: controller.selectedRating.any((element) =>
                            element.ratingValue == data.ratingValue)
                        ? ColorResource.white
                        : ColorResource.secondaryColor,
                  ),
                ],
              );
            }),
          );
        }),
        const SizedBox(
          height: DimensionResource.marginSizeLarge,
        ),
      ],
    );
  }

  Widget subscriptionSection(ClassesFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "By Pro ",
          style: StyleResource.instance
              .styleMedium(fontSize: DimensionResource.fontSizeDefault - 0.5),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall + 3,
        ),
        Row(
          children: List.generate(controller.subscriptionData.length, (index) {
            String data = controller.subscriptionData[index];
            return InkWell(
              onTap: () {
                controller.selectedSubscriptionFilter.value = index;
                controller.selectedSub.value = DropDownData(
                    id: (index + 1).toString(), optionName: data.toLowerCase());
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    right: DimensionResource.marginSizeLarge,
                    bottom: DimensionResource.marginSizeSmall),
                child: RadioButtonWidget(
                    text: data,
                    isActive:
                        controller.selectedSubscriptionFilter.value == index),
              ),
            );
          }),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeLarge,
        ),
      ],
    );
  }

  Widget levelSection(ClassesFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          "By Level",
          style: StyleResource.instance
              .styleMedium(fontSize: DimensionResource.fontSizeDefault - 0.5),
        ),
        const SizedBox(height: DimensionResource.marginSizeSmall + 3),
        Row(
          children: List.generate(controller.levelData.length, (index) {
            DropDownData data = controller.levelData[index];

            return GestureDetector(
              onTap: () {
                if (widget.isForCoursesTab) {
                  controller.selectedLevel.clear();
                  controller.selectedLevel.add(DropDownData(
                      id: data.id.toString(),
                      optionName: data.optionName?.toLowerCase()));
                  return;
                }

                if (data.id == 0.toString()) {
                  try {
                    controller.selectedLevel.clear();
                    for (DropDownData? dataa in controller.levelData) {
                      controller.selectedLevel.add(DropDownData(
                          id: dataa?.id.toString(),
                          optionName: dataa?.optionName?.toLowerCase()));
                    }
                  } catch (e) {
                    logPrint('check error $e');
                  }
                } else {
                  if (!controller.selectedLevel
                      .any((element) => element.id == data.id.toString())) {
                    if (controller.selectedLevel.length == 2) {
                      try {
                        controller.selectedLevel.clear();
                        for (DropDownData? dataa in controller.levelData) {
                          controller.selectedLevel.add(DropDownData(
                              id: dataa?.id.toString(),
                              optionName: dataa?.optionName?.toLowerCase()));
                        }
                      } catch (e) {
                        logPrint('check error $e');
                      }
                    } else {
                      controller.selectedLevel.add(DropDownData(
                          id: data.id.toString(),
                          optionName: data.optionName?.toLowerCase()));
                    }
                  } else {
                    controller.selectedLevel.removeWhere((element) =>
                        element.id == data.id.toString() ||
                        element.id == 0.toString());
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    right: DimensionResource.marginSizeExtraSmall + 3,
                    bottom: DimensionResource.marginSizeSmall),
                child: ContainerButton(
                  text: data.optionName ?? "",
                  radius: 7,
                  color: controller.selectedLevel
                          .any((element) => element.id == data.id.toString())
                      ? ColorResource.primaryColor
                      : ColorResource.white,
                  borderColor: controller.selectedLevel
                          .any((element) => element.id == data.id.toString())
                      ? ColorResource.primaryColor
                      : ColorResource.borderColor,
                  borderWidth: 0.4,
                  onPressed: null,
                  textStyle: StyleResource.instance.styleRegular(
                      fontSize: DimensionResource.fontSizeExtraSmall,
                      color: controller.selectedLevel.any(
                              (element) => element.id == data.id.toString())
                          ? ColorResource.white
                          : ColorResource.secondaryColor),
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeSmall,
                      vertical: DimensionResource.marginSizeExtraSmall),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
