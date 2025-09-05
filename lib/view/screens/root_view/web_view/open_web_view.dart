import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

class OpenWebView extends StatefulWidget {
  final String url;
  final String title;
  const OpenWebView({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<OpenWebView> createState() => _OpenWebViewState();
}

class _OpenWebViewState extends State<OpenWebView> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => print('Page started loading: $url'),
          onPageFinished: (url) => print('Page finished loading: $url'),
          onWebResourceError: (error) => print('Error: ${error.description}'),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: StyleResource.instance
              .styleSemiBold(color: ColorResource.white),
        ),
        backgroundColor: ColorResource.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: ColorResource.white,
          iconSize: 18,
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.red,
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import 'package:stockpathshala_beta/model/utils/color_resource.dart';
// import 'package:stockpathshala_beta/model/utils/style_resource.dart';
//
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:get/get.dart';
// import 'package:stockpathshala_beta/model/utils/color_resource.dart';
// import 'package:stockpathshala_beta/model/utils/style_resource.dart';
//
// class OpenWebView extends StatefulWidget {
//   final String url;
//   final String title;
//
//   const OpenWebView({Key? key, required this.url, required this.title})
//       : super(key: key);
//
//   @override
//   State<OpenWebView> createState() => _OpenWebViewState();
// }
//
// class _OpenWebViewState extends State<OpenWebView> {
//   late final WebViewController _webViewController;
//   bool isLoading = true; // To track loading state
//
//   @override
//   void initState() {
//     super.initState();
//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
//       ..setBackgroundColor(Colors.red) // Set background color
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (progress) {
//             setState(() {
//               isLoading = true; // Show loading when the page is loading
//             });
//           },
//           onPageStarted: (url) {
//             setState(() {
//               isLoading = true; // Start loading
//             });
//           },
//           onPageFinished: (url) {
//             setState(() {
//               isLoading = false; // Hide loader when page is loaded
//             });
//           },
//           onWebResourceError: (error) {
//             print("WebView Error: ${error.description}");
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style:
//           StyleResource.instance.styleSemiBold(color: ColorResource.white),
//         ),
//         backgroundColor: ColorResource.primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: ColorResource.white,
//           iconSize: 18,
//           onPressed: () async {
//             if (await _webViewController.canGoBack()) {
//               _webViewController.goBack(); // Go back in WebView history
//             } else {
//               Get.back(); // Exit WebView screen
//             }
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _webViewController),
//           if (isLoading) // Show loader while page is loading
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class OpenWebView extends StatefulWidget {
//   final String url;
//   final String title;
//   const OpenWebView({Key? key, required this.url, required this.title})
//       : super(key: key);
//   @override
//   State<OpenWebView> createState() => _OpenWebViewState();
// }

// class _OpenWebViewState extends State<OpenWebView> {
//   // late InAppWebViewController _webViewController;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style:
//               StyleResource.instance.styleSemiBold(color: ColorResource.white),
//         ),
//         backgroundColor: ColorResource.primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: ColorResource.white,
//           iconSize: 18,
//           onPressed: () {
//             Get.back();
//           },
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(10),
//         color: Colors.red,
//         child: InAppWebView(
//             initialUrlRequest: URLRequest(url: WebUri(widget.url)),
//             initialOptions: InAppWebViewGroupOptions(
//               crossPlatform: InAppWebViewOptions(
//                 mediaPlaybackRequiresUserGesture: false,
//                 //debuggingEnabled: true,
//               ),
//               ios: IOSInAppWebViewOptions(
//                 allowsInlineMediaPlayback:
//                     true, // Allow inline media playback (for videos)
//               ),
//             ),
//             onWebViewCreated: (InAppWebViewController controller) {
//               // _webViewController = controller;
//             },
//             androidOnPermissionRequest: (InAppWebViewController controller,
//                 String origin, List<String> resources) async {
//               return PermissionRequestResponse(
//                   resources: resources,
//                   action: PermissionRequestResponseAction.GRANT);
//             }),
//       ),
//     );
//   }
// }
