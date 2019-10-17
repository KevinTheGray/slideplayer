import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_slides/models/presentation_loaders/presentation_loader.dart';
import 'package:watcher/watcher.dart';

class FileSystemPresentationLoader extends PresentationLoader {
  final String filePath;
  String _presentationJSONString;
  StreamSubscription _fileWatcherSubscription;
  FileSystemPresentationLoader(this.filePath);

  @override
  void dispose() {
    super.dispose();
    _fileWatcherSubscription?.cancel();
  }

  @override
  String get presentationJSONString => _presentationJSONString;

  @override
  String get externalFilesRoot =>
      File(filePath).parent.path + '/external_files';

  @override
  String get presentationID => filePath;

  @override
  String get typeID => 'file_system';

  @override
  void load() {
    _initFileWatcher();
    _loadData();
  }

  void _initFileWatcher() {
    _fileWatcherSubscription = Watcher(filePath).events.listen((event) {
      _loadData();
    });
  }

  void _loadData() async {
    _presentationJSONString = await File(filePath).readAsString();
    notifyListeners();
  }

  @override
  void save(Map presentation) async {
    File(filePath)
        .writeAsString(JsonEncoder.withIndent('  ').convert(presentation));
  }
}
