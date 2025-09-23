import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AutoRotateService extends GetxService {
  static const platform = MethodChannel('system_settings_channel');

  // Reactive variables
  final _isAutoRotateEnabled = Rxn<bool>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Getters
  bool? get isAutoRotateEnabled => _isAutoRotateEnabled.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    checkAutoRotateStatus();
  }

  Future<void> checkAutoRotateStatus() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final bool result = await platform.invokeMethod('checkAutoRotateToggle');
      _isAutoRotateEnabled.value = result;

    } on PlatformException catch (e) {
      _errorMessage.value = e.message ?? 'Unknown error occurred';
      _isAutoRotateEnabled.value = null;
    } catch (e) {
      _errorMessage.value = 'Failed to check auto-rotate status';
      _isAutoRotateEnabled.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  // Method to refresh status
  Future<void> refresh() async {
    await checkAutoRotateStatus();
  }
}
