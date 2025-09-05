// import 'package:audio_manager/audio_manager.dart';
// import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
//
// import '../../../view/widgets/log_print/log_print_condition.dart';
//
// class AudioPlayerUtil {
//   static AudioPlayerUtil? _instance;
//
//   static AudioPlayerUtil get instance =>
//       _instance ??= AudioPlayerUtil._init();
//
//   AudioPlayerUtil._init();
//
//  // late AudioManager audioManagerInstance ;
//    late  double _slider;
//    late  bool  _isPlaying;
//   late  int? _loggedInUserID;
//   //late  Function(ChatModel message)? _onMessageReceiveFunction;
//   late  Function(Map<String,dynamic> message)? onMessageReceiveFunction;
//
//   Function(Map<String,dynamic> message)? onReceive;
//
//   initListener(Function(Map<String,dynamic> message)? onReceive){
//     this.onReceive = onReceive;
//   }
//   removeListener(){
//     onReceive =null;
//   }
//
//   //  Future<void> initSocketEvent({required Function(ChatModel message) onMessageReceiveFunction,required int groupID,required int  loggedInUserID}) async {
//   Future<void> initAudioEvent({required Function(double sliderVal,Duration postion,Duration duration) onSliderValue,required Function(bool isPlaying) onPlayStatus,}) async {
//     _slider = 0;
//     _isPlaying = false;
//     //_loggedInUserID = loggedInUserID;
//     // _onMessageReceiveFunction = onMessageReceiveFunction;
//
//     //audioManagerInstance = AudioManager.instance;
//     AudioManager.instance.intercepter = true;
//     PlayMode playMode = AudioManager.instance.playMode;
//     AudioManager.instance.onEvents((events, args) {
//       logPrint("Events => $events");
//       logPrint("Args = > $args");
//       switch (events) {
//         case AudioManagerEvents.start:
//          logPrint(
//               "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
//           // _position = AudioManager.instance.position;
//           // _duration = AudioManager.instance.duration;
//           _slider = 0;
//           onSliderValue.call(_slider,AudioManager.instance.position,AudioManager.instance.duration);
//           AudioManager.instance.updateLrc("audio resource loading....");
//           break;
//         case AudioManagerEvents.seekComplete:
//           _slider = AudioManager.instance.position.inMilliseconds /
//               AudioManager.instance.duration.inMilliseconds;
//           onSliderValue.call(_slider,AudioManager.instance.position,AudioManager.instance.duration);
//           break;
//         case AudioManagerEvents.playstatus:
//           _isPlaying = AudioManager.instance.isPlaying;
//           onPlayStatus.call(_isPlaying);
//           break;
//         case AudioManagerEvents.timeupdate:
//           _slider = AudioManager.instance.position.inMilliseconds / AudioManager.instance.duration.inMilliseconds;
//           AudioManager.instance.updateLrc(args["position"].toString());
//           onSliderValue.call(_slider,AudioManager.instance.position,AudioManager.instance.duration);
//           break;
//         case AudioManagerEvents.ended:
//           AudioManager.instance.next();
//           break;
//         default:
//           break;
//       }
//     });
//   }
//
//   onChangedEnd(double value)async {
//     if (AudioManager.instance.duration != null) {
//      logPrint("fsdfsf f");
//     try{
//       Duration msec = Duration(milliseconds: (AudioManager.instance.duration.inMilliseconds * value).round());
//      await AudioManager.instance.seekTo(msec);
//     }catch(e){
//      logPrint("seek error $e");
//     }
//     }
//   }
//
//   onStartAudio({required String url,required String songTitle,required String songDescription,required String coverUrl,bool autoPlay = true})async{
//    await AudioManager.instance
//         .start(url, songTitle,
//         desc: songDescription,
//         auto: autoPlay,
//         cover: coverUrl)
//         .then((err) {
//           toastShow(message: err,error: true);
//     });
//   }
//
//   onPlayOrPause()async{
//     logPrint(AudioManager.instance.isPlaying);
//     await AudioManager.instance.playOrPause();
//   }
//
//   onDisconnect(){
//     AudioManager.instance.stop();
//   }
//
// }