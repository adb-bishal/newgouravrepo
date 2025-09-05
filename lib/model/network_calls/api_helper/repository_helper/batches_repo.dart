import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class BatchRepo {
  final DioClient dioClient;
  BatchRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getAllBatches(String? dateFilter, int? pageNo, String? categoryId) async {
    try {
      final baseUrl = AppConstants.instance.allBatches;

      final queryParams = <String, String>{};

      if (dateFilter != null && dateFilter.isNotEmpty) {
        queryParams['month_filter'] = dateFilter;
      }

      if (pageNo != null) {
        queryParams['page'] = pageNo.toString();
      }

      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['category_ids'] = categoryId;
      }

      final url = Uri.parse(baseUrl).replace(
        queryParameters: queryParams,
      ).toString();

      logPrint("Fetching batches from: $url");
      return await dioClient.getResponse(url: url, dioClient: dioClient);
    } catch (e) {
      logPrint("Error in getAllBatches: $e");
      return ApiResponse.withError("Failed to fetch batches");
    }
  }
  Future<ApiResponse> getPastBatches(String? dateFilter, int? pageNo, String? categoryId) async {
    try {
      String url = AppConstants.instance.pastBatches;
      List<String> queryParams = [];
      if (dateFilter != null && dateFilter.isNotEmpty) {
        queryParams.add('month_filter=$dateFilter');
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams.add('category_ids=$categoryId');
      }
      queryParams.add('page=${pageNo ?? 1}');
      if (queryParams.isNotEmpty) {

        url += '?${queryParams.join('&')}';
      }

      return dioClient.getResponse(url: url, dioClient: dioClient);
    } catch (e) {
      return ApiResponse.withError(
         'Failed to fetch past batches',
      );
    }
  }
  Future<ApiResponse> getBatchdata(
      {required bool isPast,
      required int batchStartDate,
      required int batchId,
      int? pageNo}) async {
    String url = isPast
        ? "${AppConstants.instance.allBatchPastLiveClass}/?batch_id=$batchId&batch_start_date=$batchStartDate&page=${pageNo ?? 1}"
        : batchId == 0
            ? "${AppConstants.instance.batchData}/?batch_start_date=$batchStartDate"
            : "${AppConstants.instance.batchData}/?batch_id=$batchId&batch_start_date=$batchStartDate&page=${pageNo ?? 1}";
    logPrint("$batchId : $batchStartDate");
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getBatchDates() async {
    String url = AppConstants.instance.batchDates;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }
}
