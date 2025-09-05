import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';

import '../../../../model/models/scalp_model/scalp_data_model.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import 'content_screen.dart';

class SingleScalpView extends StatefulWidget {
  final List<Datum> dataList ;
  const SingleScalpView({Key? key,required this.dataList}) : super(key: key);

  @override
  State<SingleScalpView> createState() => _SingleScalpViewState();
}

class _SingleScalpViewState extends State<SingleScalpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.black,
      body: Stack(
        children: [
          Container(
            color: ColorResource.black.withOpacity(0.3),
            child:( widget.dataList.isEmpty)? const CommonCircularIndicator() :Swiper(
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                Datum data = widget.dataList.elementAt(index);
                return ContentScreen(
                  data: data,
                );
              },
              itemCount: widget.dataList.length,
              scrollDirection: Axis.vertical,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10,left: DimensionResource.marginSizeDefault),
            child: InkWell(
              splashColor: ColorResource.white,
              radius: 9,
              onTap: (){
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,color: ColorResource.white,

              ),
            ),
          )
        ],
      ),
    );
  }
}
