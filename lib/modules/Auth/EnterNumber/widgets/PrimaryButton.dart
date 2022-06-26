import 'package:flutter/material.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';

class PrimaryButton extends StatefulWidget {
  final String btnText;
  final Function() onTap;
  const PrimaryButton({
    required this.btnText,
    required this.onTap,
  });

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 0.17,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: widget.onTap,
      child: Transform.scale(
          scale: _scale,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ColorUtil().primaryRed,
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xffEE3124).withOpacity(0.3),
                      blurRadius: 18,
                      offset: const Offset(2, 10)),
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 18,
                      offset: const Offset(2, 10))
                ]),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                widget.btnText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )

          //  MaterialButton(
          //   // onPressed: ,

          //   onPressed: (() {}),
          //   animationDuration: const Duration(milliseconds: 100),
          //   color: ColorUtil().primaryRed,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(50.0),
          //   ),
          //   elevation: 12,
          //   highlightElevation: 0,
          //   focusElevation: 0,
          //   enableFeedback: true,

          //   hoverElevation: 0,
          //   child:
          // ),
          ),
    );
  }
}
