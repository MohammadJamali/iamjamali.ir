import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SlideToAction extends StatefulWidget {
  final AsyncCallback action;
  final String callToAction;
  final TextStyle? callToActionStyle;
  final Widget icon;
  final Color iconButtonColor;
  final Color sliderColor;
  final BorderRadius borderRadius;
  final Widget? progressIndicator;
  final Duration animationSpeed;
  final double height;

  const SlideToAction({
    super.key,
    required this.action,
    this.height = 60,
    this.icon = const Icon(
      Icons.phone,
      color: Colors.green,
      size: 28,
    ),
    this.animationSpeed = const Duration(milliseconds: 300),
    this.sliderColor = const Color.fromARGB(150, 143, 143, 143),
    this.iconButtonColor = Colors.white,
    this.callToAction = "Slide To Answare",
    this.borderRadius = const BorderRadius.all(Radius.circular(160)),
    this.progressIndicator,
    this.callToActionStyle,
  });

  @override
  State<SlideToAction> createState() => _SlideToActionState();
}

class _SlideToActionState extends State<SlideToAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? tween;

  final padding = 4.0;
  final GlobalKey _sliderKey = GlobalKey();
  final GlobalKey _iconButtonKey = GlobalKey();

  Size? _sliderSize;
  Size? _iconButtonSize;

  double _iconButtonPosition = 0;
  double _dragPercent = 0;

  bool _pullbackAnimationPlaying = false;
  bool _canDrag = true;
  bool _isProgress = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationSpeed,
      value: 0.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => refreshWidgetSizes());
  }

  void refreshWidgetSizes() {
    setState(() {
      _sliderSize = _sliderKey.currentContext?.size;
      _iconButtonSize = _iconButtonKey.currentContext?.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _sliderKey,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.sliderColor,
        borderRadius: widget.borderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: max(0, 1 - (_dragPercent / 75)),
                    child: child!,
                  );
                },
                child: Text(
                  widget.callToAction,
                  style: widget.callToActionStyle ??
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            // fontFamily: 'libertinus',
                          ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  left: setIconButtonPosition(
                    tween?.value ?? 0,
                  ),
                  child: child!,
                );
              },
              child: GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  _sliderSize = _sliderKey.currentContext?.size;
                  _iconButtonSize = _iconButtonKey.currentContext?.size;
                },
                onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
                  if (_pullbackAnimationPlaying || !_canDrag) return;
                  _onGestureSlide(dragUpdateDetails.delta.dx);
                },
                onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
                  if (_pullbackAnimationPlaying || !_canDrag) return;

                  _sliderSize = _sliderKey.currentContext?.size;
                  _iconButtonSize = _iconButtonKey.currentContext?.size;
                  _onGestureEnd();
                },
                child: Container(
                  key: _iconButtonKey,
                  height: widget.height - (padding * 2),
                  width: widget.height - (padding * 2),
                  decoration: BoxDecoration(
                    color: widget.iconButtonColor,
                    borderRadius: widget.borderRadius,
                  ),
                  child: _isProgress
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (widget.progressIndicator ??
                              const CircularProgressIndicator(
                                color: Colors.green,
                              )),
                        )
                      : widget.icon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Because depend
  var animationDx = 0.0;
  void _onGestureSlide(double dx) {
    animationDx += dx;
    if (tween?.isCompleted ?? true) {
      tween = Tween(begin: 0.0, end: animationDx)
          .chain(CurveTween(curve: const Threshold(0.5)))
          .animate(_animationController);
    }

    _animationController.value = 1;
  }

  // handles when user stops sliding
  void _onGestureEnd() {
    if (_dragPercent == 100) {
      _canDrag = false;
      setState(() {
        _isProgress = true;
      });
      widget.action().whenComplete(() {
        _canDrag = true;
        setState(() {
          _isProgress = false;
        });
        pullBackTheIconButton();
      });
    } else {
      pullBackTheIconButton();
    }
  }

  void pullBackstatusListener(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    tween!.removeStatusListener(pullBackstatusListener);
    _pullbackAnimationPlaying = false;
  }

  void pullBackTheIconButton() {
    _pullbackAnimationPlaying = true;
    _animationController.reset();
    tween = Tween(begin: _iconButtonPosition, end: 0.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_animationController);
    tween!.addStatusListener(pullBackstatusListener);
    _animationController.forward();
  }

  double setIconButtonPosition(double dx) {
    if (_sliderSize?.width == null) return 0;

    if (!_pullbackAnimationPlaying) {
      _iconButtonPosition += dx;
      animationDx -= dx;
    } else {
      _iconButtonPosition = dx;
    }

    final maxValue =
        _sliderSize!.width - _iconButtonSize!.width - (padding * 2);

    // don't let the scroller, scroll [end]side too much
    _iconButtonPosition = min(maxValue, _iconButtonPosition);
    // don't let the scroller, scroll [start]side too much
    _iconButtonPosition = max(0, _iconButtonPosition);

    _dragPercent = (_iconButtonPosition / maxValue) * 100;

    return _iconButtonPosition;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
