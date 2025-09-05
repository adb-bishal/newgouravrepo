import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/batches_repo.dart';
import '../../../models/network_call_model/api_response.dart';
import 'account_provider.dart';

class BatchProvider {
  final BatchRepo batchRepo;
  BatchProvider({required this.batchRepo});

  Future getAllBatches(String? dateFilter, int? pageNo, String? categoryId, {
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await batchRepo.getAllBatches(dateFilter,pageNo,categoryId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getPastBatches(String? dateFilter, int? pageNo, String? categoryId,  {
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await batchRepo.getPastBatches(dateFilter,pageNo,categoryId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getAllDates({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await batchRepo.getBatchDates();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getBatchData({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required int batchStartDate,
    required int batchId,
    required bool isPast,
    int? pageNo,
  }) async {
    ApiResponse apiResponse = await batchRepo.getBatchdata(
        isPast: isPast,
        batchId: batchId,
        batchStartDate: batchStartDate,
        pageNo: pageNo);
    CheckApiResponse.instance.initResponse(
      apiResponse,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
