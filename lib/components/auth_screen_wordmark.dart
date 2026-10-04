import 'package:flutter/material.dart';

/// Bicholan.com wordmark from mockup — rendered white on orange auth screens.
class AuthScreenWordmark extends StatelessWidget {
  const AuthScreenWordmark({super.key, this.widthFactor = 0.78});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoWidth = screenWidth * widthFactor;
    return SizedBox(
      width: logoWidth,
      height: logoWidth * 0.38,
      child: Image.asset(
        'assets/logo/splash_logo.png',
        fit: BoxFit.contain,
        color: Colors.white,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
