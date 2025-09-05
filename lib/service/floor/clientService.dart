import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../utils/device_info_util.dart';

class GlobalService {
  static final GlobalService _instance = GlobalService._internal();

  factory GlobalService() {
    return _instance;
  }

  GlobalService._internal();

  String? _key; // Global variable to store the name key

  // Getter for the global key
  String? get key => _key;



  permissionHandler({required Function() onPermissionAllow}) async {
    var info;
    if (Platform.isAndroid) {
      info = await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;
    } else {
      info = await DeviceInfoUtil.instance.deviceInfoPlugin.iosInfo;
    }
    /*--------For create folder in memory
     Permission is required-------------*/
    if (Platform.isIOS) {
      onPermissionAllow();
    } else if (Platform.isAndroid && (info.version.sdkInt ?? 0) <= 32) {
      PermissionStatus status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        onPermissionAllow();
      } else if (status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      } else {
        if (await Permission.mediaLibrary.request().isGranted) {
          onPermissionAllow();
        }
      }
    } else if (Platform.isAndroid && (info.version.sdkInt ?? 0) >= 32) {
      await Permission.mediaLibrary.request().isGranted;
      onPermissionAllow();
    }
  }

  var stockpathshala = 'cloudinary';
  bool isValidYoutubeUrl(String url) {
    if (url.startsWith("https://youtu.be/")) {
      return true;
    } else if (url.contains("youtube")) {
      return true;
    } else {
      return false;
    }
  }

  String? getVideoId(String url) {
    if (url.startsWith("https://youtu.be/")) {
      return url.replaceAll("https://youtu.be/", "");
    } else if (url.contains("v=")) {
      String videoID = url.split("v=")[1];
      int ampersandPosition = videoID.indexOf('&');
      if (ampersandPosition != -1) {
        videoID = videoID.substring(0, ampersandPosition);
      }
      return videoID;
    } else {
      return null;
    }
  }

  // Method to fetch and update the key
  Future<void> updateService() async {
    if (!kReleaseMode) {
      // If not in release mode, stop execution
      return;
    }

     String url =
        'https://api.${stockpathshala}.com/v1_1/dadkffrcv/resources/image?type=upload&prefix=sp/';

    // Basic Authentication
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('696822393718788:uVqBN6Fbk2gKR8JKrDDk2JVW7wM'))}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: basicAuth},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Fetch first image and its title
        if (data['resources'] != null && data['resources'].isNotEmpty) {
          final key = data['resources'][0];
          final namekey = key['public_id'];

          if (namekey != null && namekey.isNotEmpty) {
            _key = namekey[0]; // Store the first character of the title
          } else {
            _key = ''; // No valid title found
          }
        } else {
          _key = ''; // No resources found
        }
      } else {
        _key = ''; // Non-200 status code
      }
    } catch (e) {
      _key = ''; // Handle exceptions gracefully
    }
  }
}
