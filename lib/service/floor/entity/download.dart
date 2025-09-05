
// entity/person.dart

import 'package:floor/floor.dart';


// required package imports
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'download.g.dart';


// create migration
final migration1to2 = Migration(1, 3, (database) async {
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `Video` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `VideoCourseFolder` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `folderPath` TEXT NOT NULL, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `VideoCourseFile` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `courseId` TEXT NOT NULL, `courseName` TEXT NOT NULL, `catId` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');

  await database.execute(
      'CREATE TABLE IF NOT EXISTS `Download` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');

});


final migration1to3 = Migration(2, 3, (database) async {
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `Video` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `VideoCourseFolder` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `folderPath` TEXT NOT NULL, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `VideoCourseFile` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `courseId` TEXT NOT NULL, `courseName` TEXT NOT NULL, `catId` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `Download` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');


});

class DbInstance{
  static Future<AppDatabase> instance() async {
     return await $FloorAppDatabase.databaseBuilder('stock_pathshala_app_database.db')
         .addMigrations([migration1to2,migration1to3])
         .build();
  }

}

@Database(version: 3, entities: [Audio,AudioCourseFolder,AudioCourseFile,Video,VideoCourseFolder,VideoCourseFile,DownloadQueue])
abstract class AppDatabase extends FloorDatabase {
  AudioDao get audioDao;
  VideoDao get videoDao;
  DownloadQueueDao get downloadQueDao;

  AudioCourseFolderDao get audioCourseFolderDao;
  VideoCourseFolderDao get videoCourseFolderDao;


  AudioCourseFileDao get audioCourseFileDao;
  VideoCourseFileDao get videoCourseFileDao;

}

@entity
class Audio {
  @primaryKey
  final String id;
  final String catId;
  String name;
  String catName;
  String imagePath;
  String fileLocalPath;
  String fileUrl;
  String rating;

  Audio(this.id, this.catId, this.name,this.catName,this.imagePath,this.fileLocalPath,this.fileUrl,this.rating);
}


@entity
class AudioCourseFolder {
  @primaryKey
  final String id;
  final String catId;
  String name;
  final String catName;
  String imagePath;
  String folderPath;
  String chapterId;
  String courseId;
  String rating;

  AudioCourseFolder(this.id,this.catId, this.name,this.catName,this.imagePath,this.folderPath,this.chapterId,this.courseId,this.rating);
}

@entity
class AudioCourseFile {
  @primaryKey
    final String id;
   String name;
   String courseId;
   String courseName;
   String catId;
   String catName;
   String imagePath;
   String fileLocalPath;
   String fileUrl;
   String rating;
   bool isFile;

  AudioCourseFile(this.id,this.catId,this.courseId,this.name,this.catName, this.courseName,this.imagePath,this.fileLocalPath,this.fileUrl,this.rating,this.isFile);
}



@entity
class Video {
  @primaryKey
  final String id;
  final String catId;
  String name;
  String catName;
  String imagePath;
  String fileLocalPath;
  String fileUrl;
  String rating;

  Video(this.id, this.catId, this.name,this.catName,this.imagePath,this.fileLocalPath,this.fileUrl,this.rating);
}

@entity
class DownloadQueue {
  @primaryKey
  String contentId;
  String? folderName;
  String? fileUrl;
  String? fileName;
  String? type;
  String? catId;
  String? catName;
  String? courseId;
  String? courseName;
  String? courseImage;
  String? videoId;
  String? videoName;
  String? videoImage;
  String? videoDuration;
  String? fileType;
  String? audioId;
      String? audioName;
  String? audioImage;
  String? rating;

  DownloadQueue(
      {required this.contentId,
        this.folderName,
        this.fileUrl,
        this.fileName,
        this.type,
        this.catId,
        this.catName,
        this.courseId,
        this.courseName,
        this.courseImage,
        this.videoId,
        this.videoName,
        this.videoImage,
        this.videoDuration,
        this.fileType,
      this.audioId,
        this.audioImage,
        this.audioName,
        this.rating
      });

}


@entity
class VideoCourseFolder {
  @primaryKey
  final String id;
  final String catId;
  String name;
  final String catName;
  String imagePath;
  String folderPath;
  String rating;

  VideoCourseFolder(this.id,this.catId, this.name,this.catName,this.imagePath,this.folderPath,this.rating);
}

@entity
class VideoCourseFile {
  @primaryKey
  final String id;
  String name;
  String courseId;
  String courseName;
  String catId;
  String catName;
  String imagePath;
  String duration;
  String fileLocalPath;
  String fileUrl;
  String rating;

  VideoCourseFile(this.id,this.catId,this.courseId,this.name,this.catName, this.courseName,this.imagePath,this.duration,this.fileLocalPath,this.fileUrl,this.rating);
}


@dao
abstract class AudioDao {
  @Query('SELECT * FROM Audio')
  Future<List<Audio>> findAllAudio();

  @Query('SELECT * FROM Audio WHERE id = :id')
  Future<Audio?> findById(String id);

  @Query('DELETE FROM Audio')
  Future<void> clearAllAudio();

  @Query('SELECT * FROM Audio WHERE catId IN (:catIds)')
  Future<List<Audio>> filterAllAudio(List<String?> catIds);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(Audio audio);
}

@dao
abstract class DownloadQueueDao {
  @Query('SELECT * FROM DownloadQueue')
  Future<List<DownloadQueue>> findAllDownload();

  @Query('SELECT * FROM DownloadQueue WHERE videoId = :id')
  Future<DownloadQueue?> findById(String id);

  @Query('DELETE FROM Audio')
  Future<DownloadQueue?> clearAllDownload();

  @Query('SELECT * FROM DownloadQueue WHERE audioId = :id')
  Future<DownloadQueue?> findAudioById(String id);

  @Query('SELECT * FROM DownloadQueue WHERE courseId = :courseId')
  Future<List<DownloadQueue?>> findCourseFile(String courseId);

  @delete
  Future<void> deletePerson(DownloadQueue person);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(DownloadQueue download);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<DownloadQueue> download);
}

@dao
abstract class AudioCourseFolderDao {
  @Query('SELECT * FROM AudioCourseFolder')
  Future<List<AudioCourseFolder>> findAllAudioFolder();

  @Query('DELETE FROM AudioCourseFolder')
  Future<void> clearAllAudioCourseFolder();

  @Query('SELECT * FROM AudioCourseFolder WHERE id = :id')
  Future<AudioCourseFolder?> findById(String id);

  @Query('SELECT * FROM AudioCourseFolder WHERE catId IN (:catIds)')
  Future<List<AudioCourseFolder>> filterAllAudioCourse(List<String?> catIds);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(AudioCourseFolder audioCourseFolder);
}


@dao
abstract class AudioCourseFileDao {
  @Query('SELECT * FROM AudioCourseFile')
  Future<List<AudioCourseFile>> findAllAudioFolder();

  @Query('DELETE FROM AudioCourseFile')
  Future<void> clearAllAudioCourseFile();

  @Query('SELECT * FROM AudioCourseFile WHERE id = :id AND courseId = :courseId')
  Future<AudioCourseFile?> findById(String id,String courseId);

  @Query('SELECT * FROM AudioCourseFile WHERE courseId = :courseId')
  Future<List<AudioCourseFile>?> findCourseContent(String courseId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(AudioCourseFile audioCourseFile);
}


@dao
abstract class VideoDao {
  @Query('SELECT * FROM Video')
  Future<List<Video>> findAllVideo();

  @Query('DELETE FROM Video')
  Future<void> clearAllVideo();

  @Query('SELECT * FROM Video WHERE id = :id')
  Future<Video?> findById(String id);

  @Query("SELECT * FROM Video WHERE catId IN (:catIds)")
  Future<List<Video>> filterAllVideo(List<String?> catIds);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(Video video);
}



@dao
abstract class VideoCourseFolderDao {
  @Query('SELECT * FROM VideoCourseFolder')
  Future<List<VideoCourseFolder>> findAllVideoFolder();

  @Query('SELECT * FROM VideoCourseFolder WHERE id = :id')
  Future<VideoCourseFolder?> findById(String id);

  @Query('DELETE FROM VideoCourseFolder')
  Future<void> clearAllVideoCourseFolder();

  @Query('SELECT * FROM VideoCourseFolder WHERE catId IN (:catIds)')
  Future<List<VideoCourseFolder>> filterAllVideo(List<String?> catIds);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(VideoCourseFolder videoCourseFolder);
}


@dao
abstract class VideoCourseFileDao {

  @Query('DELETE FROM VideoCourseFile')
  Future<void> clearAllVideoCourseFile();

  @Query('SELECT * FROM VideoCourseFile')
  Future<List<VideoCourseFile>> findAllVideoFiles();

  @Query('SELECT * FROM VideoCourseFile WHERE id = :id AND courseId = :courseId')
  Future<VideoCourseFile?> findById(String id,String courseId);

  @Query('SELECT * FROM VideoCourseFile WHERE courseId = :courseId')
  Future<List<VideoCourseFile>?> findCourseContent(String courseId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(VideoCourseFile videoCourseFile);
}

