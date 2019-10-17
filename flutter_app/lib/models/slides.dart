import 'dart:convert';

import 'package:flutter_slides/models/presentation_loaders/file_system_presentation_loader.dart';
import 'package:flutter_slides/models/presentation_loaders/firebase_database_presentation_loader.dart';
import 'package:flutter_slides/models/presentation_loaders/presentation_loader.dart';
import 'package:flutter_slides/models/slide.dart';
import 'package:flutter_slides/models/slide_factors.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slides/utils/color_utils.dart' as ColorUtils;

FlutterSlidesModel loadedSlides = FlutterSlidesModel();

const _RECENTLY_OPENED_FILE_PREFS_TYPE_ID_KEY = 'last_opened_type_id';
const _RECENTLY_OPENED_FILE_PREFS_PRESENTATION_ID_KEY =
    'last_opened_presentation_id';

void loadRecentlyOpenedSlideData() {
  // todo (kg) - clean everything about this up.
  SharedPreferences.getInstance().then(
        (prefs) {
      String type = prefs.getString(_RECENTLY_OPENED_FILE_PREFS_TYPE_ID_KEY);
      String presentationID =
      prefs.getString(_RECENTLY_OPENED_FILE_PREFS_PRESENTATION_ID_KEY);
      if (presentationID == null) {
        return;
      }
      if (type == FileSystemPresentationLoader(null).typeID) {
        loadPresentation(FileSystemPresentationLoader(presentationID));
      } else if (type == FirebaseDatabasePresentationLoader(null).typeID) {
        loadPresentation(FirebaseDatabasePresentationLoader(presentationID));
      }
    },
  );
}

void loadPresentation(PresentationLoader presentationLoader) {
  loadedSlides.loadPresentation(presentationLoader);
}

class DebugOptions {
  final bool showDebugContainers;
  final bool autoAdvance;
  final int autoAdvanceDurationMillis;

  DebugOptions({
    this.showDebugContainers = false,
    this.autoAdvance = false,
    this.autoAdvanceDurationMillis = 30000,
  });

  DebugOptions copyWith({
    bool showDebugContainers,
    bool autoAdvance,
    int autoAdvanceDurationMillis,
  }) {
    return DebugOptions(
      showDebugContainers: showDebugContainers ?? this.showDebugContainers,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      autoAdvanceDurationMillis:
      autoAdvanceDurationMillis ?? this.autoAdvanceDurationMillis,
    );
  }
}

class PresentationMetadata {
  String externalFilesRoot;
  double slideWidth = 1920.0;
  double slideHeight = 1080.0;
  double fontScaleFactor = 1920.0;
  Color projectBGColor = Color(0xFFF0F0F0);
  Color slidesListBGColor = Color(0xFFDDDDDD);
  Color slidesListHighlightColor = Color(0xFF40C4FF);
  bool animateSlideTransitions = false;
}

class FlutterSlidesModel extends Model {
  Map _currentSlides;
  List<Map> _undo;
  List<Slide> slides;
  DebugOptions _debugOptions = DebugOptions();
  PresentationMetadata presentationMetadata = PresentationMetadata();

  PresentationLoader _presentationLoader;

  void loadPresentation(PresentationLoader presentationLoader) {
    _presentationLoader?.dispose();
    _presentationLoader = presentationLoader;
    _presentationLoader.addListener(() {
      if (_presentationLoader.presentationJSONString != null) {
        _loadPresentationData(_presentationLoader.presentationJSONString);
      }
    });
    _presentationLoader.load();
  }

  void _loadPresentationData(String presentationJSONString) {
    try {
      String fileString = presentationJSONString;
      Map json = jsonDecode(fileString);

      Map replaceValues = json['replace_values'];
      if (replaceValues != null) {
        json = jsonDecode(_replaceValues(fileString, replaceValues));
      }
      _currentSlides = json;
      _update();
    } catch (e) {
      print("Error loading slides file: $e");
    }
  }

  void _update() {
    try {
      final json = _currentSlides;
      Map metadata = json['presentation_metadata'];
      presentationMetadata.slideWidth =
          (metadata['slide_width'] ?? presentationMetadata.slideWidth)
              .toDouble();
      presentationMetadata.slideHeight =
          (metadata['slide_height'] ?? presentationMetadata.slideHeight)
              .toDouble();
      presentationMetadata.fontScaleFactor =
          (metadata['font_scale_factor'] ?? presentationMetadata.slideWidth)
              .toDouble();
      presentationMetadata.projectBGColor =
          ColorUtils.colorFromString(metadata['project_bg_color']) ??
              presentationMetadata.projectBGColor;
      presentationMetadata.slidesListBGColor =
          ColorUtils.colorFromString(metadata['project_slide_list_bg_color']) ??
              presentationMetadata.slidesListBGColor;
      presentationMetadata.slidesListHighlightColor =
          ColorUtils.colorFromString(
              metadata['project_slide_list_highlight_color']) ??
              presentationMetadata.slidesListHighlightColor;
      presentationMetadata.animateSlideTransitions =
          metadata['animate_slide_transitions'] ?? false;
      presentationMetadata.externalFilesRoot =
          metadata['external_files_root'] ??
              _presentationLoader.externalFilesRoot;

      SlideFactors slideFactors = SlideFactors(
        normalizationWidth: presentationMetadata.slideWidth,
        normalizationHeight: presentationMetadata.slideHeight,
        fontScaleFactor: presentationMetadata.fontScaleFactor,
      );
      List slides = json['slides'];
      List<Slide> slideList = [];
      for (Map slide in slides) {
        List contentList = slide['content'];
        int advancementCount = slide['advancement_count'] ?? 0;
        bool animatedTransition = slide['animated_transition'] ?? false;
        Color slideBGColor =
        ColorUtils.colorFromString(slide['bg_color'] ?? '0xFFFFFFFF');
        slideList.add(
          Slide(
              content: contentList,
              slideFactors: slideFactors,
              advancementCount: advancementCount,
              backgroundColor: slideBGColor,
              animatedTransition: animatedTransition),
        );
      }
      loadedSlides.slides = slideList;
      loadedSlides.notifyListeners();
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_RECENTLY_OPENED_FILE_PREFS_TYPE_ID_KEY,
            _presentationLoader.typeID);
        prefs.setString(_RECENTLY_OPENED_FILE_PREFS_PRESENTATION_ID_KEY,
            _presentationLoader.presentationID);
      });
//      _presentationLoader.save(_currentSlides);
    } catch (e) {
      print("Error loading slides file: $e");
    }
  }

  String _replaceValues(String jsonString, Map replaceValues) {
    for (final entry in replaceValues.entries) {
      jsonString = jsonString.replaceAll(
          "\"@replace/${entry.key}\"", entry.value.toString());
    }
    return jsonString;
  }

  void addSlide(Map json, {int index}) {}

  void removeSlide(int index) {
    (_currentSlides['slides'] as List).removeAt(index);
    _update();
  }

  void modifySlide(int index, Map json) {}

  void reorderSlides(int indexA, int indexB) {}

  void modifyMetadata(Map json) {}

  void updateReplaceValues(Map json) {}

  DebugOptions get debugOptions => _debugOptions;

  set debugOptions(DebugOptions debugOptions) {
    _debugOptions = debugOptions;
    notifyListeners();
  }


  void undo() {
    print('undo');
  }
}
