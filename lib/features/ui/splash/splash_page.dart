import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'splash_content.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SplashContent(),
      ),
    );
  }
}
