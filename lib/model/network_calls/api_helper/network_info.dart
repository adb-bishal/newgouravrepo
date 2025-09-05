// import 'dart:io';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
//
// import '../../../view/widgets/log_print/log_print_condition.dart';
//
// class NetworkInfo {
//   final Connectivity connectivity;
//
//   NetworkInfo(this.connectivity);
//
//
//   Future<bool> get isConnected async {
//
//     ConnectivityResult result = (await connectivity.checkConnectivity()) as ConnectivityResult;
//     return result != ConnectivityResult.none;
//   }
//
//   void checkConnectivity(BuildContext context) {
//     bool firstTime = true;
//
//     connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
//       logPrint("Connectivity result: $result");
//
//       if (!firstTime) {
//         bool isNotConnected = result == ConnectivityResult.none
//             ? true
//             : !(await _updateConnectivityStatus());
//
//         logPrint("Is not connected: $isNotConnected");
//
//         // Display a snackbar to indicate the connectivity status
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: isNotConnected ? Colors.red : Colors.green,
//           duration: Duration(seconds: isNotConnected ? 10 : 3),
//           content: Text(
//             isNotConnected ? "No Connection" : "Connected",
//             textAlign: TextAlign.center,
//           ),
//         ));
//       }
//
//       firstTime = false;
//     } as void Function(List<ConnectivityResult> event)?);
//   }
//
//   Future<bool> _updateConnectivityStatus() async {
//     try {
//       final List<InternetAddress> result =
//       await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         return true;
//       }
//     } catch (e) {
//       logPrint("Error during connectivity check: $e");
//     }
//     return false;
//   }
// }
