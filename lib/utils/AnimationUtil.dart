import 'dart:math';
import 'package:flutter/material.dart';

enum AnimationTrigger {
  onPageLoad,
  onActionTrigger,
}

class AnimationInfo {
  AnimationInfo({
    this.curve = Curves.easeInOut,
    required this.trigger,
    required this.duration,
    this.delay = 0,
    this.fadeIn = false,
    required this.slideOffset,
    this.scale = 0,
  });

  final Curve curve;
  final AnimationTrigger trigger;
  final int duration;
  final int delay;
  final bool fadeIn;
  final Offset slideOffset;
  final double scale;
  late CurvedAnimation curvedAnimation;
}

void createAnimation(AnimationInfo animation, TickerProvider vsync) {
  animation.curvedAnimation = CurvedAnimation(
    parent: AnimationController(
      duration: Duration(milliseconds: animation.duration),
      vsync: vsync,
    ),
    curve: animation.curve,
  );
}

void startPageLoadAnimations(Iterable<AnimationInfo> animations, TickerProvider vsync) {
  animations.forEach((animation) async {
    createAnimation(animation, vsync);
    await Future.delayed(
      Duration(milliseconds: animation.delay),
      () => (animation.curvedAnimation.parent as AnimationController).forward(from: 0.0),
    );
  });
}

void setupTriggerAnimations(Iterable<AnimationInfo> animations, TickerProvider vsync) {
  animations.forEach((animation) {
    createAnimation(animation, vsync);
    (animation.curvedAnimation.parent as AnimationController).forward(from: 1.0);
  });
}

extension AnimatedWidgetExtension on Widget {
  Widget animated(Iterable<AnimationInfo> animationInfos) {
    final animationInfo = animationInfos.first;
    return AnimatedBuilder(
      animation: animationInfo.curvedAnimation,
      builder: (context, child) {
        Widget returnedWidget = child!;
        if (animationInfo.slideOffset != null) {
          final animationValue = 1 - animationInfo.curvedAnimation.value;
          returnedWidget = Transform.translate(
            child: child,
            offset: animationInfo.slideOffset * -animationValue,
          );
        }
        if (animationInfo.scale > 0 && animationInfo.scale != 1.0) {
          final scale = returnedWidget = Transform.scale(
            scale: animationInfo.scale +
                (1.0 - animationInfo.scale) * animationInfo.curvedAnimation.value,
            child: child,
          );
        }
        if (animationInfo.fadeIn) {
          returnedWidget = Opacity(
            opacity: min(0.998, animationInfo.curvedAnimation.value),
            child: returnedWidget,
          );
        }

        return returnedWidget;
      },
      child: animationInfos.length > 1 ? animated(animationInfos.skip(1)) : this,
    );
  }
}

final animationsMap = {
  'columnOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    duration: 700,
    delay: 100,
    fadeIn: true,
    slideOffset: Offset(0, 35),
  ),
  'textOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    duration: 600,
    delay: 140,
    fadeIn: true,
    slideOffset: Offset(-32, 0),
  ),
  'textFieldOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    duration: 600,
    delay: 180,
    fadeIn: true,
    slideOffset: Offset(-28, 0),
  ),
  'floatingActionButtonOnPageLoadAnimation': AnimationInfo(
    curve: Curves.bounceOut,
    trigger: AnimationTrigger.onPageLoad,
    duration: 520,
    delay: 580,
    fadeIn: true,
    slideOffset: Offset(0, 56),
  ),
  'qrButtonClickAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    duration: 500,
    delay: 470,
    fadeIn: true,
    slideOffset: Offset(0, 15.999999999999986),
    scale: 0.87,
  ),
};
