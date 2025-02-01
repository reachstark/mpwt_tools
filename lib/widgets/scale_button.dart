import 'dart:async';
import 'package:flutter/material.dart';

class DebounceHandler {
  final int milliseconds;
  Timer? _timer;
  bool _firstClick = true;

  DebounceHandler({required this.milliseconds});

  void run(VoidCallback action) {
    if (_firstClick) {
      _firstClick = false;
      action();
      return;
    }

    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }
}

class ScaleButton extends StatefulWidget {
  const ScaleButton({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    this.bound = 0.1,
    this.onTap,
    this.reverse = false,
    required this.child,
    this.behavior,
    this.debounceMilliseconds = 500,
    this.isDebounce = false,
    this.onLongPress,
    this.tooltip,
  });

  final Duration duration;
  final double bound;
  final int debounceMilliseconds;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final bool reverse;
  final HitTestBehavior? behavior;
  final bool isDebounce;
  final String? tooltip;

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  late AnimationController _controller;
  late final DebounceHandler _debounceHandler;

  @override
  void initState() {
    super.initState();
    _debounceHandler =
        DebounceHandler(milliseconds: widget.debounceMilliseconds);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      upperBound: widget.bound,
    )..addListener(() {
        setState(() {
          _scale =
              widget.reverse ? 1 + _controller.value : 1 - _controller.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      onTap: () {
        if (widget.onTap != null) {
          if (widget.isDebounce) {
            _debounceHandler.run(widget.onTap ?? () {});
          } else {
            widget.onTap!();
          }
        }
        _controller.forward().then((_) => _controller.reverse());
      },
      onLongPress: () {
        if (widget.onLongPress != null) {
          if (widget.isDebounce) {
            _debounceHandler.run(widget.onLongPress ?? () {});
          } else {
            widget.onLongPress!();
          }
        }
      },
      behavior: widget.behavior,
      child: Transform.scale(
        scale: _scale,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: widget.tooltip != null
              ? Tooltip(
                  message: widget.tooltip!,
                  child: widget.child,
                )
              : widget.child,
        ),
      ),
    );
  }
}
