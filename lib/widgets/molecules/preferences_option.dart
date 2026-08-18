import 'package:flutter/material.dart';

class PreferencesOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget action;
  const PreferencesOption({super.key, required this.title, required this.subtitle, required this.action});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.labelLarge, ),
                  Text(subtitle, style: textTheme.labelSmall!.copyWith(fontSize: 9), overflow: TextOverflow.clip,)
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: action)
          ],
        ),
      ),
    );
  }
}