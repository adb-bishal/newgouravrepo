import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';

import '../../../models/network_call_model/api_response.dart';
import '../../../services/auth_service.dart';
import '../repository_helper/courses_repo.dart';
import 'account_provider.dart';

class CourseProvider {
  final CoursesRepo coursesRepo;
  CourseProvider({required this.coursesRepo});

  Future getAllCategories(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required String sort,
      required String searchKeyWord,
      required String languageId}) async {
    ApiResponse apiResponse = await coursesRepo.getAllCategories(
        sort: sort, searchKeyWord: searchKeyWord, languageId: languageId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Filter by Teacher
  getTeacherData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await coursesRepo.onFilterbyTeacher();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getCategoryDetail(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required String catId}) async {
    ApiResponse apiResponse = await coursesRepo.getCategoryDetail(catId: catId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getCourseData({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String catId,
    required CourseDetailViewType type,
    required int pageNo,
    String? searchKeyWord,
    String? subscriptionLevel,
    String? langId,
    String? rating,
    String? currentId,
    double? percent,
    double? criteria,
    String? level,
  }) async {
    ApiResponse apiResponse = await coursesRepo.getCourseData(
      catId: catId,
      type: type,
      pageNo: pageNo,
      searchKeyWord: searchKeyWord ?? "",
      rating: rating,
      subscriptionLevel: subscriptionLevel,
      langId: langId,
      currentId: currentId,
      percent: percent,
      criteria: criteria,
      level: level,
    );
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getCourseAllData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required CourseDetailViewType type,
      required int pageNo,
      String? searchKeyWord,
      String? rating,
      String? catId,
      String? subscriptionLevel}) async {
    ApiResponse apiResponse = await coursesRepo.getCourseAllData(
        type: type,
        pageNo: pageNo,
        searchKeyWord: searchKeyWord ?? "",
        rating: rating,
        subscriptionLevel: subscriptionLevel,
        catId: catId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getCourseMoreData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required String catId,
      required String currentId,
      required CourseDetailViewType type,
      required int pageNo}) async {
    ApiResponse apiResponse = await coursesRepo.getCourseMoreData(
        catId: catId, type: type, pageNo: pageNo, currentId: currentId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getVideoById({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String videoId,
  }) async {
    ApiResponse apiResponse = await coursesRepo.getVideoById(videoId: videoId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getAudioById({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String audioId,
  }) async {
    ApiResponse apiResponse = await coursesRepo.getAudioById(audioId: audioId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getBlogById({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String blogId,
  }) async {
    ApiResponse apiResponse = await coursesRepo.getBlogById(blogId: blogId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getCourseStatus({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String courseId,
  }) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      ApiResponse apiResponse =
          await coursesRepo.getCourseStatus(courseId: courseId);
      CheckApiResponse.instance
          .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
    }
  }

  Future getCourseHistory({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String courseId,
  }) async {
    ApiResponse apiResponse =
        await coursesRepo.getCourseHistory(courseId: courseId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future postCourseHistory({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required Map<String, dynamic> mapData,
  }) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      ApiResponse apiResponse =
          await coursesRepo.postCourseHistory(mapData: mapData);
      CheckApiResponse.instance
          .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
    }
  }

  Future updateVideoStatus({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required Map<String, dynamic> mapData,
  }) async {
    ApiResponse apiResponse =
        await coursesRepo.updateVideoStatus(mapData: mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getCourseById({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String courseId,
    required CourseDetailViewType type,
  }) async {
    ApiResponse apiResponse =
        await coursesRepo.getCourseById(courseId: courseId, type: type);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  // Future getSingleVideo({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required String catId}) async {
  //   ApiResponse apiResponse = await coursesRepo.getSingleVideo(catId: catId);
  //   CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  // }
  // Future getSingleAudio({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required String catId}) async {
  //   ApiResponse apiResponse = await coursesRepo.getSingleAudio(catId: catId);
  //   CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  // }
  // Future getBlog({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required String catId}) async {
  //   ApiResponse apiResponse = await coursesRepo.getBlog(catId: catId,);
  //   CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  // }
  // Future getCourse ({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required String catId,required int typeId}) async {
  //   ApiResponse apiResponse = await coursesRepo.getCourse(catId: catId,typeId:typeId);
  //   CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  // }
}
