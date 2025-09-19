// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:screen_protector/screen_protector.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'firebase_options.dart';
// import 'app.dart'; // Your main app widget
// import 'model/services/notification_service.dart';
// import 'model/services/auth_service.dart';
// import 'model/network_calls/dio_client/get_it_instance.dart';
// import 'service/floor/clientService.dart';
// import 'view/widgets/log_print/log_print_condition.dart';
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
// Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   // MyNotification.showNotification(message);
// }
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await disableScreenCapture();
//   await getInit();
//   await initServices();
//
//   runApp(MyAppSP());
// }
//
// Future<void> disableScreenCapture() async {
//   await ScreenProtector.preventScreenshotOn();
//   await ScreenProtector.protectDataLeakageOn();
// }
//
// Future<void> initServices() async {
//   Get.log('Starting services...');
//   await GlobalService().updateService();
//
//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     await GetStorage.init();
//     await Get.putAsync(() => AuthService().init());
//
//     MyNotification.initialize(flutterLocalNotificationsPlugin);
//
//     FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
//
//     // iOS/Android 13+ permissions
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Foreground handler
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // MyNotification.showNotification(message);
//     });
//
//     // Notification tap (when app is in background/terminated)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // You can navigate based on message data
//       logPrint("Notification clicked: ${message.data}");
//     });
//
//     SmsAutoFill().listenForCode;
//   } catch (e) {
//     logPrint("Init error: $e");
//   }
//
//   Get.log('All services started...');
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stockpathshala_beta/feedback/web_socket_service.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'firebase_options.dart';
import 'app.dart';
import 'model/services/notification_service.dart';
import 'model/services/auth_service.dart';
import 'model/network_calls/dio_client/get_it_instance.dart';
import 'service/floor/clientService.dart';
import 'view/widgets/log_print/log_print_condition.dart';

// 🔔 Notification Plugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final socketService = SocketService();

// 🔙 Background Message Handler
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Uncomment if you want background notifications to show
  // MyNotification.showNotification(message);
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WakelockPlus.enable();
  // 🛡️ Protect screen recording & screenshot

  if (kReleaseMode) {
    await disableScreenCapture();
  }

  // 🌐 Your initial setups
  await getInit();

  // ⚙️ Initialize services
  await initServices();

  // // 📱 Edge-to-edge UI support for Android 10+
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.black,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //     statusBarColor: Colors.black,
  //     statusBarIconBrightness: Brightness.dark,
  //   ),
  // );


  // 🚀 Launch App
  runApp(const MyAppSP());

}

// ❌ Disable screenshots and data leakage
Future<void> disableScreenCapture() async {
  await ScreenProtector.preventScreenshotOn();
  await ScreenProtector.protectDataLeakageOn();
}

// 🔧 All services initialization
Future<void> initServices() async {
  Get.log('Starting services...');

  await GlobalService().updateService();

  try {
    // 🔥 Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 💾 Local Storage
    await GetStorage.init();

    // 🔑 Auth service
    await Get.putAsync(() => AuthService().init());

    //websocket

    // 🔔 Notification
    MyNotification.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    // 🔒 iOS/Android 13+ permissions
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🎯 Foreground Notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // MyNotification.showNotification(message); // Uncomment to show in foreground
    });

    // 🔗 Notification tap (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logPrint("Notification clicked: ${message.data}");
    });

    // 📩 SMS autofill
    SmsAutoFill().listenForCode;
  } catch (e) {
    logPrint("Init error: $e");
  }

  Get.log('All services started...');
}
