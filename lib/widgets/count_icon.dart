import 'package:flutter/material.dart';
import 'package:ootmm_tracker/widgets/greyscale_icon.dart';

class CountIcon extends StatefulWidget {
  final String icon;
  final int max;

  const CountIcon({super.key, required this.icon, required this.max});

  @override
  State<CountIcon> createState() => _CountIconState();
}

class _CountIconState extends State<CountIcon> {
  int _count = 0;

  incrementCount() {
    setState(() {
      if (_count + 1 > widget.max) {
        _count = 0;
      } else {
        _count++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget iconGrayscale = GreyscaleIcon(icon: widget.icon);
    Widget iconDefault = Image.asset(widget.icon);

    return Center(
      child: Stack(
        children: [
          IconButton(onPressed: incrementCount, icon: _count > 0 ? iconDefault : iconGrayscale),
          Text("$_count", style: TextStyle(color: _count >= widget.max ? Colors.green : Colors.white),),
        ],
      ),
    );
  }
}