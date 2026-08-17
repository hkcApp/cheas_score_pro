import 'package:flutter/material.dart';

import '../theme/player_colors.dart';

class PlayerHeader extends StatefulWidget {
  final int playerIndex;

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
    required this.playerIndex,
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

    _controller = TextEditingController(text: widget.playerName);

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

    if (!_focusNode.hasFocus && widget.playerName != _controller.text) {
      _controller.text = widget.playerName;
    }
  }

  void _saveName() {
    final name = _controller.text.trim();

    if (name != widget.playerName) {
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
    final theme = PlayerColors.player(widget.playerIndex);

    return InkWell(
      onTap: widget.onWinnerTapped,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 28,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: 1,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.foreground,
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
                  key: ValueKey(
                    'winner-selector-${widget.playerIndex}',
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onWinnerTapped,
                  child: SizedBox(
                    width: 18,
                    height: 24,
                    child: Center(
                      child: Text(
                        widget.isWinner ? "●" : "○",
                        style: TextStyle(
                          fontSize: 18,
                          color: widget.isWinner
                              ? Colors.green
                              : theme.border,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: widget.canSelectEast
                      ? widget.onEastTapped
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: widget.canSelectEast
                        ? BoxDecoration(
                            color: theme.border.withValues(
                              alpha: 0.35,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                    child: Text(
                      widget.wind,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.foreground,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.runningTotal.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.foreground,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
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