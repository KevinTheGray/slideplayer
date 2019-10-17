import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_slides/models/presentation_loaders/presentation_loader.dart';

class FirebaseDatabasePresentationLoader extends PresentationLoader {
  final String databaseID;
  String _presentationJSONString;
  StreamSubscription _databaseSubscription;
  FirebaseDatabasePresentationLoader(this.databaseID);

  @override
  void dispose() {
    super.dispose();
    _databaseSubscription?.cancel();
  }

  @override
  String get presentationJSONString => _presentationJSONString;

  @override
  String get externalFilesRoot =>
      File(this.databaseID).parent.path + '/external_files';

  @override
  String get presentationID => databaseID;

  @override
  String get typeID => 'firebase_database';

  @override
  void load() {
    FirebaseDatabase.instance
        .reference()
        .child('presentations/$databaseID')
        .onValue
        .listen(
      (event) {
        try {
          Map map = event.snapshot.value;
          _presentationJSONString = jsonEncode(map);
        } catch (e) {
          print("Error loading presentation from Firebase: ${e.toString()}");
        } finally {
          notifyListeners();
        }
      },
    );
  }

  @override
  void save(Map presentation) {
    // TODO: implement save
  }
}
