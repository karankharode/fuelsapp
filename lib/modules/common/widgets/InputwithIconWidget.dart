import 'package:flutter/material.dart';

class InputWithIcon extends StatefulWidget {
  final String icon;
  final String hint;
  InputWithIcon({required this.icon, required this.hint});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF9A5F0D).withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                BoxShadow(color: Color(0xffE8E8E8), offset: Offset(0, 7), blurRadius: 30)
              ]),
              width: 50,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.fromLTRB(5, 5, 15, 5),
              child: Image.asset(
                "assets/images/${widget.icon}.png",
              )),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(fontFamily: "Sofia"),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: widget.hint),
            ),
          )
        ],
      ),
    );
  }
}
