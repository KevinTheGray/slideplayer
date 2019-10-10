import 'dart:convert';

import 'package:flutter_slides/models/presentation_loaders/file_system_presentation_loader.dart';
import 'package:flutter_slides/models/presentation_loaders/presentation_loader.dart';
import 'package:flutter_slides/models/slide.dart';
import 'package:flutter_slides/models/slide_factors.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slides/utils/color_utils.dart' as ColorUtils;
import 'package:file_chooser/file_chooser.dart' as file_chooser;

FlutterSlidesModel loadedSlides = FlutterSlidesModel();

const _RECENTLY_OPENED_FILE_PREFS_TYPE_ID_KEY = 'last_opened_type_id';
const _RECENTLY_OPENED_FILE_PREFS_PRESENTATION_ID_KEY =
    'last_opened_presentation_id';

void loadSlideDataFromFileChooser() {
  file_chooser.showOpenPanel((result, paths) {
    if (paths != null) {
      _loadPresentation(FileSystemPresentationLoader(paths.first));
    }
  }, allowsMultipleSelection: false);
}

void loadRecentlyOpenedSlideData() {
  SharedPreferences.getInstance().then(
    (prefs) {
      String filePath =
          prefs.getString(_RECENTLY_OPENED_FILE_PREFS_PRESENTATION_ID_KEY);
      if (filePath != null) {
        _loadPresentation(FileSystemPresentationLoader(filePath));
      }
    },
  );
}

void _loadPresentation(PresentationLoader presentationLoader) {
  loadedSlides.loadPresentation(presentationLoader);
}

class FlutterSlidesModel extends Model {
  List<Slide> slides;
  String externalFilesRoot;
  double slideWidth = 1920.0;
  double slideHeight = 1080.0;
  double fontScaleFactor = 1920.0;
  Color projectBGColor = Color(0xFFF0F0F0);
  Color slidesListBGColor = Color(0xFFDDDDDD);
  Color slidesListHighlightColor = Color(0xFF40C4FF);
  bool animateSlideTransitions = false;
  bool showDebugContainers = false;
  bool autoAdvance = false;
  int autoAdvanceDurationMillis = 30000;

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

      Map metadata = json['presentation_metadata'];
      loadedSlides.slideWidth = (metadata['slide_width'] ?? 1920.0).toDouble();
      loadedSlides.slideHeight =
          (metadata['slide_height'] ?? 1080.0).toDouble();
      loadedSlides.fontScaleFactor =
          (metadata['font_scale_factor'] ?? loadedSlides.slideWidth).toDouble();
      loadedSlides.projectBGColor =
          ColorUtils.colorFromString(metadata['project_bg_color']) ??
              loadedSlides.projectBGColor;
      loadedSlides.slidesListBGColor =
          ColorUtils.colorFromString(metadata['project_slide_list_bg_color']) ??
              loadedSlides.slidesListBGColor;
      loadedSlides.slidesListHighlightColor = ColorUtils.colorFromString(
              metadata['project_slide_list_highlight_color']) ??
          loadedSlides.slidesListHighlightColor;
      loadedSlides.animateSlideTransitions =
          metadata['animate_slide_transitions'] ?? false;
      loadedSlides.showDebugContainers =
          metadata['show_debug_containers'] ?? false;
      loadedSlides.externalFilesRoot = metadata['external_files_root'] ??
          _presentationLoader.externalFilesRoot;
      loadedSlides.autoAdvance = metadata['auto_advance'] ?? false;
      loadedSlides.autoAdvanceDurationMillis =
          metadata['auto_advance_duration_millis'] ?? 30000;

      SlideFactors slideFactors = SlideFactors(
        normalizationWidth: loadedSlides.slideWidth,
        normalizationHeight: loadedSlides.slideHeight,
        fontScaleFactor: loadedSlides.fontScaleFactor,
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
}
