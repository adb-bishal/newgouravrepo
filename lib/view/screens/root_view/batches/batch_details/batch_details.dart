import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/view/screens/base_view/base_view_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/batch_details/detail_tabs/batch_class_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/batch_details/detail_tabs/batch_class_view2.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../widgets/no_data_found/no_data_found.dart';

class BatchDetails extends StatefulWidget {
  const BatchDetails({super.key});

  @override
  State<BatchDetails> createState() => _BatchDetailsState();
}

class _BatchDetailsState extends State<BatchDetails>
    with TickerProviderStateMixin {
  TabController? tabController;
  BatchData? data;
  List<SubBatch>? subBatches;
  RxList<Tab>? tabs;
  bool isPast = false;

  @override
  void initState() {
    if (Get.arguments != null) {
      data = Get.arguments[0];

      if ((Get.arguments as List).length > 1) {
        isPast = Get.arguments[1];
        logPrint(isPast);
      }

      if ((Get.arguments as List).length > 2) {
        subBatches = Get.arguments[2];
      }
    }
    tabs = [
      if (!isPast!)
        const Tab(
          child: Text('Upcoming Classes'),
        ),
      const Tab(
        child: Text('Past Recordings'),
      )
    ].obs;

    // List.generate(
    //     subBatches?.length ?? data?.subBatch?.length ?? 0,
    //     (index) => Tab(
    //             child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             if (data?.subBatch?[index].startDate != "Past Classes")
    //               const Text(
    //                 'Starting  from',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontSize: 10),
    //               ),
    //             Text(data?.subBatch?[index].startDate != "Past Classes"
    //                 ? AppConstants.formatSmallDate(DateTime.parse(
    //                     subBatches?[index].startDate ??
    //                         data?.subBatch?[index].startDate ??
    //                         ''))
    //                 : data?.subBatch?[index].startDate ?? "")
    //           ],
    //         ))).obs;

    tabController = TabController(length: tabs?.length ?? 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Platform.isIOS ? ColorResource.white : Colors.transparent,
      child: SafeArea(
        top: false,
        bottom: false,
        //bottom:Platform.isIOS ? true:false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: TitleBarCentered(
              isBatch: true,
              titleText: data?.title ?? '',
            ),
            backgroundColor: ColorResource.backGroundColor,
            leading: InkWell(
              onTap: () => Get.back(),
              child: const SizedBox(
                height: 32,
                width: 32,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorResource.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          backgroundColor: ColorResource.backGroundColor,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: _mainPageBuilder(context, isPast ?? false)),
          ),
          //bottomNavigationBar:bottomBarPerimeter!=null ? bottomBarWidget(bottomBarPerimeter!,controller) : const SizedBox(),
        ),
      ),
    );
  }

  Widget _mainPageBuilder(BuildContext context, bool isPast) {
    return Obx(
      () {
        tabController = TabController(length: tabs?.length ?? 0, vsync: this);
        return tabs?.isEmpty ?? true
            ? const SizedBox(
                height: 400,
                child: NoDataFound(
                  showText: true,
                  text: "Batch dates are being Set Up for You!",
                ))
            : Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 0,
                    bottom: TabBar(
                      tabs: tabs ?? [],
                      controller: tabController,
                    ),
                  ),
                  body: TabBarView(controller: tabController, children:
                      //List.generate(tabs?.length ?? 0, (index) {
                      //   return BatchClassView(
                      //     batchDateId: data?.subBatch?[0].id ?? 0,
                      //     isPast: isPast,
                      //   );
                      // }),

                      [
                    BatchClassView(
                      batchDateId: data?.subBatch?[0].id ?? 0,
                      isPast: isPast,
                    ),
                    if (!isPast)
                      BatchClassView2(
                        batchDateId: data?.subBatch?[0].id ?? 0,
                        isPast: !isPast,
                      ),
                  ]),
                ),
              );
      },
    );
  }
}
