import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';

import '../../../model/models/account_models/level_model.dart';
import '../../../service/floor/entity/download.dart' as db;
import '../../../view/screens/root_view/live_classes_view/live_classes_view.dart';

class DownloadDetailController extends GetxController{
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxInt countValue = 0.obs;
  Rx<CourseDetailViewType> viewType = CourseDetailViewType.video.obs;
  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  late db.AppDatabase database ;
  RxString categoryType = "".obs;
  RxList<String> subscriptionData = <String>[
    "All",
    "Free",
    "Pro"
  ].obs;

  onClassSearch(val){
    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
            () async {
          logPrint("dfd $val");
              onSearch(val);
          countValue.value++;
          

        });
  }

  RxInt selectedSubscriptionFilter = 0.obs;

  Rx<Datum> selectedFilterLevel = Datum().obs;

  List<db.Audio> audio = <db.Audio>[].obs;
  List<db.Audio> searchAudio = <db.Audio>[].obs;
  List<db.AudioCourseFolder> audioCourses = <db.AudioCourseFolder>[].obs;
  List<db.AudioCourseFolder> searchAudioCourses = <db.AudioCourseFolder>[].obs;


  List<db.Video> video = <db.Video>[].obs;
  List<db.Video> searchVideo = <db.Video>[].obs;
  List<db.VideoCourseFolder> videoCourses = <db.VideoCourseFolder>[].obs;
  List<db.VideoCourseFolder> searchVideoCourses = <db.VideoCourseFolder>[].obs;
  @override
  void onInit() {
    var args = Get.arguments;

    // Check if Get.arguments is not null and is a List
    if (args != null && args is List) {
      // Safely access categoryType, if present in args[0]
      categoryType.value = args.isNotEmpty && args[0] != null ? args[0] as String : "";

      // Safely access viewType, if present in args[1], fallback to null if not found
      if (args.length > 1 && args[1] != null && args[1] is CourseDetailViewType) {
        viewType.value = args[1] as CourseDetailViewType;
      } else {
        // Assign a default value if viewType is not present or invalid
        viewType.value = CourseDetailViewType.video;  // or any default you need
      }
    } else {
      // Fallback if arguments are null or not a List
      categoryType.value = "";
      viewType.value = CourseDetailViewType.video; // Default value if no arguments provided
    }

    // Proceed with content loading
    getAllContent();

    super.onInit();
  }



  // void onInit() {
  //   if(Get.arguments != null){
  //     categoryType.value = Get.arguments[0];
  //     viewType.value = Get.arguments[1];
  //   }
  //   getAllContent();
  //   super.onInit();
  // }

  onSearch(String text){
    if(viewType.value == CourseDetailViewType.video){
      searchVideo.clear();
      for(db.Video data in video){
        logPrint("vodeo data ${data.name}");
        if(data.name.toLowerCase().contains(text.toLowerCase())){
          searchVideo.add(data);
        }
      }
    }else if(viewType.value == CourseDetailViewType.videoCourse){
      searchVideoCourses.clear();
      for(db.VideoCourseFolder data in videoCourses){
        if(data.name.toLowerCase().contains(text.toLowerCase())){
          searchVideoCourses.add(data);
        }
      }
    }else if(viewType.value == CourseDetailViewType.audio){
      searchAudio.clear();
      for(db.Audio data in audio){
        if(data.name.toLowerCase().contains(text.toLowerCase())){
          searchAudio.add(data);
        }
      }
    }else{
      searchAudioCourses.clear();
      for(db.AudioCourseFolder data in audioCourses){
        if(data.name.toLowerCase().contains(text.toLowerCase())){
          searchAudioCourses.add(data);
        }
      }
    }

  }

  void getAllContent() async {
    audio.clear();
    audioCourses.clear();

    video.clear();
    videoCourses.clear();

    database = await db.DbInstance.instance();

    if(viewType.value == CourseDetailViewType.video){
      database.videoDao.findAllVideo().then((value){
        video.addAll(value);
      });
    }else if(viewType.value == CourseDetailViewType.videoCourse){
      database.videoCourseFolderDao.findAllVideoFolder().then((value){
        videoCourses.addAll(value);
      });
    }else if(viewType.value == CourseDetailViewType.audio){
      database.audioDao.findAllAudio().then((value){
        audio.addAll(value);
      });
    }else{
      database.audioCourseFolderDao.findAllAudioFolder().then((value){
        audioCourses.addAll(value);
      });
    }
  }

  void getFilterData(List<String?> catIds)async{
    audio.clear();
    audioCourses.clear();

    video.clear();
    videoCourses.clear();

    if(viewType.value == CourseDetailViewType.video){
      database.videoDao.filterAllVideo(catIds).then((value){
        video.addAll(value);
      });
    }else if(viewType.value == CourseDetailViewType.videoCourse){
      database.videoCourseFolderDao.filterAllVideo(catIds).then((value){
        videoCourses.addAll(value);
      });
    }else if(viewType.value == CourseDetailViewType.audio){
      database.audioDao.filterAllAudio(catIds).then((value){
        audio.addAll(value);
      });
    }else{
      database.audioCourseFolderDao.filterAllAudioCourse(catIds).then((value){
        audioCourses.addAll(value);
      });
    }

  }

}