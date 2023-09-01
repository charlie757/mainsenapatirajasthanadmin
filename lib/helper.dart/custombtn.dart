import 'package:flutter/material.dart';

class CustomBtn extends StatefulWidget {
  final String title;
  final double height;
  final double width;
  final Function() onTap;
  final Color color;
  const CustomBtn(
      {key,
      required this.title,
      required this.height,
      required this.width,
      required this.onTap,
      this.color = const Color(0xff2596be)});

  @override
  State<CustomBtn> createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: widget.color,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: widget.color),
                borderRadius: BorderRadius.circular(8))),
        onPressed: widget.onTap,
        child: Container(
          alignment: Alignment.center,
          height: widget.height,
          width: widget.width,
          child: Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                // fontFamily: LatoRegular,
                color: Colors.white,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
