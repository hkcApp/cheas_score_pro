import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxValue = 99,
    this.enabled = true,
    this.playerColor,
    this.compact = false,
  });

  final int value;

  final ValueChanged<int> onChanged;

  final int maxValue;

  final bool enabled;

  /// Optional player color theme.
  final Color? playerColor;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tintColor = playerColor ?? Colors.transparent;
    final controlWidth = compact ? 24.0 : 80.0;
    final controlHeight = compact ? 24.0 : 40.0;

    return Container(
      width: controlWidth,
      height: controlHeight,
      padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 8),
      decoration: BoxDecoration(
        color: enabled ? tintColor.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(compact ? 12 : 8),
        border: Border.all(
          color: enabled
              ? tintColor.withValues(alpha: 0.3)
              : Colors.grey.shade300,
        ),
      ),
      child: PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        tooltip: 'Select quantity',
        onSelected: enabled ? onChanged : null,
        itemBuilder: (context) => List<PopupMenuEntry<int>>.generate(
          maxValue + 1,
          (index) => PopupMenuItem<int>(
            value: index,
            child: Text(
              index.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        child: compact
            ? Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: enabled ? playerColor ?? Colors.black : Colors.grey,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: enabled
                          ? playerColor ?? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: enabled ? playerColor ?? Colors.black : Colors.grey,
                  ),
                ],
              ),
      ),
    );
  }
}
