import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:stockpathshala_beta/main.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../service/page_manager.dart';
import '../../view/widgets/view_helpers/progress_dialog.dart';
import '../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../view_model/controllers/root_view_controller/quiz_controller/quiz_controller.dart';
import '../../view_model/controllers/root_view_controller/scalp_controller/scalp_controller.dart';
import '../network_calls/dio_client/get_it_instance.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

class MyNotification {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await requestPermissions(flutterLocalNotificationsPlugin);

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'stockpathshala',
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidInitialize = const AndroidInitializationSettings('logo');

    var iOSInitialize = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (NotificationResponse payload) {
      logPrint("notification: init payload data ${payload.payload}");
      try {
        Map<String, dynamic> payloadData =
            json.decode(payload.payload.toString());
        if (payloadData['link_type'] == "pdf") {
          OpenFile.open(payloadData['file_path']);
        } else {
          onRedirection(payloadData);
        }
      } catch (e) {
        logPrint(e.toString());
      }
      return;
    });

    /// subscripbes to specfic topics
    FirebaseMessaging.instance.subscribeToTopic('allUser');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logPrint("notification: listen message data ${message.data}");
      logPrint("notification: listen message data ${message.data.length}");
      logPrint("notification: listen message dataMap ${message.toMap()}");

      /// Adding a Notification badge onChange on Push notification
      /// for seamless experience for user as when a notification arrives it instantly shows on bell icon.
      if (!Get.find<AuthService>().isGuestUser.value) {
        Get.find<HomeController>().getNotificationCount();
        logPrint('notification: count updated');
      }
      if (Platform.isAndroid) {
        MyNotification.showBigTextNotification(
            message, flutterLocalNotificationsPlugin);

        // logPrint('----------------platform id android ----------------------------------');
        // logPrint('----------------platform id android ----------------------------------');
        //
        // if (message.data['user_type'] == "0" && Get.find<AuthService>().isPro == true ) {
        //   logPrint('----------------it is a pro user-----------------${message
        //       .data['user_type']}');
        //   MyNotification.showBigTextNotification(
        //       message, flutterLocalNotificationsPlugin);
        // } else if (message.data['user_type'] == "1" && Get.find<AuthService>().isPro == false ) {
        //   logPrint('----------------it is a non pro user-----------------${message
        //       .data['user_type']}');
        //   MyNotification.showBigTextNotification(
        //       message, flutterLocalNotificationsPlugin);
        // }else if (message.data['user_type'] == "2" ) {
        //   logPrint('----------------it is a all user-----------------');
        //   MyNotification.showBigTextNotification(
        //       message, flutterLocalNotificationsPlugin);
        // }
      }

      if (message.data['link_type'] == "buy_be_a_pro") {
        logPrint(
            '----------------got to getProfile() and be a pro--------------------');
        Get.find<RootViewController>().getProfile();
      }
      if (message.data['link_type'] == "logout") {
        logPrint('----------------logOut Everything--------------------');
        Get.find<AuthService>().logOut();
        Get.offAllNamed(Routes.loginScreen);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logPrint("notification: onAppOpen response ${message.toMap()}");
      try {
        if (message.data.isNotEmpty) {
          Map<String, dynamic> payloadData = message.data;
          onRedirection(payloadData);
        }
      } catch (e) {
        logPrint(e.toString());
      }
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
    String title = message.notification?.title ?? message.data['title'] ?? "";
    String body = message.notification?.body ?? message.data['body'] ?? "";

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'high_importance_channel',
      'stockpathshala',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      icon: 'logo',
      color: Colors.white,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      // ongoing: true
    );
    var iOSInitialize = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSInitialize);
    await fln.show(message.notification?.hashCode ?? 0, title, body,
        platformChannelSpecifics,
        payload: jsonEncode(message.data));
  }

  static Future<void> showTextNotification(
      {required String title,
      required String body,
      required String payload}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'high_importance_channel',
      'stockpathshala',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      icon: 'logo',
      color: Colors.white,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    var iOSInitialize = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<void> showDownloadNotification(NotificationMessageData message,
      FlutterLocalNotificationsPlugin fln) async {
    String title = message.title ?? "";
    String body = message.body ?? "";
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'high_importance_channel',
      'stockpathshala',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      icon: 'logo',
      color: Colors.white,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    var iOSInitialize = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSInitialize);
    await fln.show(message.id ?? 0, title, body, platformChannelSpecifics,
        payload: message.filePath);
  }
}

@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    logPrint(e.toString());
  }
}

class NotificationMessageData {
  String? title;
  String? body;
  String? filePath;
  int? id;
  NotificationMessageData({this.title, this.body, this.id, this.filePath});
}

void saveToolTip() async {
  await Get.find<AuthService>().saveTrainingTooltips('buyNow');
  await Get.find<AuthService>().saveTrainingTooltips('applyCoupon');
  await Get.find<AuthService>().saveTrainingTooltips('joinLiveClass');
  await Get.find<AuthService>().saveTrainingTooltips('registerClass');
  await Get.find<AuthService>().saveTrainingTooltips('registerFirstFreeClass');
  await Get.find<AuthService>().saveTrainingTooltips('classRecordings');
}

onRedirection(Map<String, dynamic> payloadData) async {
  logPrint('notification: onRedirect paylod $payloadData');
  try {
    saveToolTip();
    if (payloadData.isNotEmpty) {
      if (payloadData['link_type'] == "dashboard") {
        Get.toNamed(Routes.dashboardView);
      }
      // else if (payloadData['link_type'] == "sub_batch_class") {
      //   // logPrint('Batch Id : ${payloadData['link_id']} Sub Batch Id : ${payloadData['sub_batch_id']}');
      //   logPrint(
      //       'Batch Id : ${payloadData['batch_id']} Sub Batch Id : ${payloadData['link_id']}');
      //   // Get.toNamed(Routes.)
      // }

      else if (payloadData['link_type'] == "subscription_expired") {
        if (Platform.isAndroid) {
          Get.toNamed(Routes.subscriptionView);
        }
      } else if ([
        'live_class_register',
        'live_class_reminder',
        'live_class_review',
        'live_class'
      ].contains(payloadData['link_type'])) {
        Get.find<RootViewController>().isShow = false.obs;
        AppConstants.instance.liveId.value =
            (payloadData['link_id'].toString());
        Get.toNamed(
            Routes.liveClassDetail(id: payloadData['link_id'].toString()),
            arguments: [
              payloadData['link_type'] == "live_class_review",
              payloadData['link_id'].toString()
            ]);
      } else if (payloadData['link_type'] == 'sub_batch_class') {
        Get.toNamed(Routes.batchDetailsFromNotification,
            arguments: [payloadData['link_id'].toString()]);
      } else if (payloadData['link_type'] == 'batch_class') {
        AppConstants.instance.batchId.value =
            (payloadData['link_id'].toString());
        logPrint("clicked");
        Get.toNamed(Routes.batchClassDetails(id: payloadData['link_id']),
            arguments: [
              payloadData['link_type'] == "batch_class_review",
              payloadData['link_id'].toString()
            ]);
      } else if (payloadData['link_type'] == 'mentorship_page') {
        Get.toNamed(Routes.mentorship);
      } else if (payloadData['link_type'] == 'mentorship') {
        AppConstants.instance.mentorshipId.value =
            (payloadData['link_id'].toString());
        logPrint("clicked ${payloadData['link_id'].toString()}");

        Get.toNamed(
          Routes.mentorshipDetail(
            id: payloadData['link_id'].toString(),
          ),
          arguments: {
            'id': payloadData['link_id'].toString(),
          },
        );
      }
      // else if (payloadData['link_type'] == 'buy_mentorship') {
      //   AppConstants.instance.mentorshipId.value =
      //   (payloadData['link_id'].toString());
      //   logPrint("clicked");
      //   Get.toNamed(Routes.subscriptionView, arguments: {
      //     'isMentorShow': true,
      //     'title': mentorshipData?.mentorshipTitle.toString(),
      //     'price': mentorshipData?.price.toString(),
      //     'daysleft': mentorshipData?.daysLeft == null
      //         ? "0"
      //         : mentorshipData?.daysLeft.toString(),
      //   });
      //
      //   Get.toNamed(Routes.mentorshipDetail(id: payloadData['link_id']),
      //       arguments: [
      //         payloadData['link_id'].toString()
      //       ]);
      // }

      //  else if (payloadData['link_type'] == 'sub_batch_class') {
      //   logPrint(
      //       'batch class data, batch id ${payloadData['link_id']}, sub batch id ${payloadData['sub_batch_id']}');
      // }
      else if (payloadData['link_type'] == "logout") {
        PageManager pageManager = getIt<PageManager>();
        pageManager.stop();
        await pageManager.removeAll();
        pageManager.currentPlayingMedia.value =
            const MediaItem(id: "", title: "");
        Get.offAllNamed(Routes.loginScreen);
        await Get.find<AuthService>().logOut();
      } else if ([
        'audio_review',
        'audio',
        'course_audio',
      ].contains(payloadData['link_type'])) {
        Get.toNamed(
          Routes.audioCourseDetail(id: payloadData['link_id'] as String? ?? ''),
          arguments: [
            payloadData['link_type'] == "course_audio"
                ? CourseDetailViewType.audioCourse
                : CourseDetailViewType.audio,
            payloadData['link_id'] as String? ?? '',
            "",
            ""
          ],
        )?.then((value) =>
            Get.find<HomeController>().getContinueLearning(isFirst: true));
      } else if ([
        'blog_review',
        'blog',
      ].contains(payloadData['link_type'])) {
        AppConstants.instance.blogId.value =
            (payloadData['link_id'].toString());
        Get.toNamed(Routes.blogsView(id: payloadData['link_id'].toString()),
            arguments: [payloadData['link_id'].toString(), ""]);
      } else if ([
        'video_review',
        'video',
      ].contains(payloadData['link_type'])) {
        AppConstants.instance.singleCourseId.value =
            (payloadData['link_id'].toString());
        Get.toNamed(
            Routes.continueWatchScreen(id: payloadData['link_id'].toString()),
            arguments: [payloadData['link_id'].toString(), ""]);
      } else if (payloadData['link_type'] == "course_video") {
        AppConstants.instance.videoCourseId.value =
            (payloadData['link_id'].toString());

        Get.toNamed(
            Routes.videoCourseDetail(id: payloadData['link_id'].toString()),
            arguments: ["", payloadData['link_id'].toString()]);
      } else if (payloadData['link_type'] == "course_text") {
        Get.toNamed(
            Routes.textCourseDetail(id: payloadData['link_id'].toString()),
            arguments: ["", payloadData['link_id'].toString()]);
      } else if (payloadData['link_type'] == "pro_page") {
        if (Platform.isAndroid) {
          Get.toNamed(Routes.subscriptionView);
        }
      } else if ([
        'short_review',
        'short_comment',
      ].contains(payloadData['link_type'])) {
        Get.find<RootViewController>().selectedTab.value = 3;
        Get.find<ScalpController>().fromScalp.value = true;
        Get.find<ScalpController>()
            .onSingleRedirectByID(payloadData['link_id'].toString());
      } else if (payloadData['link_type'] == 'past_live_classes_page') {
        if (!Get.find<AuthService>().isPro.value) {
          ProgressDialog().showFlipDialog(
            isForPro: true,
            title: 'Quickly Buy Pro to access Class Recordings.',
            actionTitle: 'Buy Now',
          );
        } else {
          if (Get.find<AuthService>().isPro.value &&
              !Get.find<AuthService>().isGuestUser.value) {
            Get.toNamed(Routes.pastLiveClass);
          }
        }
      } else if (payloadData['link_type'] == 'specific_past_live_class') {
        if (!Get.find<AuthService>().isPro.value) {
          ProgressDialog().showFlipDialog(
            isForPro: true,
            title: 'Quickly Buy Pro to access Class Recordings.',
            actionTitle: 'Buy Now',
          );
        } else {
          AppConstants.instance.liveId.value = (payloadData['link_id']);
          Get.toNamed(
              Routes.liveClassDetail(
                id: payloadData['link_id'],
              ),
              arguments: [true, payloadData['link_id']]);
        }
      } else if (payloadData['link_type'] == 'course_page') {
        Get.find<RootViewController>().selectedTab.value = 1;
      } else if (payloadData['link_type'] == 'quiz') {
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.quizzesView);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            Get.toNamed(Routes.quizMainView, arguments: {
              "id": payloadData['link_id'],
            })!
                .then((value) {
              Get.find<QuizController>().getQuiz(
                1,
              );
            });
            Get.find<QuizController>().getQuizById(payloadData['link_id']);
            // Get.find<QuizController>().quizType.value =
            // data.isScholarship == 1 ? QuizType.scholarship : QuizType.free;
            // Get.find<QuizController>().isTimeUp.value = false;
          });
        } else {
          ProgressDialog().showFlipDialog(isForPro: false);
        }
      } else if (payloadData['link_type'] == 'live_class_page') {
        Get.find<RootViewController>().selectedTab.value = 3;
      } else {
        Get.toNamed(Routes.rootView);
      }
    } else {
      Get.toNamed(Routes.rootView);
    }
  } catch (e, st) {
    logPrint('$e,$st');
  }
}
