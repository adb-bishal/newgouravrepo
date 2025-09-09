import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../model/network_calls/api_helper/provider_helper/root_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/utils/app_constants.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../service/page_manager.dart';

class VideoBaseView<T extends GetxController> extends GetView {
  final T viewControl;
  final double videoViewHeight;
  final RxBool isDataLoading;
  final bool pinned;
  final String screenType;
  final List<Widget> Function(BuildContext context, T value) actionBuilder;
  final List<Widget> Function(BuildContext context, T value) onPageBuilder;
  final Widget Function(BuildContext context, T value) onVideoBuilder;
  final Widget Function(BuildContext context, T value)? bottomNavigationBar;
  final Function(BuildContext context, T value) onBackClicked;

  VideoBaseView({
    Key? key,
    this.videoViewHeight = 200,
    this.bottomNavigationBar,
    required this.actionBuilder,
    required this.viewControl,
    required this.onBackClicked,
    required this.onPageBuilder,
    required this.onVideoBuilder,
    required this.isDataLoading,
    this.pinned = true,
    required this.screenType,
    double? customHeight,
  }) : super(key: key);

  String tagValue = "";
  checkScreenType() {
    switch (screenType) {
      case AppConstants.blogRedirect:
        tagValue = AppConstants.instance.blogId.value;
        break;
      case AppConstants.videoRedirect:
        tagValue = AppConstants.instance.singleCourseId.value;
        break;
      case AppConstants.liveClass:
        tagValue = AppConstants.instance.liveId.value;
        break;
      case AppConstants.batchClass:
        tagValue = AppConstants.instance.batchId.value;
        break;
      default:
        tagValue = AppConstants.instance.videoCourseId.value;
        break;
    }
  }

  //String tagValue = "";
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dynamicHeight = screenWidth < 500 ? 200.0 : 300.0;

    checkScreenType();
    Get.put(
      viewControl,
      tag: tagValue,
    );
    return OrientationChangeDetector(
      onPageBuilder: (context) => Container(
        color: ColorResource.black,
        child: SafeArea(
          top: false,
          right: false,
          left: false,
          bottom: Platform.isIOS ? false : true,
          child: OrientationBuilder(builder: (context, orientation) {
            return SafeArea(
              top: true,
              bottom: true,
              left: false,
              right: false,
              child: Scaffold(
                backgroundColor: ColorResource.white,
                bottomNavigationBar: bottomNavigationBar != null
                    ? bottomNavigationBar!(context, Get.find<T>(tag: tagValue))
                    : null,
                body: CustomScrollView(
                  primary: true,
                  shrinkWrap: false,
                  physics: orientation == Orientation.portrait
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  //physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: orientation == Orientation.landscape
                          ? MediaQuery.of(context).size.height
                          : dynamicHeight, // Adjusted height
                      collapsedHeight: orientation == Orientation.landscape
                          ? MediaQuery.of(context).size.height
                          : dynamicHeight,
                      toolbarHeight: 45,
                      titleSpacing: DimensionResource.marginSizeDefault,
                      title: Visibility(
                        visible: !(orientation == Orientation.landscape),
                        child: SizedBox(
                          // height: MediaQuery.of(context).size.height * .25,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                splashColor: Colors.transparent,
                                child: SizedBox(
                                    height: 45,
                                    width: 50,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.arrow_back_ios_sharp,
                                          color: ColorResource.white,
                                          size: screenWidth < 500 ? 20 : 36,
                                        ))),
                              ),
                              Row(
                                children: actionBuilder(
                                    context, Get.find<T>(tag: tagValue)),
                              )
                              // InkWell(
                              //   onTap: (){
                              //    // Get.back();
                              //   },
                              //   child: SizedBox(
                              //       height: 45,
                              //       width: 50,
                              //       child: Align(
                              //           alignment: Alignment.centerRight,
                              //           child: Image.asset(ImageResource.instance.stretchIcon,color: ColorResource.white,height: 15,))),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      floating: false,
                      pinned: pinned,
                      backgroundColor: ColorResource.black,
                      elevation: 3,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        collapseMode: CollapseMode.parallax,
                        background: Container(
                          width: double.infinity,
                          height: 350,
                          color: ColorResource.black,
                          child: onVideoBuilder(
                              context, Get.find<T>(tag: tagValue)),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                        EdgeInsets.only(top: screenWidth < 500 ? 0.0 : 12),
                        child: Wrap(
                            children: onPageBuilder(
                                context, Get.find<T>(tag: tagValue))),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class OrientationChangeDetector extends StatefulWidget {
  final Widget Function(
      BuildContext context,
      ) onPageBuilder;
  final bool fromRoot;
  const OrientationChangeDetector(
      {Key? key, required this.onPageBuilder, this.fromRoot = false})
      : super(key: key);

  @override
  State<OrientationChangeDetector> createState() =>
      _OrientationChangeDetectorState();
}

class _OrientationChangeDetectorState extends State<OrientationChangeDetector>
    with WidgetsBindingObserver {
  RootProvider rootProvider = getIt();
  int countVal = 0;

  // @override
  // void didChangeMetrics() {
  //   final orientation = MediaQuery.of(Get.context!).orientation;
  //   EasyDebounce.debounce(
  //       countVal.toString(), const Duration(milliseconds: 100), () {
  //     if (orientation == Orientation.landscape) {
  //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //     } else {
  //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //           overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  //     }
  //     setState(() {
  //       countVal++;
  //     });
  //   });
  //   super.didChangeMetrics();
  // }

  postUserActivity() async {
    // isDataLoading(true);
    DateTime activeTime =
    await Get.find<AuthService>().getUserTime(isActive: true);
    DateTime inActiveTime =
    await Get.find<AuthService>().getUserTime(isActive: false);
    logPrint("activeTime $activeTime");
    logPrint("inActiveTime $inActiveTime");
    String date = DateFormat("yyyy-MM-dd").format(activeTime);
    Duration duration = inActiveTime.difference(activeTime);

    if (activeTime.year != 1999 && duration.inMinutes > 0) {
      await rootProvider.postUserActivity(
          data: [
            {"date": date, "time": duration.inMinutes}
          ],
          onError: (message, errorMap) {
            //toastShow(message: message);
            //isDataLoading(false);
          },
          onSuccess: (message, json) async {
            await Get.find<AuthService>().removeUserTime(isActive: true);
            await Get.find<AuthService>().removeUserTime(isActive: false);
            await Get.find<AuthService>().saveUserTime(isActive: true);
            // dashboardData.value = DashboardModel.fromJson(json!);
            // isDataLoading(false);
          });
    }
  }

  void startIsolate() async {
    logPrint("startIsolate");
    await FlutterIsolate.spawn<Map<String, dynamic>>(isolateUserEntry, {});
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    logPrint(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      Get.find<AuthService>().saveUserTime(isActive: false);
      logPrint(
          "isInActive ${await Get.find<AuthService>().getUserTime(isActive: false)}");
      logPrint(
          "isActive ${await Get.find<AuthService>().getUserTime(isActive: true)}");
      if (state == AppLifecycleState.detached) {
        startIsolate();
        getIt<PageManager>().currentPlayingMedia.value =
        const MediaItem(id: "", title: "");
        getIt<PageManager>().stop();
        getIt<PageManager>().dispose();
      }
    } else {
      EasyDebounce.debounce(
          countVal.toString(), const Duration(milliseconds: 100), () {
        postUserActivity();
        Get.find<AuthService>().saveUserTime(isActive: true);
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (widget.fromRoot) {
      postUserActivity();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: widget.onPageBuilder(context)));
  }
}

@pragma('vm:entry-point')
Future<void> isolateUserEntry(Map<String, dynamic> map) async {
  logPrint("isolateEntry");
  try {
    Get.put(AuthService());
    Get.find<AuthService>().saveUserTime(isActive: false);
    if (Platform.isAndroid) {
      exit(0);
    }

    // getIt<PageManager>().currentPlayingMedia.value = const MediaItem(id: "", title: "");
    // getIt<PageManager>().stop();
    // getIt<PageManager>().dispose();
//Get.find<VideoCourseDetailController>().onDownload();
  } catch (e) {
    logPrint("eee $e");
  }
}
