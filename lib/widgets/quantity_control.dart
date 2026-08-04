import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxValue = 99,
    this.enabled = true,
    this.playerColor,
  });

  final int value;

  final ValueChanged<int> onChanged;

  final int maxValue;

  final bool enabled;

  /// Optional player color theme.
  final Color? playerColor;

  @override
  Widget build(BuildContext context) {
    final tintColor = playerColor ?? Colors.transparent;

    return Container(
      width: 80,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: enabled
            ? tintColor.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: enabled
              ? tintColor.withValues(alpha: 0.3)
              : Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: enabled ? playerColor ?? Colors.black : Colors.grey,
          ),
          dropdownColor: Colors.white,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: enabled ? playerColor ?? Colors.black : Colors.grey,
          ),
          items: List<DropdownMenuItem<int>>.generate(
            maxValue + 1,
            (index) => DropdownMenuItem<int>(
              value: index,
              child: Text(index.toString()),
            ),
          ),
          onChanged: enabled
              ? (selected) {
                  if (selected != null) {
                    onChanged(selected);
                  }
                }
              : null,
        ),
      ),
    );
  }
}