import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter_slides/models/presentation_loaders/presentation_loader.dart';
import 'package:flutter_slides/plugins/notes_plugin.dart';
import 'package:watcher/watcher.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;

class FileSystemPresentationLoader extends PresentationLoader {
  String filePath;
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
    _fileWatcherSubscription?.cancel();
    _fileWatcherSubscription = Watcher(filePath).events.listen((event) {
      _loadData();
    });
  }

  void _loadData() async {
    _presentationJSONString = await File(filePath).readAsString();
    updateWindowName(
        '${basename(filePath)} - ${File(filePath).lastModifiedSync()}');
    notifyListeners();
  }

  @override
  void save(Map presentation) async {
    File(filePath)
        .writeAsString(JsonEncoder.withIndent('  ').convert(presentation));
  }

  @override
  void saveAs(Map presentation) {
    file_chooser.showSavePanel(
      (result, paths) {
        if (paths != null && paths.length > 0) {
          final path = paths[0];
          File(path).writeAsString(
              JsonEncoder.withIndent('  ').convert(presentation));
          filePath = path;
          _initFileWatcher();
          notifyListeners();
        }
      },
      suggestedFileName: 'untitled.json',
    );
  }
}
