import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stockpathshala_beta/feedback/QuestionModel.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/home_provider.dart';

import 'global_socket_popup.dart';
import '../main.dart';
import '../model/network_calls/dio_client/get_it_instance.dart';

class SocketService {
  static final SocketService instance = SocketService.internal();

  factory SocketService() {
    return instance;
  }

  SocketService.internal();
  HomeProvider homeProvider = getIt();
  IO.Socket? socket;

  Map<String, dynamic>? userData;

  void connect({Map<String, dynamic>? userData}) {
    if (socket != null) {
      socket!.disconnect();
      socket!.destroy();
      socket = null;
      print("🔌 Previous socket disconnected and destroyed");
    }

    socket = IO.io('https://ws.stockpathshala.in', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.connect();

    socket?.on('connect', (_) {
      if (userData?['id'] != null) {
        print('Connected to socket as user: ${userData?['id']}');
        socket?.emit('user_online', userData!['id']);
        // questionApi();
      }
    });

    socket?.on('get_class_feedback', (data) {
      print("📩 get_class_feedback received: $data");
      final classDetails = data['class_details'];
      if (classDetails != null) {
        questionApi(userData: userData, classDetails: classDetails);
      }
    });

    socket!.on('disconnect', (_) {
      print('⚠️ Disconnected from socket server');
    });

    socket!.on('error', (error) {
      print('❌ Socket error: $error');
    });

    socket!.on('connect_error', (error) {
      print('❗ Socket connect error: $error');
    });
  }

  void addEventToBuffer(Map<String, dynamic> eventData) {
    // TODO: Implement your buffer logic here
    print('Adding event to buffer: $eventData');
  }

  void updateUserData(Map<String, dynamic>? userData) {
    userData = userData;
  }

  void updateAccessToken(String? accessToken) {
    accessToken = accessToken;
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void emit(String event, dynamic data) {
    socket?.emit(event, data);
  }

  void disconnect() {
    socket?.dispose();
    socket = null;
  }

  void _showPopup(List<QuestionData>? questions, Map<String, dynamic>? userData,
      classDetails) {
    if (navigatorKey.currentState == null) return;

    final context = navigatorKey.currentState!.overlay!.context;

    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (_) => Dialog(
              insetPadding: const EdgeInsets.all(14),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: GlobalSocketPopup(
                  questionList: questions,
                  userData: userData,
                  classDetails: classDetails),
            ));
  }

  bool get isConnected => socket?.connected ?? false;
  void showFeedbackSubmittedDialog(BuildContext context) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Feedback submitted successfully',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1,
            child: child,
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // dismiss dialog after 3 seconds
    });
  }

  Future<List<QuestionData>?> questionApi(
      {Map<String, dynamic>? userData, classDetails}) async {
    try {
      await homeProvider.getQuestionsForFeedback(onError: (onError, json) {
        print("questions List $onError");
      }, onSuccess: (onSuccess, json) {
        if (json != null) {
          var dataList = json['data'] as List<dynamic>?;

          if (dataList != null) {
            List<QuestionData> questions = dataList
                .map((item) =>
                    QuestionData.fromJson(item as Map<String, dynamic>))
                .toList();

            if (kDebugMode) {
              print('questions List: $questions');
            }
            _showPopup(questions, userData, classDetails);
          }
        }
      });
    } catch (e) {
      print(e);
    }
    return null;
  }
}
