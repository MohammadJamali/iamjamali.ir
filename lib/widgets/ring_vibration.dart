import 'package:flutter/widgets.dart';

class RingVibration extends StatefulWidget {
  final List<double> routationPattern;
  final double scaleFactor;

  final Duration? startDelay;
  final Duration ringDuration;
  final Duration restDuration;

  final bool automatic;

  final Widget child;

  const RingVibration({
    super.key,
    required this.child,
    this.scaleFactor = 1.1,
    this.automatic = true,
    this.routationPattern = const [
      0.5,
      0,
      0.5,
      0,
      0.5,
      0,
      0.5,
      0,
      0.5,
      0,
      0.5,
      0,
    ],
    this.ringDuration = const Duration(milliseconds: 1000),
    this.restDuration = const Duration(milliseconds: 3000),
    this.startDelay,
  });

  @override
  State<RingVibration> createState() => RingVibrationState();
}

class RingVibrationState extends State<RingVibration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.ringDuration,
    );

    _animation = TweenSequence<double>(
      widget.routationPattern
          .asMap()
          .map(
            (index, rotation) => MapEntry(
              index,
              TweenSequenceItem<double>(
                tween: Tween(
                    begin: index == 0 ? .0 : widget.routationPattern[index - 1],
                    end: rotation),
                weight: 100 / widget.routationPattern.length,
              ),
            ),
          )
          .values
          .toList(),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.0, .95),
      ),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.scaleFactor),
        weight: 0.75,
      ),
      TweenSequenceItem(
        tween: ConstantTween(widget.scaleFactor),
        weight: 0.20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.scaleFactor, end: 1.0),
        weight: 0.05,
      ),
    ]).animate(_controller);

    if (widget.automatic) {
      _controller.addStatusListener(_onRingListener);
    }

    if (widget.startDelay != null) {
      Future.delayed(widget.startDelay!, _controller.forward);
    }

    if (widget.automatic) {
      _controller.forward();
    }
  }

  void ring() {
    if (_controller.isAnimating) {
      return;
    }

    _controller.removeStatusListener(_onRingListener);

    _controller.reset();
    _controller.forward();
  }

  void _onRingListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reset();
      Future.delayed(widget.restDuration, _controller.forward);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(_animation.value)
            ..scale(_scaleAnimation.value),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.clearStatusListeners();
    _controller.dispose();

    super.dispose();
  }
}
