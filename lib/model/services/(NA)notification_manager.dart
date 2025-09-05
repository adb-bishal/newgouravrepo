import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

class NotificationManager {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    //Get Firebase token
    // FirebaseMessaging.instance.getToken().then((token) {
    //   'firebase token : $token'.printLog();
    //   Get.find<AuthService>().fcmToken.value = token??'';
    // });

    //requesting notification permission
    await requestPermissions(flutterLocalNotificationsPlugin);

    /*----------*** this triggered when app is background ***-----*/
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    var androidInitialize = const AndroidInitializationSettings('logo');
    var iosInitialize = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,);
        // onDidReceiveLocalNotification:
        //     (int id, String? title, String? body, String? payload) {});
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    if (Platform.isIOS) {
      messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveBackgroundNotificationResponse: onBackgroundMessageTopLevel,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      //"onDidReceiveNotificationResponse: ${response.payload}".printLog();
      // NotificationRedirection.redirect(json.decode(response.payload??''));
    });

    /*----------*** this triggered when app is foreground ***-----*/
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // this when app is foreground
      //"On Message Listen ${message.toMap().toString()}".printLog();
      try {
        //AuthService.find().getNotificationCount();
      } catch (e) {
        // e.printLog();
      }

      notificationRedirectionFunction(message);

      if (message.notification != null &&
          message.notification?.title != null &&
          message.notification?.body != null) {
        showBigTextNotification(message, flutterLocalNotificationsPlugin);
      }
    });

    //when background  message clicked
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // "on Message App: ${message.data}".printLog();
      // NotificationRedirection.redirect(message.data);
    });
  }

  static Future<void> requestPermissions(
      flutterLocalNotificationsPlugin) async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  static Future<void> showBigTextNotification(
      RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    String title = message.notification?.title ?? '';
    String body = message.notification?.body ?? '';
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications',
      importance: Importance.max,
      playSound: true,
      icon: 'logo',
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    var iOSInitialize = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSInitialize);
    await fln.show(
        DateTime.now().microsecond, title, body, platformChannelSpecifics,
        payload: json.encode(message.data));
  }
}

Function(RemoteMessage message)
    get notificationRedirectionFromBackgroundFunction =>
        (RemoteMessage message) async {
          //"on redirection background Function :${message.data}".printLog();

          if (message.data.isNotEmpty &&
              message.data['link_type'] == 'logout') {
            try {
              /*await _init();
        await LoginUtil.deleteUser();*/
              IsolateNameServer.lookupPortByName('notification_port')
                  ?.send('logout');

              /// register
            } catch (e) {
              e.printError();
              e.printInfo();
            }
          } else if (message.data.isNotEmpty &&
              message.data['link_type'] == 'force_logout') {
            try {
              /* await _init();
        await LoginUtil.deleteUser();*/
              IsolateNameServer.lookupPortByName('notification_port')
                  ?.send('force_logout');
            } catch (e) {
              e.printError();
              e.printInfo();
            }
          }
        };

Function(RemoteMessage message) get notificationRedirectionFunction =>
    (RemoteMessage message) async {
      // "on Function :${message.data}".printLog();
      //
      // if(message.data.isNotEmpty && message.data['link_type'] == 'logout'){
      //   try {
      //     await LoginUtil.deleteUser();
      //     await AuthService.find().reloadData();
      //     Get.offAllNamed(Routes.loginScreen);
      //   } catch (e) {
      //     e.printError();
      //     e.printInfo();
      //   }
      //
      // }
      // else if(message.data.isNotEmpty && message.data['link_type'] == 'force_logout') {
      //   try {
      //     await LoginUtil.deleteUser();
      //     await AuthService.find().reloadData();
      //     Get.offAllNamed(Routes.loginScreen);
      //
      //   } catch (e) {
      //     e.printError();
      //     e.printInfo();
      //   }
      // }
    };

void onBackgroundMessageTopLevel(NotificationResponse response) {
  //"onDidReceiveBackgroundNotificationResponse: ${response.payload}".printLog();
}

Future<dynamic> onBackgroundMessage(RemoteMessage message) async {
  //notification only auto show

  // 'remoteMsg: ${message.toMap()}'.printLog();
  // 'background: ${message.data}'.printLog();
  if (!Get.find<AuthService>().isGuestUser.value) {
    Get.find<HomeController>().getNotificationCount();
    logPrint('notification: count updated');
  }

  notificationRedirectionFromBackgroundFunction.call(message);
}

class SingletonGlobal {
  static SingletonGlobal? _instace;

  static SingletonGlobal get instance => _instace ??= SingletonGlobal._();

  // Whatever private constructor you're using for this singleton
  SingletonGlobal._() {
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'notification_port');
    _receivePort.listen((message) {
      logoutStreamController.add(message);
    });
  }

  final StreamController<String> logoutStreamController =
      StreamController<String>.broadcast();
  final _receivePort = ReceivePort();

/*  void addLogoutEvent(String key) {
    logoutStreamController.add(key);
  }*/
}
