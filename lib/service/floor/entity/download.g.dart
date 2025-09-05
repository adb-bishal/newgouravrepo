// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AudioDao? _audioDaoInstance;

  VideoDao? _videoDaoInstance;

  DownloadQueueDao? _downloadQueDaoInstance;

  AudioCourseFolderDao? _audioCourseFolderDaoInstance;

  VideoCourseFolderDao? _videoCourseFolderDaoInstance;

  AudioCourseFileDao? _audioCourseFileDaoInstance;

  VideoCourseFileDao? _videoCourseFileDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Audio` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, `rating` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AudioCourseFolder` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `folderPath` TEXT NOT NULL, `chapterId` TEXT NOT NULL, `courseId` TEXT NOT NULL, `rating` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AudioCourseFile` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `courseId` TEXT NOT NULL, `courseName` TEXT NOT NULL, `catId` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, `rating` TEXT NOT NULL, `isFile` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Video` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, `rating` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `VideoCourseFolder` (`id` TEXT NOT NULL, `catId` TEXT NOT NULL, `name` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `folderPath` TEXT NOT NULL, `rating` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `VideoCourseFile` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `courseId` TEXT NOT NULL, `courseName` TEXT NOT NULL, `catId` TEXT NOT NULL, `catName` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `duration` TEXT NOT NULL, `fileLocalPath` TEXT NOT NULL, `fileUrl` TEXT NOT NULL, `rating` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DownloadQueue` (`contentId` TEXT NOT NULL, `folderName` TEXT, `fileUrl` TEXT, `fileName` TEXT, `type` TEXT, `catId` TEXT, `catName` TEXT, `courseId` TEXT, `courseName` TEXT, `courseImage` TEXT, `videoId` TEXT, `videoName` TEXT, `videoImage` TEXT, `videoDuration` TEXT, `fileType` TEXT, `audioId` TEXT, `audioName` TEXT, `audioImage` TEXT, `rating` TEXT, PRIMARY KEY (`contentId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AudioDao get audioDao {
    return _audioDaoInstance ??= _$AudioDao(database, changeListener);
  }

  @override
  VideoDao get videoDao {
    return _videoDaoInstance ??= _$VideoDao(database, changeListener);
  }

  @override
  DownloadQueueDao get downloadQueDao {
    return _downloadQueDaoInstance ??=
        _$DownloadQueueDao(database, changeListener);
  }

  @override
  AudioCourseFolderDao get audioCourseFolderDao {
    return _audioCourseFolderDaoInstance ??=
        _$AudioCourseFolderDao(database, changeListener);
  }

  @override
  VideoCourseFolderDao get videoCourseFolderDao {
    return _videoCourseFolderDaoInstance ??=
        _$VideoCourseFolderDao(database, changeListener);
  }

  @override
  AudioCourseFileDao get audioCourseFileDao {
    return _audioCourseFileDaoInstance ??=
        _$AudioCourseFileDao(database, changeListener);
  }

  @override
  VideoCourseFileDao get videoCourseFileDao {
    return _videoCourseFileDaoInstance ??=
        _$VideoCourseFileDao(database, changeListener);
  }
}

class _$AudioDao extends AudioDao {
  _$AudioDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _audioInsertionAdapter = InsertionAdapter(
            database,
            'Audio',
            (Audio item) => <String, Object?>{
                  'id': item.id,
                  'catId': item.catId,
                  'name': item.name,
                  'catName': item.catName,
                  'imagePath': item.imagePath,
                  'fileLocalPath': item.fileLocalPath,
                  'fileUrl': item.fileUrl,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Audio> _audioInsertionAdapter;

  @override
  Future<List<Audio>> findAllAudio() async {
    return _queryAdapter.queryList('SELECT * FROM Audio',
        mapper: (Map<String, Object?> row) => Audio(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String));
  }

  @override
  Future<Audio?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM Audio WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Audio(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String),
        arguments: [id]);
  }

  @override
  Future<void> clearAllAudio() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Audio');
  }

  @override
  Future<List<Audio>> filterAllAudio(List<String?> catIds) async {
    const offset = 1;
    final sqliteVariablesForCatIds =
        Iterable<String>.generate(catIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM Audio WHERE catId IN ($sqliteVariablesForCatIds)',
        mapper: (Map<String, Object?> row) => Audio(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String),
        arguments: [catIds]);
  }

  @override
  Future<void> insert(Audio audio) async {
    await _audioInsertionAdapter.insert(audio, OnConflictStrategy.replace);
  }
}

class _$VideoDao extends VideoDao {
  _$VideoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _videoInsertionAdapter = InsertionAdapter(
            database,
            'Video',
            (Video item) => <String, Object?>{
                  'id': item.id,
                  'catId': item.catId,
                  'name': item.name,
                  'catName': item.catName,
                  'imagePath': item.imagePath,
                  'fileLocalPath': item.fileLocalPath,
                  'fileUrl': item.fileUrl,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Video> _videoInsertionAdapter;

  @override
  Future<List<Video>> findAllVideo() async {
    return _queryAdapter.queryList('SELECT * FROM Video',
        mapper: (Map<String, Object?> row) => Video(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String));
  }

  @override
  Future<void> clearAllVideo() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Video');
  }

  @override
  Future<Video?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM Video WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Video(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Video>> filterAllVideo(List<String?> catIds) async {
    const offset = 1;
    final sqliteVariablesForCatIds =
        Iterable<String>.generate(catIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM Video WHERE catId IN ($sqliteVariablesForCatIds)',
        mapper: (Map<String, Object?> row) => Video(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String),
        arguments: [catIds]);
  }

  @override
  Future<void> insert(Video video) async {
    await _videoInsertionAdapter.insert(video, OnConflictStrategy.replace);
  }
}

class _$DownloadQueueDao extends DownloadQueueDao {
  _$DownloadQueueDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _downloadQueueInsertionAdapter = InsertionAdapter(
            database,
            'DownloadQueue',
            (DownloadQueue item) => <String, Object?>{
                  'contentId': item.contentId,
                  'folderName': item.folderName,
                  'fileUrl': item.fileUrl,
                  'fileName': item.fileName,
                  'type': item.type,
                  'catId': item.catId,
                  'catName': item.catName,
                  'courseId': item.courseId,
                  'courseName': item.courseName,
                  'courseImage': item.courseImage,
                  'videoId': item.videoId,
                  'videoName': item.videoName,
                  'videoImage': item.videoImage,
                  'videoDuration': item.videoDuration,
                  'fileType': item.fileType,
                  'audioId': item.audioId,
                  'audioName': item.audioName,
                  'audioImage': item.audioImage,
                  'rating': item.rating
                }),
        _downloadQueueDeletionAdapter = DeletionAdapter(
            database,
            'DownloadQueue',
            ['contentId'],
            (DownloadQueue item) => <String, Object?>{
                  'contentId': item.contentId,
                  'folderName': item.folderName,
                  'fileUrl': item.fileUrl,
                  'fileName': item.fileName,
                  'type': item.type,
                  'catId': item.catId,
                  'catName': item.catName,
                  'courseId': item.courseId,
                  'courseName': item.courseName,
                  'courseImage': item.courseImage,
                  'videoId': item.videoId,
                  'videoName': item.videoName,
                  'videoImage': item.videoImage,
                  'videoDuration': item.videoDuration,
                  'fileType': item.fileType,
                  'audioId': item.audioId,
                  'audioName': item.audioName,
                  'audioImage': item.audioImage,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DownloadQueue> _downloadQueueInsertionAdapter;

  final DeletionAdapter<DownloadQueue> _downloadQueueDeletionAdapter;

  @override
  Future<List<DownloadQueue>> findAllDownload() async {
    return _queryAdapter.queryList('SELECT * FROM DownloadQueue',
        mapper: (Map<String, Object?> row) => DownloadQueue(
            contentId: row['contentId'] as String,
            folderName: row['folderName'] as String?,
            fileUrl: row['fileUrl'] as String?,
            fileName: row['fileName'] as String?,
            type: row['type'] as String?,
            catId: row['catId'] as String?,
            catName: row['catName'] as String?,
            courseId: row['courseId'] as String?,
            courseName: row['courseName'] as String?,
            courseImage: row['courseImage'] as String?,
            videoId: row['videoId'] as String?,
            videoName: row['videoName'] as String?,
            videoImage: row['videoImage'] as String?,
            videoDuration: row['videoDuration'] as String?,
            fileType: row['fileType'] as String?,
            audioId: row['audioId'] as String?,
            audioImage: row['audioImage'] as String?,
            audioName: row['audioName'] as String?,
            rating: row['rating'] as String?));
  }

  @override
  Future<DownloadQueue?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM DownloadQueue WHERE videoId = ?1',
        mapper: (Map<String, Object?> row) => DownloadQueue(
            contentId: row['contentId'] as String,
            folderName: row['folderName'] as String?,
            fileUrl: row['fileUrl'] as String?,
            fileName: row['fileName'] as String?,
            type: row['type'] as String?,
            catId: row['catId'] as String?,
            catName: row['catName'] as String?,
            courseId: row['courseId'] as String?,
            courseName: row['courseName'] as String?,
            courseImage: row['courseImage'] as String?,
            videoId: row['videoId'] as String?,
            videoName: row['videoName'] as String?,
            videoImage: row['videoImage'] as String?,
            videoDuration: row['videoDuration'] as String?,
            fileType: row['fileType'] as String?,
            audioId: row['audioId'] as String?,
            audioImage: row['audioImage'] as String?,
            audioName: row['audioName'] as String?,
            rating: row['rating'] as String?),
        arguments: [id]);
  }

  @override
  Future<DownloadQueue?> clearAllDownload() async {
    return _queryAdapter.query('DELETE FROM Audio',
        mapper: (Map<String, Object?> row) => DownloadQueue(
            contentId: row['contentId'] as String,
            folderName: row['folderName'] as String?,
            fileUrl: row['fileUrl'] as String?,
            fileName: row['fileName'] as String?,
            type: row['type'] as String?,
            catId: row['catId'] as String?,
            catName: row['catName'] as String?,
            courseId: row['courseId'] as String?,
            courseName: row['courseName'] as String?,
            courseImage: row['courseImage'] as String?,
            videoId: row['videoId'] as String?,
            videoName: row['videoName'] as String?,
            videoImage: row['videoImage'] as String?,
            videoDuration: row['videoDuration'] as String?,
            fileType: row['fileType'] as String?,
            audioId: row['audioId'] as String?,
            audioImage: row['audioImage'] as String?,
            audioName: row['audioName'] as String?,
            rating: row['rating'] as String?));
  }

  @override
  Future<DownloadQueue?> findAudioById(String id) async {
    return _queryAdapter.query('SELECT * FROM DownloadQueue WHERE audioId = ?1',
        mapper: (Map<String, Object?> row) => DownloadQueue(
            contentId: row['contentId'] as String,
            folderName: row['folderName'] as String?,
            fileUrl: row['fileUrl'] as String?,
            fileName: row['fileName'] as String?,
            type: row['type'] as String?,
            catId: row['catId'] as String?,
            catName: row['catName'] as String?,
            courseId: row['courseId'] as String?,
            courseName: row['courseName'] as String?,
            courseImage: row['courseImage'] as String?,
            videoId: row['videoId'] as String?,
            videoName: row['videoName'] as String?,
            videoImage: row['videoImage'] as String?,
            videoDuration: row['videoDuration'] as String?,
            fileType: row['fileType'] as String?,
            audioId: row['audioId'] as String?,
            audioImage: row['audioImage'] as String?,
            audioName: row['audioName'] as String?,
            rating: row['rating'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<DownloadQueue?>> findCourseFile(String courseId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM DownloadQueue WHERE courseId = ?1',
        mapper: (Map<String, Object?> row) => DownloadQueue(
            contentId: row['contentId'] as String,
            folderName: row['folderName'] as String?,
            fileUrl: row['fileUrl'] as String?,
            fileName: row['fileName'] as String?,
            type: row['type'] as String?,
            catId: row['catId'] as String?,
            catName: row['catName'] as String?,
            courseId: row['courseId'] as String?,
            courseName: row['courseName'] as String?,
            courseImage: row['courseImage'] as String?,
            videoId: row['videoId'] as String?,
            videoName: row['videoName'] as String?,
            videoImage: row['videoImage'] as String?,
            videoDuration: row['videoDuration'] as String?,
            fileType: row['fileType'] as String?,
            audioId: row['audioId'] as String?,
            audioImage: row['audioImage'] as String?,
            audioName: row['audioName'] as String?,
            rating: row['rating'] as String?),
        arguments: [courseId]);
  }

  @override
  Future<void> insert(DownloadQueue download) async {
    await _downloadQueueInsertionAdapter.insert(
        download, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<DownloadQueue> download) async {
    await _downloadQueueInsertionAdapter.insertList(
        download, OnConflictStrategy.replace);
  }

  @override
  Future<void> deletePerson(DownloadQueue person) async {
    await _downloadQueueDeletionAdapter.delete(person);
  }
}

class _$AudioCourseFolderDao extends AudioCourseFolderDao {
  _$AudioCourseFolderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _audioCourseFolderInsertionAdapter = InsertionAdapter(
            database,
            'AudioCourseFolder',
            (AudioCourseFolder item) => <String, Object?>{
                  'id': item.id,
                  'catId': item.catId,
                  'name': item.name,
                  'catName': item.catName,
                  'imagePath': item.imagePath,
                  'folderPath': item.folderPath,
                  'chapterId': item.chapterId,
                  'courseId': item.courseId,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AudioCourseFolder> _audioCourseFolderInsertionAdapter;

  @override
  Future<List<AudioCourseFolder>> findAllAudioFolder() async {
    return _queryAdapter.queryList('SELECT * FROM AudioCourseFolder',
        mapper: (Map<String, Object?> row) => AudioCourseFolder(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['folderPath'] as String,
            row['chapterId'] as String,
            row['courseId'] as String,
            row['rating'] as String));
  }

  @override
  Future<void> clearAllAudioCourseFolder() async {
    await _queryAdapter.queryNoReturn('DELETE FROM AudioCourseFolder');
  }

  @override
  Future<AudioCourseFolder?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM AudioCourseFolder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AudioCourseFolder(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['folderPath'] as String,
            row['chapterId'] as String,
            row['courseId'] as String,
            row['rating'] as String),
        arguments: [id]);
  }

  @override
  Future<List<AudioCourseFolder>> filterAllAudioCourse(
      List<String?> catIds) async {
    const offset = 1;
    final sqliteVariablesForCatIds =
        Iterable<String>.generate(catIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM AudioCourseFolder WHERE catId IN ($sqliteVariablesForCatIds)',
        mapper: (Map<String, Object?> row) => AudioCourseFolder(row['id'] as String, row['catId'] as String, row['name'] as String, row['catName'] as String, row['imagePath'] as String, row['folderPath'] as String, row['chapterId'] as String, row['courseId'] as String, row['rating'] as String),
        arguments: [catIds]);
  }

  @override
  Future<void> insert(AudioCourseFolder audioCourseFolder) async {
    await _audioCourseFolderInsertionAdapter.insert(
        audioCourseFolder, OnConflictStrategy.replace);
  }
}

class _$VideoCourseFolderDao extends VideoCourseFolderDao {
  _$VideoCourseFolderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _videoCourseFolderInsertionAdapter = InsertionAdapter(
            database,
            'VideoCourseFolder',
            (VideoCourseFolder item) => <String, Object?>{
                  'id': item.id,
                  'catId': item.catId,
                  'name': item.name,
                  'catName': item.catName,
                  'imagePath': item.imagePath,
                  'folderPath': item.folderPath,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<VideoCourseFolder> _videoCourseFolderInsertionAdapter;

  @override
  Future<List<VideoCourseFolder>> findAllVideoFolder() async {
    return _queryAdapter.queryList('SELECT * FROM VideoCourseFolder',
        mapper: (Map<String, Object?> row) => VideoCourseFolder(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['folderPath'] as String,
            row['rating'] as String));
  }

  @override
  Future<VideoCourseFolder?> findById(String id) async {
    return _queryAdapter.query('SELECT * FROM VideoCourseFolder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => VideoCourseFolder(
            row['id'] as String,
            row['catId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['imagePath'] as String,
            row['folderPath'] as String,
            row['rating'] as String),
        arguments: [id]);
  }

  @override
  Future<void> clearAllVideoCourseFolder() async {
    await _queryAdapter.queryNoReturn('DELETE FROM VideoCourseFolder');
  }

  @override
  Future<List<VideoCourseFolder>> filterAllVideo(List<String?> catIds) async {
    const offset = 1;
    final sqliteVariablesForCatIds =
        Iterable<String>.generate(catIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM VideoCourseFolder WHERE catId IN ($sqliteVariablesForCatIds)',
        mapper: (Map<String, Object?> row) => VideoCourseFolder(row['id'] as String, row['catId'] as String, row['name'] as String, row['catName'] as String, row['imagePath'] as String, row['folderPath'] as String, row['rating'] as String),
        arguments: [catIds]);
  }

  @override
  Future<void> insert(VideoCourseFolder videoCourseFolder) async {
    await _videoCourseFolderInsertionAdapter.insert(
        videoCourseFolder, OnConflictStrategy.replace);
  }
}

class _$AudioCourseFileDao extends AudioCourseFileDao {
  _$AudioCourseFileDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _audioCourseFileInsertionAdapter = InsertionAdapter(
            database,
            'AudioCourseFile',
            (AudioCourseFile item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'courseId': item.courseId,
                  'courseName': item.courseName,
                  'catId': item.catId,
                  'catName': item.catName,
                  'imagePath': item.imagePath,
                  'fileLocalPath': item.fileLocalPath,
                  'fileUrl': item.fileUrl,
                  'rating': item.rating,
                  'isFile': item.isFile ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AudioCourseFile> _audioCourseFileInsertionAdapter;

  @override
  Future<List<AudioCourseFile>> findAllAudioFolder() async {
    return _queryAdapter.queryList('SELECT * FROM AudioCourseFile',
        mapper: (Map<String, Object?> row) => AudioCourseFile(
            row['id'] as String,
            row['catId'] as String,
            row['courseId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['courseName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String,
            (row['isFile'] as int) != 0));
  }

  @override
  Future<void> clearAllAudioCourseFile() async {
    await _queryAdapter.queryNoReturn('DELETE FROM AudioCourseFile');
  }

  @override
  Future<AudioCourseFile?> findById(
    String id,
    String courseId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM AudioCourseFile WHERE id = ?1 AND courseId = ?2',
        mapper: (Map<String, Object?> row) => AudioCourseFile(
            row['id'] as String,
            row['catId'] as String,
            row['courseId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['courseName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String,
            (row['isFile'] as int) != 0),
        arguments: [id, courseId]);
  }

  @override
  Future<List<AudioCourseFile>?> findCourseContent(String courseId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AudioCourseFile WHERE courseId = ?1',
        mapper: (Map<String, Object?> row) => AudioCourseFile(
            row['id'] as String,
            row['catId'] as String,
            row['courseId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['courseName'] as String,
            row['imagePath'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String,
            (row['isFile'] as int) != 0),
        arguments: [courseId]);
  }

  @override
  Future<void> insert(AudioCourseFile audioCourseFile) async {
    await _audioCourseFileInsertionAdapter.insert(
        audioCourseFile, OnConflictStrategy.replace);
  }
}

class _$VideoCourseFileDao extends VideoCourseFileDao {
  _$VideoCourseFileDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _videoCourseFileInsertionAdapter = InsertionAdapter(
            database,
            'VideoCourseFile',
            (VideoCourseFile item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'courseId': item.courseId,
                  'courseName': item.courseName,
                  'catId': item.catId,
                  'catName': item.catName,
                  'imagePath': item.imagePath,
                  'duration': item.duration,
                  'fileLocalPath': item.fileLocalPath,
                  'fileUrl': item.fileUrl,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<VideoCourseFile> _videoCourseFileInsertionAdapter;

  @override
  Future<void> clearAllVideoCourseFile() async {
    await _queryAdapter.queryNoReturn('DELETE FROM VideoCourseFile');
  }

  @override
  Future<List<VideoCourseFile>> findAllVideoFiles() async {
    return _queryAdapter.queryList('SELECT * FROM VideoCourseFile',
        mapper: (Map<String, Object?> row) => VideoCourseFile(
            row['id'] as String,
            row['catId'] as String,
            row['courseId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['courseName'] as String,
            row['imagePath'] as String,
            row['duration'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String));
  }

  @override
  Future<VideoCourseFile?> findById(
    String id,
    String courseId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM VideoCourseFile WHERE id = ?1 AND courseId = ?2',
        mapper: (Map<String, Object?> row) => VideoCourseFile(
            row['id'] as String,
            row['catId'] as String,
            row['courseId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['courseName'] as String,
            row['imagePath'] as String,
            row['duration'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String),
        arguments: [id, courseId]);
  }

  @override
  Future<List<VideoCourseFile>?> findCourseContent(String courseId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM VideoCourseFile WHERE courseId = ?1',
        mapper: (Map<String, Object?> row) => VideoCourseFile(
            row['id'] as String,
            row['catId'] as String,
            row['courseId'] as String,
            row['name'] as String,
            row['catName'] as String,
            row['courseName'] as String,
            row['imagePath'] as String,
            row['duration'] as String,
            row['fileLocalPath'] as String,
            row['fileUrl'] as String,
            row['rating'] as String),
        arguments: [courseId]);
  }

  @override
  Future<void> insert(VideoCourseFile videoCourseFile) async {
    await _videoCourseFileInsertionAdapter.insert(
        videoCourseFile, OnConflictStrategy.replace);
  }
}
