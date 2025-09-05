import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/video_course_detail_controller/video_course_detail_controller.dart';

class TabViewForCourseVideos extends StatefulWidget {
  TabViewForCourseVideos({super.key, required this.controller});

  VideoCourseDetailController controller;

  @override
  State<TabViewForCourseVideos> createState() => _TabViewForCourseVideosState();
}

class _TabViewForCourseVideosState extends State<TabViewForCourseVideos>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TabController tabController = TabController(length: 2, vsync: this);

    return Container();
  }
}
