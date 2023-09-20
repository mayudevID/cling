import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OvalStack extends StatelessWidget {
  const OvalStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 33.33.w,
          width: (33.33 / 2).w,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF313131),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(139.50.wmea),
                topRight: Radius.circular(139.50.wmea),
              ),
            ),
          ),
        ),
        Container(
          width: 33.33.w,
          height: 33.33.w,
          decoration: const ShapeDecoration(
            color: Color(0xFF313131),
            shape: OvalBorder(),
          ),
        ),
        Container(
          width: 33.33.w,
          height: 33.33.w,
          decoration: const ShapeDecoration(
            color: Color(0xFF313131),
            shape: OvalBorder(),
          ),
        ),
        Container(
          height: 33.33.w,
          width: (33.33 / 2).w,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF313131),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(139.50.wmea),
                topLeft: Radius.circular(139.50.wmea),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
