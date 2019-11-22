import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slides/models/slides.dart';
import 'package:flutter_slides/utils/image_utils.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';
import 'package:flutter_slides/workspace/select_fixed_values_screen.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;

class ImageContentEditor extends StatefulWidget {
  final Map content;
  final void Function() onUpdated;
  final ContentValueEditorController controller;

  const ImageContentEditor({
    Key key,
    this.content,
    this.onUpdated,
    this.controller,
  }) : super(key: key);

  @override
  _ImageContentEditorState createState() => _ImageContentEditorState();
}

class _ImageContentEditorState extends State<ImageContentEditor>
    implements ContentValueEditorControllerListener {
  TextEditingController fileController = TextEditingController();
  TextEditingController assetController = TextEditingController();
  TextEditingController fitController = TextEditingController();
  bool evict;

  @override
  Widget build(BuildContext context) {
    widget.controller.listener = this;
    fileController.text = widget.content['file'] ?? '';
    assetController.text = widget.content['asset'] ?? '';
    fitController.text = widget.content['fit'] ?? 'contain';
    evict = widget.content['evict'] ?? false;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('File: '),
            Expanded(
              child: Text(fileController.text),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () async {
                  final String externalFilesRoot =
                      loadedSlides.presentationMetadata.externalFilesRoot;
                  file_chooser.showOpenPanel((result, files) {
                    if (files?.isNotEmpty ?? false) {
                      String filePath = files.first;
                      if (filePath.startsWith(externalFilesRoot)) {
                        final newPath = filePath.split(externalFilesRoot)[1];
                        fileController.value = TextEditingValue(text: newPath);
                        assetController.value = TextEditingValue(text: '');
                        widget.onUpdated();
                      }
                    }
                  }, initialDirectory: externalFilesRoot);
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
                        fileController.value = TextEditingValue(text: '');
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
            Text('Fit: '),
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  child: Text(fitController.text),
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: SelectFixedValuesScreen(
                            data: boxFitMap,
                          ),
                        );
                      },
                    );
                    if (result != null) {
                      fitController.value = TextEditingValue(text: result);
                      widget.onUpdated();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Evict: '),
            Checkbox(
              value: evict,
              onChanged: (value) {
                evict = value;
                widget.onUpdated();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Map getContentValues() {
    return {
      'file': fileController.text.length > 0 ? fileController.text : null,
      'asset': assetController.text.length > 0 ? assetController.text : null,
      'fit': fitController.text,
      'evict': evict,
    };
  }
}
