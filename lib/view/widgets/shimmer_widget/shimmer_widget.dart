import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import '../../../model/utils/color_resource.dart';

class ShimmerEffect {
  static ShimmerEffect? _instance;

  static ShimmerEffect get instance => _instance ??= ShimmerEffect._init();

  ShimmerEffect._init();

  /// Common shimmer for all pages.
  Widget commonPageGridShimmer({int length = 10, double? itemHeight}) => Wrap(
    children: List.generate(
      (length / 2).ceil(),
          (index) => Row(
          children: List.generate(
              2,
                  (index) => Expanded(
                child: Container(
                    height: itemHeight ?? 140,
                    margin: const EdgeInsets.all(8),
                    child: _shimer()),
              ))),
    ),
  );

  /// Loading Shimmer for Home Screen
  Widget homeLoader() {
    double textHeight = 20;
    double quizWidgetHeight = 70;
    double updateCardHeight = 110;
    double liveclassCardHeight = 150;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          padding: const EdgeInsets.only(left: 16),
          height: textHeight,
          width: 160,
          child: _shimer(),
        ),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Wrap(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.only(left: 16),
                height: quizWidgetHeight,
                width: 280,
                child: _shimer(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.only(left: 16),
                height: quizWidgetHeight,
                width: 280,
                child: _shimer(),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: updateCardHeight,
          child: _shimer(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: textHeight,
                width: 80,
                child: _shimer(),
              ),
              SizedBox(
                height: textHeight,
                width: 50,
                child: _shimer(),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: liveclassCardHeight,
          child: _shimer(),
        ),
      ],
    );
  }

  Widget becomeAPro(context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: _shimer(),
    );
  }

  Widget pastRecordingOneTileLoader() {
    double containerHeight = 155;
    double imageWidth = 110;
    double textHeight = 15;
    double buttonHeight = 24;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
          height: containerHeight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 2)),
            child: Row(children: [
              SizedBox(
                  width: imageWidth,
                  child: _shimer(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          ),
                          SizedBox(
                            width: 40,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 120,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 50,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                          const SizedBox(width: 16),
                          /* Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),*/
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          )),
    );
  }

  Widget pastRecordingLoader() {
    double containerHeight = 155;
    double imageWidth = 110;
    double textHeight = 15;
    double buttonHeight = 40;
    return GridView.builder(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        crossAxisSpacing: 18,
        childAspectRatio: 2.0,
        mainAxisSpacing: 8),
      shrinkWrap: true,
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
          height: containerHeight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 2)),
            child: Row(children: [
              SizedBox(
                  width: imageWidth,
                  child: _shimer(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          ),
                          SizedBox(
                            width: 40,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 120,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 50,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                          const SizedBox(width: 16),
                          /*    Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),*/
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          )),
    );
  }


  Widget allBatchesLoaderPastForTabletView() {
    double textHeight = 10;
    double titleHeight = 15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          width: 200,
          child: _shimer(),
        ),
        const SizedBox(
          height: 16,
        ),

        // Combine the two Row widgets into one Row for horizontal layout
        ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 200,
                            width: 372,
                            margin: const EdgeInsets.all(
                                DimensionResource.marginSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(DimensionResource
                                    .appDefaultContainerRadius),
                              ),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: DimensionResource
                                          .paddingSizeExtraSmall,
                                      left: DimensionResource
                                          .paddingSizeExtraSmall,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: DimensionResource
                                                .paddingSizeDefault,
                                          ),
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: double.infinity,
                                          child: _shimer(),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: 120,
                                          child: _shimer(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: DimensionResource
                                              .paddingSizeSmall,
                                          horizontal: DimensionResource
                                              .paddingSizeDefault,
                                        ),
                                        height: 120,
                                        width: 110,
                                        child: _shimer(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 1),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusDefault),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      DimensionResource.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                  DimensionResource.paddingSizeSmall,
                                  vertical:
                                  DimensionResource.paddingSizeExtraSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                  border: Border(
                                    top: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: SizedBox(
                                  height: textHeight,
                                  width: 100,
                                  child: _shimer(),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                    DimensionResource.paddingSizeSmall,
                                    vertical:
                                    DimensionResource.paddingSizeExtraSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 200,
                            width: 372,
                            margin: const EdgeInsets.all(
                                DimensionResource.marginSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(DimensionResource
                                    .appDefaultContainerRadius),
                              ),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: DimensionResource
                                          .paddingSizeExtraSmall,
                                      left: DimensionResource
                                          .paddingSizeExtraSmall,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: DimensionResource
                                                .paddingSizeDefault,
                                          ),
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: double.infinity,
                                          child: _shimer(),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: 120,
                                          child: _shimer(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: DimensionResource
                                              .paddingSizeSmall,
                                          horizontal: DimensionResource
                                              .paddingSizeDefault,
                                        ),
                                        height: 120,
                                        width: 110,
                                        child: _shimer(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 1),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusDefault),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      DimensionResource.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                  DimensionResource.paddingSizeSmall,
                                  vertical:
                                  DimensionResource.paddingSizeExtraSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                  border: Border(
                                    top: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: SizedBox(
                                  height: textHeight,
                                  width: 100,
                                  child: _shimer(),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                    DimensionResource.paddingSizeSmall,
                                    vertical:
                                    DimensionResource.paddingSizeExtraSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 372,
                          margin: const EdgeInsets.only(
                              bottom: DimensionResource.marginSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(
                                  DimensionResource.appDefaultContainerRadius),
                            ),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!),
                              left: BorderSide(color: Colors.grey[300]!),
                              right: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.paddingSizeSmall,
                            vertical: DimensionResource.paddingSizeExtraSmall,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: textHeight * 2,
                                    width: 80,
                                    child: _shimer(),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: titleHeight,
                                    width: 100,
                                    child: _shimer(),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(
                                    DimensionResource.marginSizeExtraSmall),
                                height: textHeight * 4,
                                width: 210,
                                child: _shimer(),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 376,
                          margin: const EdgeInsets.only(
                              bottom: DimensionResource.marginSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(
                                  DimensionResource.appDefaultContainerRadius),
                            ),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!),
                              left: BorderSide(color: Colors.grey[300]!),
                              right: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.paddingSizeSmall,
                            vertical: DimensionResource.paddingSizeExtraSmall,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: textHeight * 2,
                                    width: 80,
                                    child: _shimer(),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: titleHeight,
                                    width: 100,
                                    child: _shimer(),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(
                                    DimensionResource.marginSizeExtraSmall),
                                height: textHeight * 4,
                                width: 210,
                                child: _shimer(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                /*  Center(
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 400,
                        margin: const EdgeInsets.all(
                            DimensionResource.marginSizeExtraSmall),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(
                                DimensionResource.appDefaultContainerRadius),
                          ),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 12,
                              child: _shimer(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 120,
                              height: 12,
                              child: _shimer(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),*/
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ],
    );
  }


  Widget subscriptionLoader(context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.paddingSizeDefault),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 45,
              width: 250,
              child: _shimer(),
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: _shimer(),
            ),
            const SizedBox(
              height: DimensionResource.marginSizeExtraSmall,
            ),
            SizedBox(
              width: 235,
              height: 125,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      height: 20,
                      width: 200,
                      child: _shimer(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                    child: Divider(
                      color: ColorResource.grey_2,
                    )),
                Container(
                    width: 100,
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorResource.grey_2),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(DimensionResource.roundButtonRadius)),
                    ),
                    child: _shimer()),
                const Expanded(
                    child: Divider(
                      color: ColorResource.grey_2,
                    )),
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        right: DimensionResource.paddingSizeSmall,
                        top: DimensionResource.paddingSizeSmall,
                        bottom: DimensionResource.paddingSizeSmall,
                      ),
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: ColorResource.grey, width: 0.25),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                              DimensionResource.borderRadiusDefault),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                DimensionResource.paddingSizeDefault),
                            child: Container(
                              height: 33,
                              width: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _shimer()),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: DimensionResource.paddingSizeDefault),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 20,
                                    child: _shimer(),
                                  ),
                                  const SizedBox(
                                    height:
                                    DimensionResource.marginSizeExtraSmall,
                                  ),
                                  // Text(
                                  //   '${((isApplied && afterOfferPrice != "" ? price : (data.price ?? 0)) / 365).toStringAsPrecision(3)}₹ Daily',
                                  //   style: StyleResource.instance.styleSemiBold(
                                  //       color: ColorResource.textLightGrey,
                                  //       fontSize: DimensionResource.fontSizeSmall),
                                  //   maxLines: 2,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 75,
                            height: 20,
                            child: _shimer(),
                          )
                        ],
                      ));
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: DimensionResource.marginSizeSmall),
                  //   child: Container(
                  //       height: 60,
                  //       width: double.infinity,
                  //       padding: EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(
                  //             color: ColorResource.grey, width: 0.25),
                  //         borderRadius: const BorderRadius.all(
                  //           Radius.circular(
                  //               DimensionResource.borderRadiusDefault),
                  //         ),
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           Circ
                  //           SizedBox(
                  //             width: 30,
                  //             height: 30,
                  //             child: _shimer(),
                  //           )
                  //         ],
                  //       )),
                  // );
                },
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Divider(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 20,
              child: _shimer(),
            ),
            const SizedBox(
              height: DimensionResource.paddingSizeExtraSmall,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 40,
              child: _shimer(),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(
                top: 2,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 20,
              child: _shimer(),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: _shimer(),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ],
    );
  }
  Widget allBatchesLoaderForTabletView() {
    double textHeight = 10;
    double titleHeight = 15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          width: 200,
          child: _shimer(),
        ),
        const SizedBox(
          height: 16,
        ),

        // Combine the two Row widgets into one Row for horizontal layout
        ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 200,
                            width: 372,
                            margin: const EdgeInsets.all(
                                DimensionResource.marginSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(DimensionResource
                                    .appDefaultContainerRadius),
                              ),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: DimensionResource
                                          .paddingSizeExtraSmall,
                                      left: DimensionResource
                                          .paddingSizeExtraSmall,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: DimensionResource
                                                .paddingSizeDefault,
                                          ),
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: double.infinity,
                                          child: _shimer(),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: 120,
                                          child: _shimer(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: DimensionResource
                                              .paddingSizeSmall,
                                          horizontal: DimensionResource
                                              .paddingSizeDefault,
                                        ),
                                        height: 120,
                                        width: 110,
                                        child: _shimer(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 1),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusDefault),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      DimensionResource.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                  DimensionResource.paddingSizeSmall,
                                  vertical:
                                  DimensionResource.paddingSizeExtraSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                  border: Border(
                                    top: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: SizedBox(
                                  height: textHeight,
                                  width: 100,
                                  child: _shimer(),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                    DimensionResource.paddingSizeSmall,
                                    vertical:
                                    DimensionResource.paddingSizeExtraSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 200,
                            width: 372,
                            margin: const EdgeInsets.all(
                                DimensionResource.marginSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(DimensionResource
                                    .appDefaultContainerRadius),
                              ),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: DimensionResource
                                          .paddingSizeExtraSmall,
                                      left: DimensionResource
                                          .paddingSizeExtraSmall,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: DimensionResource
                                                .paddingSizeDefault,
                                          ),
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: double.infinity,
                                          child: _shimer(),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(
                                              DimensionResource
                                                  .marginSizeExtraSmall),
                                          height: titleHeight,
                                          width: 120,
                                          child: _shimer(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: DimensionResource
                                              .paddingSizeSmall,
                                          horizontal: DimensionResource
                                              .paddingSizeDefault,
                                        ),
                                        height: 120,
                                        width: 110,
                                        child: _shimer(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 1),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusDefault),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      DimensionResource.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                  DimensionResource.paddingSizeSmall,
                                  vertical:
                                  DimensionResource.paddingSizeExtraSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                  border: Border(
                                    top: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: SizedBox(
                                  height: textHeight,
                                  width: 100,
                                  child: _shimer(),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: ColorResource.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        DimensionResource.borderRadiusMedium),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                    DimensionResource.paddingSizeSmall,
                                    vertical:
                                    DimensionResource.paddingSizeExtraSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorResource.white,
                                    border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[300]!),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          DimensionResource.borderRadiusMedium),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: textHeight,
                                    height: textHeight,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 372,
                          margin: const EdgeInsets.only(
                              bottom: DimensionResource.marginSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(
                                  DimensionResource.appDefaultContainerRadius),
                            ),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!),
                              left: BorderSide(color: Colors.grey[300]!),
                              right: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.paddingSizeSmall,
                            vertical: DimensionResource.paddingSizeExtraSmall,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: textHeight * 2,
                                    width: 80,
                                    child: _shimer(),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: titleHeight,
                                    width: 100,
                                    child: _shimer(),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(
                                    DimensionResource.marginSizeExtraSmall),
                                height: textHeight * 4,
                                width: 210,
                                child: _shimer(),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 376,
                          margin: const EdgeInsets.only(
                              bottom: DimensionResource.marginSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(
                                  DimensionResource.appDefaultContainerRadius),
                            ),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!),
                              left: BorderSide(color: Colors.grey[300]!),
                              right: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.paddingSizeSmall,
                            vertical: DimensionResource.paddingSizeExtraSmall,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: textHeight * 2,
                                    width: 80,
                                    child: _shimer(),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: titleHeight,
                                    width: 100,
                                    child: _shimer(),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(
                                    DimensionResource.marginSizeExtraSmall),
                                height: textHeight * 4,
                                width: 210,
                                child: _shimer(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 400,
                        margin: const EdgeInsets.all(
                            DimensionResource.marginSizeExtraSmall),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(
                                DimensionResource.appDefaultContainerRadius),
                          ),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 12,
                              child: _shimer(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 120,
                              height: 12,
                              child: _shimer(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget allBatchesLoader() {
    double textHeight = 10;
    double titleHeight = 15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          width: 200,
          child: _shimer(),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: DimensionResource.marginSizeDefault),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(
                                  DimensionResource.appDefaultContainerRadius)),
                          border: Border.all(color: Colors.grey[300]!)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: DimensionResource.paddingSizeExtraSmall,
                                left: DimensionResource.paddingSizeExtraSmall,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: DimensionResource
                                            .paddingSizeDefault),
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: titleHeight,
                                    width: double.infinity,
                                    child: _shimer(),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(
                                        DimensionResource.marginSizeExtraSmall),
                                    height: titleHeight,
                                    width: 120,
                                    child: _shimer(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: DimensionResource
                                              .paddingSizeSmall,
                                          horizontal: DimensionResource
                                              .paddingSizeDefault),
                                      height: 120,
                                      width: 110,
                                      child: _shimer()),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 1),
                        Container(
                          decoration: const BoxDecoration(
                            color: ColorResource.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    DimensionResource.borderRadiusDefault)),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(
                                DimensionResource.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: ColorResource.white,
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]!)),
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(
                                      DimensionResource.borderRadiusMedium)),
                            ),
                            child: SizedBox(
                              width: textHeight,
                              height: textHeight,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: DimensionResource.paddingSizeSmall,
                              vertical:
                              DimensionResource.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: ColorResource.white,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(
                                    DimensionResource.borderRadiusMedium)),
                            border: Border(
                              top: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: SizedBox(
                            height: textHeight,
                            width: 100,
                            child: _shimer(),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: ColorResource.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    DimensionResource.borderRadiusMedium)),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: DimensionResource.paddingSizeSmall,
                                vertical:
                                DimensionResource.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: ColorResource.white,
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]!)),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      DimensionResource.borderRadiusMedium)),
                            ),
                            child: SizedBox(
                              width: textHeight,
                              height: textHeight,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                      bottom: DimensionResource.marginSizeSmall),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(
                              DimensionResource.appDefaultContainerRadius)),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                        left: BorderSide(color: Colors.grey[300]!),
                        right: BorderSide(color: Colors.grey[300]!),
                      )),
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.paddingSizeSmall,
                      vertical: DimensionResource.paddingSizeExtraSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(
                                  DimensionResource.marginSizeExtraSmall),
                              height: textHeight * 2,
                              width: 80,
                              child: _shimer(),
                            ),
                            Container(
                              margin: const EdgeInsets.all(
                                  DimensionResource.marginSizeExtraSmall),
                              height: titleHeight,
                              width: 100,
                              child: _shimer(),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(
                              DimensionResource.marginSizeExtraSmall),
                          height: textHeight * 4,
                          child: _shimer(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  /// Loading effect for faq
  Widget faqLoader() {
    double itemHeight = 22;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 20,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: itemHeight,
          child: Row(children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _shimer(),
                )),
            CircleAvatar(
              radius: itemHeight * .5,
              child:
              _shimer(borderRadius: BorderRadius.circular(itemHeight)),
            )
          ]),
        ));
  }

  /// Loader for all Category view
  Widget allCatogaryViewLoader() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _gridWithTitleRow(itemHeight: 90),
        _gridWithTitleRow(itemHeight: 80),
        _gridWithTitleRow(itemHeight: 110),
        _gridWithTitleRow(itemHeight: 90),
        _gridWithTitleRow(itemHeight: 100, itemCount: 1)
      ],
    );
  }

  /// loader for notificaton screen
  Widget notificationScreenLoader() {
    double textHeight = 15;
    return ListView.builder(
        itemCount: 12,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8),
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      child:
                      _shimer(borderRadius: BorderRadius.circular(25))),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: textHeight,
                            width: 100,
                            child: _shimer(),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: textHeight,
                            child: _shimer(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: textHeight,
                    width: 30,
                    child: _shimer(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey[300])
            ],
          ),
        ));
  }

  /// Loader for watch later screen
  Widget watchLaterLoader() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _gridWithTitleRow(itemHeight: 90),
        _gridWithTitleRow(itemHeight: 80),
        _gridWithTitleRow(itemHeight: 110),
        _gridWithTitleRow(itemHeight: 100, itemCount: 1)
      ],
    );
  }

  /// Loader for promo code screen
  Widget promocodeLoader() {
    double btnHeight = 25;
    double textHeight = 20;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: btnHeight + 5,
                      width: 60,
                      child: _shimer(borderRadius: BorderRadius.circular(2)),
                    ),
                    SizedBox(
                      height: btnHeight,
                      width: 70,
                      child: _shimer(borderRadius: BorderRadius.circular(4)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: textHeight,
                  width: 150,
                  child: _shimer(borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Divider(
                  color: Colors.grey[300],
                )
              ],
            ),
          );
        });
  }

  Widget tNcAllTextLoader() {
    double textHeight = 20;
    return ListView.builder(
        itemCount: 20,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 16),
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: textHeight,
              child: _shimer(),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.only(right: 24),
              height: textHeight,
              child: _shimer(),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ));
  }

  Widget dateShimmer() {
    return SizedBox(
      width: 75,
      height: 50,
      child: _shimer(),
    );
  }

  /// loader for live classes
  Widget liveClassLoader() {
    double containerHeight = 155;
    double imageWidth = 110;
    double textHeight = 15;
    double buttonHeight = 40;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
          height: containerHeight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 2)),
            child: Row(children: [
              SizedBox(
                  width: imageWidth,
                  child: _shimer(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          ),
                          SizedBox(
                            width: 40,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 120,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 50,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                          const SizedBox(width: 16),
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          )),
    );
  }

  Widget coursesLoader() {
    double containerHeight = 130;
    double imageWidth = 90;
    double textHeight = 12;
    double buttonHeight = 16;

    return Padding(
      padding: const EdgeInsets.only(left: 10 , right: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Display two items per row
            crossAxisSpacing: 8,
            mainAxisSpacing: 2,

          // Adjusted for grid view
        ),
        shrinkWrap: true,
        itemCount: 10, // Number of items in the grid
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>

            Stack(
              children: [
                Container(
                  height: containerHeight,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 28,
                                  height: textHeight,
                                  child: _shimer(
                                    borderRadius: BorderRadius.circular(textHeight),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: buttonHeight,
                                    child: _shimer(),
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: 100,
                                    height: buttonHeight,
                                    child: _shimer(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 2,
                  child: Transform.rotate(
                    angle: 0.5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

              ],
            )


      ),
    );
  }

  //  loader for upcoming class
  Widget upcomingLiveClassLoaderForTab() {
    double containerHeight = 155;
    double imageWidth = 110;
    double textHeight = 15;
    double buttonHeight = 40;
    return GridView.builder(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        crossAxisSpacing: 18,
        childAspectRatio: 2.0,
        mainAxisSpacing: 8),
      shrinkWrap: true,
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
          height: containerHeight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 2)),
            child: Row(children: [
              SizedBox(
                  width: imageWidth,
                  child: _shimer(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          ),
                          SizedBox(
                            width: 40,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 120,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 50,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                          const SizedBox(width: 16),
                          /*  Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),*/
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          )),
    );
  }

  Widget upcomingLiveClassLoaderForMobile() {
    double containerHeight = 130;
    double imageWidth = 90;
    double textHeight = 12;
    double buttonHeight = 15;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10, // Fewer items for mobile screens
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
        height: containerHeight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                child: _shimer(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(8),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                            height: textHeight,
                            child: _shimer(
                              borderRadius: BorderRadius.circular(textHeight),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                              borderRadius: BorderRadius.circular(textHeight),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 100,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 45,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: buttonHeight,
                              child: _shimer(),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget quizClassLoader() {
    double containerHeight = 130;
    double imageWidth = 90;
    double textHeight = 12;
    double buttonHeight = 20;

    return Padding(
      padding: const EdgeInsets.only(left: 10 , right: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display two items per row
          crossAxisSpacing: 8,
          mainAxisSpacing: 2,
         childAspectRatio: 4/5
         // Adjusted for grid view
        ),
        shrinkWrap: true,
        itemCount: 10, // Number of items in the grid
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>

           Container(
            height: containerHeight,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 80,
                            height: textHeight,
                            child: _shimer(
                              borderRadius: BorderRadius.circular(textHeight),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 100,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 60,
                          height: 70,
                          child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 60,
                            height: buttonHeight,
                            child: _shimer(),
                          ),
                          SizedBox(
                            width: 30,
                            height: buttonHeight,
                            child: _shimer(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }



  Widget liveClassDetailLoader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _listTileWithDescNButton(true),
        ...List.generate(3, (index) => _textTitleNContext())
      ],
    );
  }

  Widget upcomingLiveWebinarClassLoaderForTab() {
    double containerHeight = 155;
    double imageWidth = 110;
    double textHeight = 15;
    double buttonHeight = 40;
    return GridView.builder(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        crossAxisSpacing: 18,
        childAspectRatio: 2.0,
        mainAxisSpacing: 8),
      shrinkWrap: true,
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
          height: containerHeight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 2)),
            child: Row(children: [
              SizedBox(
                  width: imageWidth,
                  child: _shimer(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          ),
                          SizedBox(
                            width: 40,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 120,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 50,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                          const SizedBox(width: 16),
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          )),
    );
  }

  Widget upcomingLiveWebinarClassLoaderForMobile() {
    double containerHeight = 130;
    double imageWidth = 90;
    double textHeight = 12;
    double buttonHeight = 15;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Single column for mobile screens
        crossAxisSpacing: 10,
        childAspectRatio: 2.5, // Adjust ratio for mobile view
        mainAxisSpacing: 8,
      ),
      shrinkWrap: true,
      itemCount: 10, // Reduced item count for mobile screens
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
        height: containerHeight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                child: _shimer(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(8),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                            height: textHeight,
                            child: _shimer(
                              borderRadius: BorderRadius.circular(textHeight),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                              borderRadius: BorderRadius.circular(textHeight),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 100,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 35,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: buttonHeight,
                              child: _shimer(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: buttonHeight,
                              child: _shimer(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Loader for text course details
  Widget textCourseDetailLoader({bool singleTrailing = false}) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          _listTileWithDescNButton(singleTrailing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ...List.generate(
                    8,
                        (index) => Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: _shimer(),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Loading effect for image resources.
  Widget imageLoader({Color? color, BorderRadiusGeometry? radius}) => _shimer(
      color: color,
      timer: const Duration(milliseconds: 800),
      borderRadius: radius);

  /// Shimmer for title and content
  Widget _textTitleNContext() {
    double titleHeight = 20;
    double contentHeight = 15;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: 200,
            height: titleHeight,
            child: _shimer(),
          ),
          ...List.generate(
              4,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.only(left: titleHeight * 1.5, right: 8),
                height: contentHeight,
                child: _shimer(),
              ))
        ],
      ),
    );
  }

  /// ListTile with a decsription and long button.
  Widget _listTileWithDescNButton(bool singleTrailing) {
    double textHeight = 15;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: _shimer(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: textHeight,
                        child: _shimer(),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: textHeight,
                        width: 100,
                        child: _shimer(),
                      ),
                    ],
                  ),
                ),
              ),
              singleTrailing
                  ? SizedBox.square(
                  dimension: textHeight * 2,
                  child: _shimer(
                      borderRadius: BorderRadius.circular(textHeight)))
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 30,
                    height: textHeight,
                    child: _shimer(),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: textHeight,
                    height: textHeight,
                    child: _shimer(
                        borderRadius: BorderRadius.circular(textHeight)),
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                height: textHeight * .8,
                child: _shimer(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: textHeight * .8,
                child: _shimer(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: textHeight * .8,
                child: _shimer(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 50,
                child: _shimer(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget upcomingLiveRecordingClassLoaderForTab() {
    double containerHeight = 155;
    double imageWidth = 110;
    double textHeight = 15;
    double buttonHeight = 40;
    return GridView.builder(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        crossAxisSpacing: 18,
        childAspectRatio: 2.0,
        mainAxisSpacing: 8),
      shrinkWrap: true,
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
          height: containerHeight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 2)),
            child: Row(children: [
              SizedBox(
                  width: imageWidth,
                  child: _shimer(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          ),
                          SizedBox(
                            width: 40,
                            height: textHeight,
                            child: _shimer(
                                borderRadius:
                                BorderRadius.circular(textHeight)),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 120,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 50,
                        height: textHeight,
                        child: _shimer(
                            borderRadius: BorderRadius.circular(textHeight)),
                      ),
                      const SizedBox(height: 28),
                      /* Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                          const SizedBox(width: 16),
                          Expanded(
                              child: SizedBox(
                                height: buttonHeight,
                                child: _shimer(),
                              )),
                        ],
                      )*/
                    ],
                  ),
                ),
              )
            ]),
          )),
    );
  }

  Widget upcomingLiveRecordingClassLoaderForMobile() {
    double containerHeight = 130;
    double imageWidth = 90;
    double textHeight = 12;
    double buttonHeight = 15;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Single column for mobile screens
        crossAxisSpacing: 10,
        childAspectRatio: 2.5, // Adjust ratio for mobile view
        mainAxisSpacing: 8,
      ),
      shrinkWrap: true,
      itemCount: 10, // Reduced item count for mobile screens
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => SizedBox(
        height: containerHeight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                child: _shimer(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(8),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                            height: textHeight,
                            child: _shimer(
                              borderRadius: BorderRadius.circular(textHeight),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            height: textHeight,
                            child: _shimer(
                              borderRadius: BorderRadius.circular(textHeight),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 100,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 35,
                        height: textHeight,
                        child: _shimer(
                          borderRadius: BorderRadius.circular(textHeight),
                        ),
                      ),
                      // const SizedBox(height: 24),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: SizedBox(
                      //         height: buttonHeight,
                      //         child: _shimer(),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Expanded(
                      //       child: SizedBox(
                      //         height: buttonHeight,
                      //         child: _shimer(),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A common Widget for a list of orizontal items with a title shimmer.
  Widget _gridWithTitleRow({double itemHeight = 140, int itemCount = 3}) {
    double textHeight = 20;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: textHeight,
                width: 80,
                child: _shimer(),
              ),
              SizedBox(
                height: textHeight,
                width: 50,
                child: _shimer(),
              )
            ],
          ),
        ),
        Row(
          children: List.generate(
              itemCount,
                  (index) => Expanded(
                  child: Container(
                      height: itemHeight,
                      margin: const EdgeInsets.all(8),
                      child: _shimer()))),
        )
      ],
    );
  }

  Widget courseTileShimmer() {
    return _shimer();
  }

  /// Commmon shimer effect container
  Widget _shimer(
      {Color? color = ColorResource.white,
        Duration timer = const Duration(milliseconds: 1500),
        BorderRadiusGeometry? borderRadius}) =>
      Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: true,
        period: timer,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius ?? BorderRadius.circular(8)),
          // height: double.infinity,
          width: double.infinity,
        ),
      );
}
