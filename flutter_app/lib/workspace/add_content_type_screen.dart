import 'package:flutter/material.dart';
import 'package:flutter_slides/models/slides.dart';
import 'package:flutter_slides/workspace/content_editor.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';
import 'package:flutter_slides/workspace/content_value_editors/rect_content_editor.dart';

class AddContentTypeScreen extends StatefulWidget {
  @override
  _AddContentTypeScreenState createState() => _AddContentTypeScreenState();
}

class _AddContentTypeScreenState extends State<AddContentTypeScreen> {
  ValueNotifier<String> selectedType = ValueNotifier(null);
  ContentValueEditorController _contentValueEditorController =
      ContentValueEditorController();
  @override
  Widget build(BuildContext context) {
    final positioning = {
      'width': loadedSlides.presentationMetadata.slideWidth,
      'height': loadedSlides.presentationMetadata.slideHeight,
      'x': 0.0,
      'y': 0.0,
    };
    return AnimatedBuilder(
      animation: selectedType,
      builder: (context, widget) {
        Widget child;
        if (selectedType.value == null) {
          child = ListView(
            shrinkWrap: false,
            children: <Widget>[
              ListTile(
                title: Text('Rect'),
                onTap: () {
                  Navigator.of(context).pop(
                    Map<String, dynamic>.from(
                        {"type": "rect", "fill": "#BFE6F3ff"})
                      ..addAll(positioning),
                  );
                },
              ),
              ListTile(
                title: Text('Label'),
                onTap: () {
                  Navigator.of(context).pop(Map<String, dynamic>.from({
                    "type": "label",
                    "text": "Label Content",
                    "font_size": 120.0,
                    "font_color": "#0175C2ff",
                    "line_height": 1.0,
                    "letter_spacing": 1.0,
                    "text_align": "center",
                  })
                    ..addAll(positioning));
                },
              ),
              ListTile(
                title: Text('Image'),
                onTap: () {
                  Navigator.of(context).pop(Map<String, dynamic>.from({
                    "type": "image",
                    "fit": "contain",
                    "asset": "assets/images/flutter_logo.webp"
                  })
                    ..addAll(positioning));
                },
              ),
              ListTile(
                title: Text('Flare'),
                onTap: () {
                  Navigator.of(context).pop(
                    Map<String, dynamic>.from({
                      "type": "flare_actor",
                      "asset": "assets/flare/Flare Logo.flr",
                      "animation_name": "Untitled",
                    })
                      ..addAll(positioning),
                  );
                },
              ),
              ListTile(
                title: Text('Nima'),
                onTap: () {
                  {
                    Navigator.of(context).pop(
                      Map<String, dynamic>.from({
                        "asset": "assets/flare/Robot.nma",
                        "animation_name": "Flight",
                        "type": "nima_actor",
                      })
                        ..addAll(positioning),
                    );
                  }
                },
              ),
            ],
          );
        } else {
          child = Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    RectContentEditor(
                      controller: _contentValueEditorController,
                    )
//                    ContentEditor(),
                  ],
                ),
              ),
              Container(
                color: Colors.red,
                height: 40.0,
              ),
            ],
          );
        }
        return Container(
          width: 400.0,
          child: child,
        );
      },
    );
  }
}
