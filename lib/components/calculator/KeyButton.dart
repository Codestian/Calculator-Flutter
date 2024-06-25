import 'package:calculator/enums/key_color_enums.dart';
import 'package:flutter/material.dart';

class KeyButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final KeyColor color;
  final Function onTap;
  final int flex;
  final double aspectRatio;

  const KeyButton({
    super.key,
    required this.text,
    this.icon,
    required this.color,
    required this.onTap,
    this.flex = 1,
    this.aspectRatio = 1,
  });

  @override
  _KeyButtonState createState() => _KeyButtonState();
}

class _KeyButtonState extends State<KeyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 0.2).animate(_controller);
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: () {
            widget.onTap(widget.text);
          },
         child: Container(
       color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _getColor(context, widget.color),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.05),
                                width: 2),
                          ),
                          child: Center(
                            child: widget.icon == null
                                ? Text(
                                    widget.text,
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )
                                : Icon(
                                    widget.icon,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(_opacityAnimation.value),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(BuildContext context, KeyColor color) {
    switch (color) {
      case KeyColor.action:
        return Theme.of(context).colorScheme.primary;
      case KeyColor.number:
        return Theme.of(context).colorScheme.secondary.withOpacity(0.2);
      case KeyColor.operator:
        return Theme.of(context).colorScheme.secondary.withOpacity(0.1);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
