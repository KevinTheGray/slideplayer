import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;

class TwoDimensionsContentEditor extends StatefulWidget {
  final Map content;
  final void Function() onUpdated;
  final ContentValueEditorController controller;

  const TwoDimensionsContentEditor({
    Key key,
    this.content,
    this.onUpdated,
    this.controller,
  }) : super(key: key);

  @override
  _TwoDimensionsContentEditorState createState() => _TwoDimensionsContentEditorState();
}

class _TwoDimensionsContentEditorState extends State<TwoDimensionsContentEditor>
    implements ContentValueEditorControllerListener {
  TextEditingController assetController = TextEditingController();
  TextEditingController animationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    widget.controller.listener = this;
    assetController.text = widget.content['asset'].toString();
    animationController.text = widget.content['animation_name'].toString();
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Bundled Asset: '),
            Expanded(
              child: Text(assetController.text),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () async {
                  String assetsRootPath = Directory.current.path + '/assets';
                  file_chooser.showOpenPanel((result, files) {
                    if (files?.isNotEmpty ?? false) {
                      String filePath = files.first;
                      if (filePath.startsWith(assetsRootPath)) {
                        final newPath = filePath.split(assetsRootPath)[1];
                        assetController.value =
                            TextEditingValue(text: 'assets' + newPath);
                        widget.onUpdated();
                      }
                    }
                  }, initialDirectory: assetsRootPath);
                },
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  child: Icon(
                    Icons.attachment,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Animation:'),
            Expanded(
              child: TextField(
                controller: animationController,
                onSubmitted: (val) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Map getContentValues() {
    return {
      'asset': assetController.text,
      'animation_name': animationController.text,
    };
  }
}
