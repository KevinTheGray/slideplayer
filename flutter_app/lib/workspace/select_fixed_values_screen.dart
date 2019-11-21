import 'package:flutter/material.dart';

class SelectFixedValuesScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const SelectFixedValuesScreen({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List<Widget>.generate(data.length, (index) {
        final value = data.keys.toList()[index];
        return ListTile(
          title: Text(value),
          onTap: () {
            Navigator.of(context).pop(value);
          },
        );
      }),
    );
  }
}
