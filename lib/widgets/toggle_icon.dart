import 'package:flutter/material.dart';
import 'package:ootmm_tracker/widgets/greyscale_icon.dart';

class ToggleIcon extends StatefulWidget {
  final String icon;

  const ToggleIcon({super.key, required this.icon});

  @override
  State<ToggleIcon> createState() => _ToggleIconState();
}

class _ToggleIconState extends State<ToggleIcon> {
  bool _toggled = false;

  void toggleState() {
    setState(() {
      _toggled = !_toggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget iconGrayscale = GreyscaleIcon(icon: widget.icon);
    Widget iconDefault = Image.asset(widget.icon);

    return Center(child: IconButton(onPressed: toggleState, icon: _toggled ? iconDefault : iconGrayscale));
  }
}