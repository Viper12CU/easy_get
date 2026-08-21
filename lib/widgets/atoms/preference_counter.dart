
import 'package:flutter/material.dart';

class PreferenceCounter extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int>? onChange;
  final int maxValue;
  final int minValue;
  const PreferenceCounter({
    super.key,
    required this.initialValue,
    this.onChange,  this.maxValue = 10,  this.minValue = 1,
  });

  @override
  State<PreferenceCounter> createState() => _PreferenceCounterState();
}

class _PreferenceCounterState extends State<PreferenceCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    setState(() {
      count = widget.initialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      spacing: 7,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          () {
            if (count > widget.minValue) {
              setState(() {
                count--;
              });

              widget.onChange!.call(count);
            }
          },
          Icons.remove_rounded,
          theme,
        ),
        Text(count.toString(), style: theme.textTheme.bodyMedium),
        _buildButton(
          () {
            if (count < widget.maxValue) {
              setState(() {
                count++;
              });
              widget.onChange!.call(count);
            }
          },
          Icons.add_rounded,
          theme,
        ),
      ],
    );
  }

  GestureDetector _buildButton(
    void Function() onTap,
    IconData icon,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Theme.of(context).colorScheme.outline.withAlpha(140),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}
