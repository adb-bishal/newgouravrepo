import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stockpathshala_beta/service/floor/entity/download.dart';
import 'package:stockpathshala_beta/service/models/downloaded_file_model.dart';
import 'package:stockpathshala_beta/service/utils/object_extension.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../model/network_calls/dio_client/get_it_instance.dart';
import '../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../enum/routing/routes/app_pages.dart';
import 'audio_handler.dart';

enum ButtonState {
  paused,
  playing,
  loading,
}

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ''.obs;
  final currentPlayingMedia = const MediaItem(id: '', title: '').obs;

  final playlistNotifier = <String>[].obs;
  final progressNotifier = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  ).obs;
  final repeatButtonNotifier = RepeatState.off.obs;
  final isFirstSongNotifier = true.obs;
  final playButtonNotifier = ButtonState.paused.obs;
  final isLastSongNotifier = true.obs;
  final isShuffleModeEnabledNotifier = false.obs;
  final _audioHandler = getIt<MyAudioHandler>();

  init() {
    logPrint("OnInIt Called");
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToNotificationState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  onDisposeListener() async {
    _audioHandler.queue.onCancel;
    _audioHandler.playbackState.onCancel;
    _audioHandler.mediaItem.onCancel;
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();
  void seek(Duration position) => _audioHandler.seek(position);
  void skipToQueueItem(int index) => _audioHandler.skipToQueueItem(index);
  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();
  void repeat() {
    final next =
        (repeatButtonNotifier.value.index + 1) % RepeatState.values.length;
    repeatButtonNotifier.value = RepeatState.values[next];

    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      logPrint('pppstate ${playbackState.processingState}');
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
        logPrint('ppstate 1 ${playbackState.processingState}');
      } else if (!isPlaying) {
        logPrint('ppstate 2 ${!isPlaying}');

        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        if (processingState == AudioProcessingState.idle) {
          playButtonNotifier.value = ButtonState.paused;
        } else {
          playButtonNotifier.value = ButtonState.playing;
        }
      } else {
        logPrint('ppstate 4 ${!isPlaying}');

        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToNotificationState() {
    // AudioService.notificationClicked.listen((notificationState) {
    //   if (notificationState) {
    //     Get.toNamed(
    //         Routes.audioCourseDetail(
    //             id: currentPlayingMedia.value.id.toString()),
    //         arguments: [
    //           'single' != currentPlayingMedia.value.extras?['type']
    //               ? CourseDetailViewType.audioCourse
    //               : CourseDetailViewType.audio,
    //           'single' != currentPlayingMedia.value.extras?['type']
    //               ? (currentPlayingMedia.value.extras?['course_id'] ?? "")
    //               : (currentPlayingMedia.value.id.toString()),
    //           "",
    //           ""
    //         ]);
    //   }
    // });
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
        currentPlayingMedia.value = const MediaItem(id: '', title: '');
        //logPrint(
        //     "List Play ${playlistNotifier} ${currentPlayingMedia.value.toString()}");
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;

        //logPrint("List Play ${playlistNotifier}");
      }
      _updateSkipButtons();
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      currentPlayingMedia.value =
          mediaItem ?? const MediaItem(id: '', title: '');
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  Future<void> add(String id, String title, String url,
      {String? albumCover, String? album}) async {
    try {
      final mediaItem = MediaItem(
        id: id,
        album: album ?? '',
        title: title,
        extras: {'url': url, 'image': albumCover ?? ''},
      );
      _audioHandler.addQueueItem(mediaItem);
    } on PlayerException catch (e) {
      toastShow(message: '$e Audio not found.');
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
    } on PlayerInterruptedException catch (e) {
      toastShow(message: ' $e Audio not found.');

      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
    } catch (e) {
      //toastShow(message: 'Audio not found.');
      // Fallback for all other errors
    }
  }

  Future<void> playLocalFile() async {
    try {
      await _audioHandler.playLocalFile(
          "/Users/deorwine19/Library/Developer/CoreSimulator/Devices/AED0D2B0-9F26-4E26-BF15-4DBC1A5D01D0/data/Containers/Data/Application/B6512E8A-ECFE-4F63-BEF9-DDE0EAC5BB61/Library/Caches/StContent/AudioCourses/1171688636600159.mp3");
      await _audioHandler.play();
    } catch (e) {
      logPrint("error $e");
    }
  }

  Future<void> playSingleCourse(
      String id,
      String type,
      String title,
      String url,
      String image,
      String catId,
      String catName,
      bool isFile) async {
    logPrint("play single course url $url");
    try {
      await removeAll();
      final mediaItem = MediaItem(
        id: id,
        album: catName,
        title: title,
        artUri: Uri.parse(image),
        extras: {
          'url': url,
          'image': image,
          'type': type,
          'cat_id': catId,
          'cat_name': catName,
          "is_file": isFile
        },
      );
      await _audioHandler.addQueueItem(mediaItem);
      logPrint("play single course url 2 $url");
    } on PlayerException catch (e) {
      logPrint("error in player $e");
      toastShow(message: 'Audio not found.');
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
    } on PlayerInterruptedException catch (e) {
      logPrint("error in PlayerInterruptedException $e");
      toastShow(message: 'Audio not found.');

      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
    } catch (e) {
      logPrint("error in try $e");
      //toastShow(message: 'Audio not found.');
      // Fallback for all other errors
    }
  }

  Future<void> playCourse(
      {required List<AudioCourseFile> courseContentList,
      required String type}) async {
    try {
      await removeAll();

      for (int i = 0; i < courseContentList.length; i++) {
        AudioCourseFile courseFile = courseContentList[i];

        final mediaItem = MediaItem(
          id: courseFile.id,
          album: courseFile.courseName,
          title: courseFile.name,
          artUri: Uri.parse(courseFile.imagePath),
          extras: {
            'url': courseFile.fileLocalPath,
            'image': courseFile.imagePath,
            'type': type,
            'cat_id': courseFile.catId,
            'cat_name': courseFile.catName,
            'course_id': courseFile.courseId,
            'course_name': courseFile.courseName,
            'is_file': courseFile.isFile
          },
        );

        mediaItem.toString().printLog(message: 'media');

        await _audioHandler.addQueueItem(mediaItem);
      }
    } on PlayerException catch (e) {
      toastShow(message: ' $e Audio not found.');
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
    } on PlayerInterruptedException catch (e) {
      toastShow(message: ' $e Audio not found.');

      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
    } catch (e) {
      //toastShow(message: 'Audio not found.');
      // Fallback for all other errors
    }
  }

  Future<void> playOfflineCourse(
      {required courseId,
      required List<DownloadedFileModel> courseList,
      required String courseTitle,
      required String type}) async {
    try {
      await removeAll();

      for (int i = 0; i < courseList.length; i++) {
        String? id = courseList[i].path.toString();
        String? title = courseList[i].name;
        String? url = courseList[i].path;
        String? courseID = courseId.toString();
        String? albumCover = courseList[i].imagePath.toString();

        final mediaItem = MediaItem(
          id: id,
          album: courseTitle,
          title: title ?? '',
          extras: {
            'url': url,
            'image': albumCover,
            'type': type,
            'course_id': courseID
          },
        );
        await _audioHandler.addQueueItem(mediaItem);
      }
    } on PlayerException catch (e) {
      toastShow(message: '$e Audio not found.');
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
    } on PlayerInterruptedException catch (e) {
      toastShow(message: '$e Audio not found.');

      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
    } catch (e) {
      //toastShow(message: 'Audio not found.');
      // Fallback for all other errors
    }
  }

  Future<void> playBlog(
      {required String url,
      required String title,
      required String imageUrl}) async {
    try {
      await removeAll();
      final mediaItem = MediaItem(
        id: 'blog',
        album: '',
        title: title,
        artUri: Uri.parse(imageUrl),
        extras: {'url': url},
      );
      await _audioHandler.addQueueItem(mediaItem);
    } on PlayerException catch (e) {
      toastShow(message: '$e Audio not found.');
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
    } on PlayerInterruptedException catch (e) {
      toastShow(message: '$e Audio not found.');

      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
    } catch (e) {
      //toastShow(message: 'Audio not found.');
      // Fallback for all other errors
    }
  }

  Future<void> removeAll() {
    return _audioHandler.removeAll();

    /* final length = _audioHandler.queue.value.length;
    logPrint('Que_Lenth $length');
    for(int i=0; i< length;i++){
      await _audioHandler.removeQueueItemAt(i);
      logPrint('Que_indedx $i');
    }*/
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  dispose() {
    _audioHandler.customAction('dispose');
  }

  stop() async {
    await _audioHandler.stop();
    //  await removeAll();
    currentPlayingMedia.value = const MediaItem(id: '', title: '');
  }
}
