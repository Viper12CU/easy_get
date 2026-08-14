import 'dart:math' as math;

import 'package:flutter/material.dart';

class DiamondFileIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color? iconColor;

  const DiamondFileIcon({
    super.key,
    this.icon = Icons.file_present_rounded,
    this.size = 39,
    required this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -45 * math.pi / 180,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Transform.rotate(
          angle: 45 * math.pi / 180,
          child: Center(
            child: Icon(icon, color: iconColor),
          ),
        ),
      ),
    );
  }
}
