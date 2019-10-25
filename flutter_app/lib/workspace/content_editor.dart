import 'package:flutter/material.dart';
import 'package:flutter_slides/models/slides.dart';

class ContentEditor extends StatefulWidget {
  final Map content;
  final void Function(Map) onUpdated;

  const ContentEditor({Key key, this.content, this.onUpdated})
      : super(key: key);

  @override
  _ContentEditorState createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  TextEditingController titleController = TextEditingController();
  TextEditingController advStepController = TextEditingController();
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

  Map currentContentState;
  @override
  Widget build(BuildContext context) {
    xPosController.text = widget.content['x'].toString();
    yPosController.text = widget.content['y'].toString();
    advStepController.text =
        (widget.content['advancement_step'] ?? 0).toString();
    widthController.text = widget.content['width'].toString();
    heightController.text = widget.content['height'].toString();
    titleController.text = widget.content['editor_title']?.toString();

    if (widget.content.containsKey('animation')) {
      aniCurveController.text = widget.content['animation']['curve'];
      aniDurationController.text =
          (widget.content['animation']['duration_in_milliseconds'] ?? 0)
              .toString();
      aniDelayController.text =
          (widget.content['animation']['delay_in_milliseconds'] ?? 0)
              .toString();
      aniOffsetXController.text =
          (widget.content['animation']['offset_x'] ?? 0).toString();
      aniOffsetYController.text =
          (widget.content['animation']['offset_y'] ?? 0).toString();
      aniScaleStartController.text =
          (widget.content['animation']['scale_start'] ?? 1.0).toString();
      aniScaleEndController.text =
          (widget.content['animation']['scale_end'] ?? 1.0).toString();
      aniScaleAlignController.text =
          (widget.content['animation']['scale_align'] ?? 'center');
      opacityStartController.text =
          (widget.content['animation']['opacity_start'] ?? 1.0).toString();
      opacityEndController.text =
          (widget.content['animation']['opacity_end'] ?? 1.0).toString();
      rotationController.text =
          (widget.content['animation']['rotation'] ?? 0.0).toString();
    }
    currentContentState = widget.content;
    return ExpansionTile(
      title: Text(
          '${widget.content['editor_title'] ?? '${widget.content['type']}'}'),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ExpansionTile(
              title: Text('Metadata'),
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('type: ${widget.content['type']}'),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('title:'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Advancement Step:'),
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
              ],
            ),
            ExpansionTile(
              title: Text('Position/Size'),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('X:'),
                    Expanded(
                      child: TextField(
                        controller: xPosController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                    Text('Y:'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('W:'),
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                    Text('H:'),
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
            ExpansionTile(
              title: Text('Content Values'),
              children: <Widget>[],
            ),
            ExpansionTile(
              title: Text('Animation'),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Curve:'),
                    Expanded(
                      child: TextField(
                        controller: aniCurveController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Duration:'),
                    Expanded(
                      child: TextField(
                        controller: aniDurationController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                    Text('Delay:'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Offset X:'),
                    Expanded(
                      child: TextField(
                        controller: aniOffsetXController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                    Text('Offset Y:'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Scale Start:'),
                    Expanded(
                      child: TextField(
                        controller: aniScaleStartController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                    Text('Scale End:'),
                    Expanded(
                      child: TextField(
                        controller: aniScaleEndController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                    Text('Align:'),
                    Expanded(
                      child: TextField(
                        controller: aniScaleAlignController,
                        onSubmitted: (val) {
                          update();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
            Padding(padding: EdgeInsets.only(top: 20.0)),
          ],
        ),
      ],
    );
  }

  void update() {
    print('boop');
    final updatedMap = {}..addAll(currentContentState);
    final Map animationMap = {}..addAll(currentContentState['animation'] ?? {});
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
        }),
    );
  }
}
