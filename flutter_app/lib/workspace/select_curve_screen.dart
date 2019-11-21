import 'package:flutter/material.dart';
import 'package:flutter_slides/utils/curve_utils.dart';

class SelectCurveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List<Widget>.generate(curveMap.length, (index) {
        final curveType = curveMap.keys.toList()[index];
        return ListTile(
          title: Text(curveType),
          onTap: () {
            Navigator.of(context).pop(curveType);
          },
        );
      }),
    );
  }
}
