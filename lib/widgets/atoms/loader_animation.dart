import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderAnimation extends StatelessWidget {
  final Color? color;
  final double? size;
  const LoaderAnimation({this.color, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return LoadingAnimationWidget.dotsTriangle(
      color: color ?? colorScheme.primary,
      size: size ?? 12,
    );
  }
}
