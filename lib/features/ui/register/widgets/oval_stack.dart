import 'package:flutter/material.dart';

class OvalStack extends StatelessWidget {
  const OvalStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 33.33,
          width: (33.33 / 2),
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF313131),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(139.50),
                topRight: Radius.circular(139.50),
              ),
            ),
          ),
        ),
        Container(
          width: 33.33,
          height: 33.33,
          decoration: const ShapeDecoration(
            color: Color(0xFF313131),
            shape: OvalBorder(),
          ),
        ),
        Container(
          width: 33.33,
          height: 33.33,
          decoration: const ShapeDecoration(
            color: Color(0xFF313131),
            shape: OvalBorder(),
          ),
        ),
        Container(
          height: 33.33,
          width: (33.33 / 2),
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF313131),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(139.50),
                topLeft: Radius.circular(139.50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
