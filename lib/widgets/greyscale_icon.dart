import "package:flutter/material.dart";

class GreyscaleIcon extends StatelessWidget {
  final String icon;

  const GreyscaleIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    const ColorFilter greyscale = ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);

    return ColorFiltered(
      colorFilter: greyscale,
      child: Opacity(
        opacity: 0.25,
        child: Image.asset(icon),
      ),
    );
  }
}