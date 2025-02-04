import 'package:flutter/material.dart';
import 'package:flutter_slides/models/slides.dart';
import 'package:flutter_slides/utils/align_utils.dart';
import 'package:flutter_slides/utils/curve_utils.dart';
import 'package:flutter_slides/workspace/content_value_editors/content_value_editor_controller.dart';
import 'package:flutter_slides/workspace/content_value_editors/image_content_editor.dart';
import 'package:flutter_slides/workspace/content_value_editors/label_content_editor.dart';
import 'package:flutter_slides/workspace/content_value_editors/two_dimensions_content_editor.dart';
import 'package:flutter_slides/workspace/select_curve_screen.dart';
import 'package:flutter_slides/workspace/select_fixed_values_screen.dart';

import 'content_value_editors/rect_content_editor.dart';

class ContentEditor extends StatefulWidget {
  final Map content;
  final int index;
  final void Function(Map) onUpdated;
  final void Function(int toPosition) onMovePosition;

  const ContentEditor({
    Key key,
    this.content,
    this.onUpdated,
    this.onMovePosition,
    this.index,
  }) : super(key: key);

  @override
  _ContentEditorState createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  TextEditingController titleController = TextEditingController();
  TextEditingController advStepController = TextEditingController();
  TextEditingController listPosController = TextEditingController();
  TextEditingController xPosController = TextEditingController();
  TextEditingController yPosController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  TextEditingController aniCurveController = TextEditingController();
  TextEditingController aniDurationController = TextEditingController();
  TextEditingController aniDelayController = TextEditingController();
  TextEditingController aniOffsetXController = TextEditingController();
  TextEditingController aniOffsetYController = TextEditingController();
  TextEditingController aniScaleStartController = TextEditingController();
  TextEditingController aniScaleEndController = TextEditingController();
  TextEditingController aniScaleAlignController = TextEditingController();
  TextEditingController opacityStartController = TextEditingController();
  TextEditingController opacityEndController = TextEditingController();
  TextEditingController rotationController = TextEditingController();

  ContentValueEditorController contentValueEditorController =
      ContentValueEditorController();

  Map currentContentState;
  @override
  Widget build(BuildContext context) {
    xPosController.text = widget.content['x'].toString();
    yPosController.text = widget.content['y'].toString();
    advStepController.text =
        (widget.content['advancement_step'] ?? 0).toString();
    listPosController.text = widget.index.toString();
    widthController.text = widget.content['width'].toString();
    heightController.text = widget.content['height'].toString();
    titleController.text = (widget.content['editor_title'] ?? '').toString();

    final animation = widget.content['animation'] ?? {};
    aniCurveController.text = animation['curve'];
    aniDurationController.text =
        (animation['duration_in_milliseconds'] ?? 0).toString();
    aniDelayController.text =
        (animation['delay_in_milliseconds'] ?? 0).toString();
    aniOffsetXController.text = (animation['offset_x'] ?? 0).toString();
    aniOffsetYController.text = (animation['offset_y'] ?? 0).toString();
    aniScaleStartController.text = (animation['scale_start'] ?? 1.0).toString();
    aniScaleEndController.text = (animation['scale_end'] ?? 1.0).toString();
    aniScaleAlignController.text = (animation['scale_align'] ?? 'center');
    opacityStartController.text =
        (animation['opacity_start'] ?? 1.0).toString();
    opacityEndController.text = (animation['opacity_end'] ?? 1.0).toString();
    rotationController.text = (animation['rotation'] ?? 0.0).toString();
    contentValueEditorController.listener = null;
    currentContentState = widget.content;

    String type = widget.content['type'];
    return ExpansionTile(
      title: Text(
          '${widget.content['editor_title'] ?? '${widget.content['type']}'}'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ExpansionTile(
                title: Text('Metadata'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('type: ${widget.content['type']}'),
                        ),
                        Row(
                          children: <Widget>[
                            Text('Title: '),
                            Expanded(
                              child: TextField(
                                controller: titleController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Advancement Step: '),
                            Expanded(
                              child: TextField(
                                controller: advStepController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('List Position: '),
                            Expanded(
                              child: TextField(
                                controller: listPosController,
                                onSubmitted: (val) {
                                  int index = int.tryParse(val);
                                  if (index != null && index != widget.index) {
                                    widget.onMovePosition(index);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Position/Size'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('X: '),
                            Expanded(
                              child: TextField(
                                controller: xPosController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                            Text('Y: '),
                            Expanded(
                              child: TextField(
                                controller: yPosController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('W: '),
                            Expanded(
                              child: TextField(
                                controller: widthController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                            Text('H: '),
                            Expanded(
                              child: TextField(
                                controller: heightController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text('Content Values'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      children: <Widget>[
                        if (type == 'rect')
                          RectContentEditor(
                            content: widget.content,
                            controller: contentValueEditorController,
                            onUpdated: () {
                              update();
                            },
                          ),
                        if (type == 'label')
                          LabelContentEditor(
                            content: widget.content,
                            controller: contentValueEditorController,
                            onUpdated: () {
                              update();
                            },
                          ),
                        if (type == 'image')
                          ImageContentEditor(
                            content: widget.content,
                            controller: contentValueEditorController,
                            onUpdated: () {
                              update();
                            },
                          ),
                        if (type == 'flare_actor' || type == 'nima_actor')
                          TwoDimensionsContentEditor(
                            content: widget.content,
                            controller: contentValueEditorController,
                            onUpdated: () {
                              update();
                            },
                          ),
                      ],
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text('Animation'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('Curve: '),
                            Expanded(
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  child: Text(aniCurveController.text),
                                  onTap: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: SelectFixedValuesScreen(
                                            data: curveMap,
                                          ),
                                        );
                                      },
                                    );
                                    if (result != null) {
                                      aniCurveController.value =
                                          TextEditingValue(text: result);
                                      update();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Duration: '),
                            Expanded(
                              child: TextField(
                                controller: aniDurationController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                            Text('Delay: '),
                            Expanded(
                              child: TextField(
                                controller: aniDelayController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Offset X: '),
                            Expanded(
                              child: TextField(
                                controller: aniOffsetXController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                            Text('Offset Y: '),
                            Expanded(
                              child: TextField(
                                controller: aniOffsetYController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Scale Start: '),
                            Expanded(
                              child: TextField(
                                controller: aniScaleStartController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                            Text('Scale End: '),
                            Expanded(
                              child: TextField(
                                controller: aniScaleEndController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Scale Align: '),
                            Expanded(
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  child: Text(aniScaleAlignController.text),
                                  onTap: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: SelectFixedValuesScreen(
                                            data: alignMap,
                                          ),
                                        );
                                      },
                                    );
                                    if (result != null) {
                                      aniScaleAlignController.value =
                                          TextEditingValue(text: result);
                                      update();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Opacity Start:'),
                            Expanded(
                              child: TextField(
                                controller: opacityStartController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                            Text('Opacity End:'),
                            Expanded(
                              child: TextField(
                                controller: opacityEndController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Roatation:'),
                            Expanded(
                              child: TextField(
                                controller: rotationController,
                                onSubmitted: (val) {
                                  update();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(color: Colors.grey),
                    ),
                    Expanded(
                      child: Container(color: Colors.blueAccent),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          widget.onUpdated(null);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
            ],
          ),
        ),
      ],
    );
  }

  void update() {
    final updatedMap = {}..addAll(currentContentState);
    final Map animationMap = {}..addAll(currentContentState['animation'] ?? {});
    final Map contentValueMap = {}..addAll(
        contentValueEditorController.getContentValues(),
      );
    animationMap.addAll({
      'curve': aniCurveController.value?.text ?? '',
      'duration_in_milliseconds':
          int.tryParse(aniDurationController.value?.text ?? 0),
      'delay_in_milliseconds':
          int.tryParse(aniDelayController.value?.text ?? 0),
      'offset_x': num.tryParse(aniOffsetXController.value?.text ?? 0),
      'offset_y': num.tryParse(aniOffsetYController.value?.text ?? 0),
      'scale_start': double.tryParse(aniScaleStartController.value?.text ?? 0),
      'scale_end': double.tryParse(aniScaleEndController.value?.text ?? 0),
      'scale_align': aniScaleAlignController.value?.text ?? '',
      'opacity_start': double.tryParse(opacityStartController.value?.text ?? 0),
      'opacity_end': double.tryParse(opacityEndController.value?.text ?? 0),
      'rotation': double.tryParse(rotationController.value?.text ?? 0),
    });
    widget.onUpdated(
      updatedMap
        ..addAll({
          "editor_title": titleController.value.text.isEmpty
              ? null
              : titleController.value.text,
          "x": num.tryParse(xPosController.value.text) ?? 0.0,
          "y": num.tryParse(yPosController.value.text) ?? 0.0,
          "width": num.tryParse(widthController.value.text) ?? 0.0,
          "height": num.tryParse(heightController.value.text) ?? 0.0,
          "advancement_step": num.tryParse(advStepController.value.text) ?? 0,
          "animation": animationMap,
        })
        ..addAll(contentValueMap),
    );
  }
}
