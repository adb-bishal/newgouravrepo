import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';

import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class CoursesRepo {
  final DioClient dioClient;
  CoursesRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getCourseHistory({String courseId = ""}) async {
    String url = "${AppConstants.instance.courseHistory}?course_id=$courseId";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> postCourseHistory(
      {required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.courseHistory;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }

  Future<ApiResponse> updateVideoStatus(
      {required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.continueLearning;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }

  Future<ApiResponse> getAllCategories(
      {String sort = "ASC",
      required String searchKeyWord,
      required String languageId}) async {
    String url =
        "${AppConstants.getAllCategories}?limit=100&page=1&sort=$sort&search=$searchKeyWord&order_by=title&language_id=$languageId";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getCategoryDetail({required String catId}) async {
    String url = "${AppConstants.category}$catId/all_types";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  /// custom filter by teacher
  Future<ApiResponse> onFilterbyTeacher() async {
    String url = AppConstants.instance.filterbyTeacher;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getCourseAllData(
      {int limit = 15,
      int pageNo = 1,
      required CourseDetailViewType type,
      String searchKeyWord = "",
      String? rating,
      String? catId,
      String? subscriptionLevel}) async {
    String url;
    switch (type) {
      case CourseDetailViewType.video:
        url =
            "${AppConstants.singleAllVideo}limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&category_id=${catId ?? ""}";
        break;
      case CourseDetailViewType.blogs:
        url =
            "${AppConstants.blogAll}limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&category_id=${catId ?? ""}";
        break;
      case CourseDetailViewType.audioCourse:
        url =
            "${AppConstants.course}type_id=2&limit=$limit&page=$pageNo&type_id=2&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&category_id=${catId ?? ""}";
        break;
      case CourseDetailViewType.videoCourse:
        url =
            "${AppConstants.course}type_id=3&limit=$limit&page=$pageNo&type_id=3&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&category_id=${catId ?? ""}";
        break;
      case CourseDetailViewType.textCourse:
        url =
            "${AppConstants.course}type_id=1&limit=$limit&page=$pageNo&type_id=1&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&category_id=${catId ?? ""}";
        break;
      case CourseDetailViewType.allCourses:
        url =
            "${AppConstants.course}limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&category_id=${catId ?? ""}";
        break;
      default:
        url =
            "${AppConstants.singleAllAudio}limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&category_id=${catId ?? ""}";
        break;
    }
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getCourseData({
    required String catId,
    int limit = 15,
    int pageNo = 1,
    required CourseDetailViewType type,
    String searchKeyWord = "",
    String? rating,
    String? subscriptionLevel,
    String? langId,
    String? currentId,
    double? percent,
    double? criteria,
    String? level,
  }) async {
    String url;
    switch (type) {
      case CourseDetailViewType.video:
        url =
            "${AppConstants.singleVideo}$catId&limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&current_id=${currentId ?? ""}&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}";
        break;
      case CourseDetailViewType.blogs:
        url =
            "${AppConstants.blog}$catId&limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&current_id=${currentId ?? ""}&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}";
        break;
      case CourseDetailViewType.audioCourse:
        url =
            "${AppConstants.course}category_id=$catId&limit=$limit&page=$pageNo&type_id=2&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&current_id=${currentId ?? ""}&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}";
        break;
      case CourseDetailViewType.videoCourse:
        url =
            "${AppConstants.course}category_id=$catId&limit=$limit&page=$pageNo&type_id=3&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&current_id=${currentId ?? ""}&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}";
        break;
      case CourseDetailViewType.textCourse:
        url =
            "${AppConstants.course}category_id=$catId&limit=$limit&page=$pageNo&type_id=1&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&current_id=${currentId ?? ""}&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}";
        break;
      case CourseDetailViewType.allCourses:
        url = url = level == null || level.isEmpty
            ? "${AppConstants.course}limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&language_ids=${langId ?? ""}&category_ids=$catId&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}"
            : "${AppConstants.course}limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&language_ids=${langId ?? ""}&category_ids=$catId&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}&level_id=$level";

        break;
      default:
        url =
            "${AppConstants.singleAudio}$catId&limit=$limit&page=$pageNo&search=$searchKeyWord&rating=${rating ?? ""}&is_free=${subscriptionLevel ?? ""}&current_id=${currentId ?? ""}&recommendation_percentage=${percent ?? ""}&certificate_criteria=${criteria ?? ""}";
        break;
    }
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getCourseById({
    required String courseId,
    required CourseDetailViewType type,
  }) async {
    String url;
    switch (type) {
      case CourseDetailViewType.audioCourse:
        url = "${AppConstants.courseById}$courseId";
        break;
      case CourseDetailViewType.videoCourse:
        url = "${AppConstants.courseById}$courseId";
        break;
      default:
        url = "${AppConstants.courseById}$courseId";
        break;
    }
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getCourseMoreData(
      {required String? catId,
      int limit = 5,
      int pageNo = 1,
      required CourseDetailViewType type,
      required String currentId}) async {
    String url;
    switch (type) {
      case CourseDetailViewType.video:
        url =
            "${AppConstants.singleVideoByTag}${catId ?? ""}&limit=$limit&page=$pageNo&current_id=$currentId";
        break;
      case CourseDetailViewType.blogs:
        url =
            "${AppConstants.blog}${catId ?? ""}&limit=$limit&page=$pageNo&current_id=$currentId";
        break;
      case CourseDetailViewType.audioCourse:
        url =
            "${AppConstants.course}category_id=${catId ?? ""}&limit=$limit&page=$pageNo&type_id=2&current_id=$currentId";
        break;
      case CourseDetailViewType.videoCourse:
        url =
            "${AppConstants.course}category_id=${catId ?? ""}&limit=$limit&page=$pageNo&type_id=3&current_id=$currentId";
        break;
      case CourseDetailViewType.textCourse:
        url =
            "${AppConstants.course}category_id=${catId ?? ""}&limit=$limit&page=$pageNo&type_id=1&current_id=$currentId";
        break;
      default:
        url =
            "${AppConstants.singleAudioByTag}${catId ?? ""}&limit=$limit&page=$pageNo&current_id=$currentId";
        break;
    }
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getVideoById({required String videoId}) async {
    String url = "${AppConstants.video}$videoId";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getAudioById({required String audioId}) async {
    String url = "${AppConstants.audio}$audioId";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getBlogById({required String blogId}) async {
    String url = "${AppConstants.blogById}$blogId";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getCourseStatus({required String courseId}) async {
    logPrint(courseId);
    String url = "${AppConstants.instance.courseHistory}?course_id=$courseId";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }
  // Future<ApiResponse> getSingleVideo({required String catId,int limit = 15,int pageNo = 1}) async {
  //   String url = "${AppConstants.singleVideo}$catId";
  //   return dioClient.getResponse(url: url,dioClient: dioClient);
  // }
  //
  // Future<ApiResponse> getSingleAudio({required String catId,int limit = 15,int pageNo = 1}) async {
  //   String url = "${AppConstants.singleAudio}$catId";
  //   return dioClient.getResponse(url: url,dioClient: dioClient);
  // }
  //
  // Future<ApiResponse> getBlog({required String catId,int limit = 15,int pageNo = 1}) async {
  //   String url = "${AppConstants.blog}$catId";
  //   return dioClient.getResponse(url: url,dioClient: dioClient);
  // }
  //
  //
  // Future<ApiResponse> getCourse({required String catId,required int typeId,int limit = 15,int pageNo = 1}) async {
  //   String url = "${AppConstants.course}category_id=$catId&limit=$limit&pages=$pageNo&type_id=$typeId";
  //   return dioClient.getResponse(url: url,dioClient: dioClient);
  // }
}
