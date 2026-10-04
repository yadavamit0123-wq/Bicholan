import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:flutter/material.dart';

class MyGradientContainer extends StatelessWidget {
  final Widget text;
  final Color? backgroundColor;

  const MyGradientContainer({
    required this.text,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: DeviceInfo(context).width,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundColor == null
            ? Styles.buildLinearGradient(
                begin: Alignment.centerLeft, end: Alignment.centerRight)
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Center(
        child: text,
      ),
    );
  }
}
