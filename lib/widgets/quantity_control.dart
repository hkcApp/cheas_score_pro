import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.maxValue = 99,
    this.enabled = true,
  });

  final int value;

  final VoidCallback onIncrement;

  final VoidCallback onDecrement;

  final int maxValue;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 42,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [

          // Decrease button
          SizedBox(
            width: 30,
            height: 42,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 28,
              icon: const Icon(
                Icons.keyboard_arrow_down,
              ),
              color: enabled
                  ? null
                  : Colors.grey,
              onPressed:
                  enabled
                      ? onDecrement
                      : null,
            ),
          ),


          // Number display
          SizedBox(
            width: 28,
            child: Text(
              value.toString(),
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
                color: enabled
                    ? null
                    : Colors.grey,
              ),
            ),
          ),


          // Increase button
          SizedBox(
            width: 30,
            height: 42,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 28,
              icon: const Icon(
                Icons.keyboard_arrow_up,
              ),
              color: enabled
                  ? null
                  : Colors.grey,
              onPressed:
                  enabled &&
                          value < maxValue
                      ? onIncrement
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}