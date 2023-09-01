import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          width: 60,
          child: const CircularProgressIndicator(
            color: Color(0xfffbffe8),
            backgroundColor: Color(0xff213865),
          ),
        )
      ],
    );
  }
}
