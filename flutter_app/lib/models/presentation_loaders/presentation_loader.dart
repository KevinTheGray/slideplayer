import 'package:flutter/foundation.dart';

abstract class PresentationLoader extends ChangeNotifier {
  String get presentationJSONString;
  // Temporary until I figure out how we can make this agnostic
  String get externalFilesRoot;
  String get typeID;
  String get presentationID;
  void load();
  void save(Map presentation);
  void dispose();
}