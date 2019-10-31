import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';

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
              child: TextField(
                controller: fileController,
                onSubmitted: (value) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Asset: '),
            Expanded(
              child: TextField(
                controller: assetController,
                onSubmitted: (value) {
                  widget.onUpdated();
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Fit: '),
            Expanded(
              child: TextField(
                controller: fitController,
                onSubmitted: (value) {
                  widget.onUpdated();
                },
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
      'file':
          fileController.text.length > 0 ? fileController.text : null,
      'asset':
          assetController.text.length > 0 ? assetController.text : null,
      'fit': fitController.text,
      'evict': evict,
    };
  }
}
