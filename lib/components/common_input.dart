import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class InputStyle {
  static InputDecoration inputDecoratio_password({
    String? hint,
    Widget suffixIcon = const SizedBox(),
  }) {
    return InputDecoration(
      filled: true,
      fillColor: MyTheme.solitude,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MyTheme.app_accent_color),
      ),
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14, color: MyTheme.light_grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIcon: suffixIcon,
    );
  }

  static InputDecoration inputDecoration_text_field({
    String? hint,
    Widget suffixIcon = const SizedBox(),
  }) {
    return InputDecoration(
      filled: true,
      fillColor: MyTheme.solitude,

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.transparent),
      ),

      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      hintText: hint,
      hintStyle: Styles.regular_gull_grey_12,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),

      suffixIcon: suffixIcon,

      // helperText: 'Helper text',
    );
  }

  static const double _authFieldRadius = 28;

  /// Login mockup: white pill fields on orange background.
  static InputDecoration authWhiteTextField({
    required String hint,
    IconData prefixIcon = Icons.person_outline,
    Widget suffixIcon = const SizedBox(),
  }) {
    return InputDecoration(
      filled: true,
      fillColor: MyTheme.white,
      prefixIcon: Icon(prefixIcon, color: MyTheme.gull_grey, size: 22),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(_authFieldRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_authFieldRadius),
        borderSide: BorderSide.none,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14, color: MyTheme.gull_grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_authFieldRadius),
      ),
      suffixIcon: suffixIcon,
    );
  }

  static InputDecoration authWhitePasswordField({
    required String hint,
    required Widget suffixIcon,
  }) {
    return authWhiteTextField(
      hint: hint,
      prefixIcon: Icons.lock_outline,
      suffixIcon: suffixIcon,
    );
  }

  static Widget manage_profile_expanded_box({required context, hint}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.manage_profile_f_name),
          const SizedBox(height: 5),
          TextFormField(
            decoration: InputStyle.inputDecoration_text_field(hint: "Sara B."),
          ),
        ],
      ),
    );
  }
}
