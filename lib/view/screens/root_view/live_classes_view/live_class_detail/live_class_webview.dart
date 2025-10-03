import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockpathshala_beta/mentroship/controller/mentorship_detail_controller.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

class LiveClassLaunch extends StatefulWidget {
  final String title;
  final String url;

  const LiveClassLaunch({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  State<LiveClassLaunch> createState() => _LiveClassLaunchState();
}

class _LiveClassLaunchState extends State<LiveClassLaunch> {
  late WebViewController webViewController;
  String url = "";

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    checkPermissions();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
  }

  void checkPermissions() async {
    final microphonePermission = await Permission.microphone.status;
    final cameraPermission = await Permission.camera.status;

    if (!microphonePermission.isGranted || !cameraPermission.isGranted) {
      Map<Permission, PermissionStatus> statuses =
      await [Permission.microphone, Permission.camera].request();

      if (statuses[Permission.camera]!.isDenied ||
          statuses[Permission.microphone]!.isDenied) {
        showPermissionDeniedDialog();
      } else if (statuses[Permission.camera]!.isPermanentlyDenied ||
          statuses[Permission.microphone]!.isPermanentlyDenied) {
        showPermanentlyDeniedDialog();
      } else {
        initializeWebView();
      }
    } else {
      initializeWebView();
    }
  }

  void initializeWebView() {
    setState(() {
      url = widget.url;
      webViewController = WebViewController(
        onPermissionRequest: (WebViewPermissionRequest request) => request.grant(),
      )
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) => logPrint('Page started loading: $url'),
            onPageFinished: (url) => logPrint('Page finished loading: $url'),
            onWebResourceError: (error) => logPrint('Error: ${error.description}'),
            onNavigationRequest: (request) {
              if (request.url.contains(AppConstants.instance.redirectWebUrl)) {
                Get.back(); // Redirect to previous screen when class ends
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    });
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Denied'),
        content: Text(
            'Camera and microphone permissions are required for live sessions. Please allow permissions to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              checkPermissions();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void showPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Permanently Denied'),
        content: Text(
            'Camera and microphone permissions are permanently denied. Please enable them in app settings to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: url.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: webViewController),
    );
  }
}


// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stockpathshala_beta/mentroship/controller/mentorship_detail_controller.dart';
// import 'package:stockpathshala_beta/model/utils/app_constants.dart';
// import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
// import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
//
// class LiveClassLaunch extends StatefulWidget {
//   final String title;
//   final String url;
//
//   const LiveClassLaunch({Key? key, required this.title, required this.url})
//       : super(key: key);
//
//   @override
//   State<LiveClassLaunch> createState() => _LiveClassLaunchState();
// }
//
// class _LiveClassLaunchState extends State<LiveClassLaunch> {
//   late InAppWebViewController webViewController;
//   String url = "";
//   String checkUrl =
//       'https://www.stockpathshala.com/?userid=ch60jmpnuvt1kduu31e0&role=participant&classid=ch9r56t22mm4bls83brg&subclassid=ch9r5ud22mm4bls83dk0';
//   int countValue = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     checkPermissions(); // Call permissions check on initialization
//     setUrl();
//
//     /// sets orientation to landscape
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
//   }
//
//   /// Request camera and microphone permissions
//   void checkPermissions() async {
//     final microphonePermission = await Permission.microphone.status;
//     final cameraPermission = await Permission.camera.status;
//
//     if (!microphonePermission.isGranted || !cameraPermission.isGranted) {
//       Map<Permission, PermissionStatus> statuses =
//           await [Permission.microphone, Permission.camera].request();
//
//       if (statuses[Permission.camera]!.isDenied ||
//           statuses[Permission.microphone]!.isDenied) {
//         // Handle if user denies the permissions
//         showPermissionDeniedDialog();
//       } else if (statuses[Permission.camera]!.isPermanentlyDenied ||
//           statuses[Permission.microphone]!.isPermanentlyDenied) {
//         // Handle if user permanently denies the permissions
//         showPermanentlyDeniedDialog();
//       }
//     }
//   }
//
//   /// Show dialog when permissions are denied
//   void showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Permission Denied'),
//         content: Text(
//             'Camera and microphone permissions are required for live sessions. Please allow permissions to continue.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               checkPermissions(); // Recheck permissions
//             },
//             child: Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Show dialog for permanently denied permissions
//   void showPermanentlyDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Permission Permanently Denied'),
//         content: Text(
//             'Camera and microphone permissions are permanently denied. Please enable them in app settings to continue.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               openAppSettings(); // Opens app settings for the user
//             },
//             child: Text('Open Settings'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void setUrl() {
//     setState(() {
//       url = widget.url;
//       print('sefsd $url');
//     });
//   }
//
//   @override
//   void dispose() {
//     /// reverts to portrait mode
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//           // url: Uri.parse(url),
//           url: WebUri(url),
//         ),
//         initialOptions: InAppWebViewGroupOptions(
//           crossPlatform: InAppWebViewOptions(
//             mediaPlaybackRequiresUserGesture: false,
//             useShouldOverrideUrlLoading: true,
//           ),
//           ios: IOSInAppWebViewOptions(
//             allowsInlineMediaPlayback: true, // This allows inline playback
//             allowsAirPlayForMediaPlayback: true, // Allows AirPlay
//             allowsPictureInPictureMediaPlayback: true, // Supports Picture-in-Picture
//           ),
//         ),
//         onWebViewCreated: (InAppWebViewController controller) {
//           webViewController = controller;
//         },
//         onProgressChanged: (controller, pro) async {
//           logPrint("Webview: controller page ${await controller.getUrl()}");
//           logPrint(
//               "Webview: controller page ${checkUrl.contains(AppConstants.instance.redirectWebUrl)}");
//           EasyDebounce.debounce(
//               countValue.toString(), const Duration(milliseconds: 400),
//               () async {
//             await controller.getUrl().then((value) {
//               if (value
//                       ?.toString()
//                       .contains(AppConstants.instance.redirectWebUrl) ??
//                   false) {
//                 setState(() {
//                   countValue++;
//                 });
//                 Get.back();
//               } else {
//                 logPrint(
//                     "Webview: change url ${value?.path.contains(AppConstants.instance.redirectWebUrl)}");
//               }
//             });
//           });
//         },
//         iosOnWebContentProcessDidTerminate:
//             (InAppWebViewController controller) {},
//         androidOnPermissionRequest: (InAppWebViewController controller,
//             String origin, List<String> resources) async {
//           logPrint("Webview: resources $resources");
//           return PermissionRequestResponse(
//             resources: resources,
//             action: PermissionRequestResponseAction.GRANT,
//           );
//         },
//       ),
//     );
//   }
// }
