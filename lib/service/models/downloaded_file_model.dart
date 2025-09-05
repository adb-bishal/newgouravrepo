
class Folder{
  static String audio = 'audio';
  static String audioCourse = 'audioCourse';
  static String video= 'video';
  static String videoCourse = 'videoCourse';
}


class DownloadedFileModel{
  String? name;
  String? imagePath;
  String? path;
  bool? isFolder;
  Folder? folder;
  List<DownloadedFileModel>? folderFiles;

  DownloadedFileModel({this.name, this.imagePath, this.path, this.isFolder,
      this.folder, this.folderFiles});
}