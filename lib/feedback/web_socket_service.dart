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

  String? accessToken;
  Map<String, dynamic>? userData;
  String? currentPath;

  void connect(
      {String? accessToken, Map<String, dynamic>? userData, String? pathName}) {
    if (socket != null) return;

    accessToken = accessToken;
    userData = userData;
    currentPath = pathName;

    socket = IO.io('https://ws.stockpathshala.in', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.connect();

    socket?.on('connect', (_) {
      if (accessToken != null && userData?['id'] != null) {
        if (kDebugMode) {
          print('connected from socket $accessToken ${userData?['id']}');
          // questionApi();
        }
        socket?.emit('user_online', userData!['id']);
      }
    });

    socket?.on('get_class_feedback', (data) {
      final classDetails = data['class_details'];
      if (classDetails != null) {
        // addEventToBuffer({
        //   'eventName': 'get_live_class_feedback',
        //   'class_details': classDetails,
        //   'userId': userData?['id'],
        //   'userName': userData?['name'],
        // });
        questionApi(userData: userData,classDetails: classDetails);
      }
    });

    socket!.on('disconnect', (_) {
      print('Disconnected from socket server');
    });

    socket!.on('error', (error) {
      print('Socket error: $error');
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

  void updateCurrentPath(String? pathName) {
    currentPath = pathName;
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

  void _showPopup(List<QuestionData>? questions, Map<String, dynamic>? userData, classDetails) {
    if (navigatorKey.currentState == null) return;

    final context = navigatorKey.currentState!.overlay!.context;

    showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(14),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: GlobalSocketPopup(questionList: questions,userData:userData,classDetails:classDetails),
            ));
  }

  bool get isConnected => socket?.connected ?? false;

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
              _showPopup(questions,userData,classDetails);
            }
          }
      });
    } catch (e) {
      print(e);
    }
    return null;
  }
}
