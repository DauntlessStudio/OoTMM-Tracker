import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ootmm_tracker/widgets/greyscale_icon.dart';

class StateIcon extends StatefulWidget {
  final List<String> icons;

  const StateIcon({super.key, required this.icons});

  @override
  State<StateIcon> createState() => _StateIconState();
}

class _StateIconState extends State<StateIcon> {
  int _index = 0;

  void incrementIndex() {
    setState(() {
      if (_index + 1 > widget.icons.length) {
        _index = 0;
      } else {
        _index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var index = _index <= 0 ? _index : _index - 1;
    var icon = widget.icons[index];

    Widget iconGrayscale = GreyscaleIcon(icon: icon);
    Widget iconDefault = Image.asset(icon);

    return Center(child: IconButton(onPressed: incrementIndex, icon: _index > 0 ? iconDefault : iconGrayscale));
  }
}