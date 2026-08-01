import 'package:flutter/material.dart';

class PlayerHeader extends StatefulWidget {
  final String playerName;
  final int runningTotal;
  final bool isWinner;
  final String wind;

  final VoidCallback onWinnerTapped;
  final ValueChanged<String> onNameChanged;

  /// Allow wind selection (typically only during Round 1)
  final bool canSelectEast;

  /// Called when the wind label is tapped
  final VoidCallback? onEastTapped;

  const PlayerHeader({
    super.key,
    required this.playerName,
    required this.runningTotal,
    required this.isWinner,
    required this.wind,
    required this.onWinnerTapped,
    required this.onNameChanged,
    this.canSelectEast = false,
    this.onEastTapped,
  });

  @override
  State<PlayerHeader> createState() => _PlayerHeaderState();
}

class _PlayerHeaderState extends State<PlayerHeader> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.playerName,
    );

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _saveName();
      }
    });
  }

  @override
  void didUpdateWidget(covariant PlayerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Refresh immediately whenever the wind changes.
    if (oldWidget.wind != widget.wind) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }

    // Keep the text field synchronized with the saved player name.
    if (!_focusNode.hasFocus &&
        widget.playerName != _controller.text) {
      _controller.text = widget.playerName;
    }
  }

  void _saveName() {
    final name = _controller.text.trim();

    if (name.isNotEmpty &&
        name != widget.playerName) {
      widget.onNameChanged(name);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onWinnerTapped,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _saveName(),
              ),
            ),

            const SizedBox(height: 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.onWinnerTapped,
                  child: Text(
                    widget.isWinner ? "●" : "○",
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.isWinner
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                GestureDetector(
                  onTap: widget.canSelectEast
                      ? widget.onEastTapped
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: widget.canSelectEast
                        ? BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                    child: Text(
                      widget.wind,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  widget.runningTotal.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}