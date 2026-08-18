import 'package:flutter/material.dart';

class PreferencesCategory extends StatelessWidget {
  final String label;
  final Widget child;
  const PreferencesCategory({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall,),
        child
      ],
    );
  }
}