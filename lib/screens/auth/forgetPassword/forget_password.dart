
import 'package:active_matrimonial_flutter_app/components/common_input.dart';
import 'package:active_matrimonial_flutter_app/components/group_item_with_child.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/main.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/forgetPassword/forgetpassword_action.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool? isOtpSystem = store.state.addonState!.data!.otpSystem;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: screenSize.height,
          child: Stack(
            children: [
              Container(
                height: screenSize.height * 0.40,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenSize.height * 0.05),
                    ImageIcon(
                      const AssetImage('assets/logo/app_logo.png'),
                      size: screenSize.height * 0.11,
                      color: MyTheme.white,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      AppLocalizations.of(context)!.forget_screen_title,
                      style: Styles.bold_white_22.copyWith(fontSize: screenSize.width * 0.06),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                      child: Text(
                        AppLocalizations.of(context)!.forget_screen_subtitle,
                        style: Styles.regular_white_14.copyWith(fontSize: screenSize.width * 0.035),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom form section
              Positioned(
                bottom: 0,
                child: Container(
                  height: screenSize.height * 0.65,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenSize.width * 0.08),
                      topRight: Radius.circular(screenSize.width * 0.08),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.08,
                        vertical: screenSize.height * 0.04,
                      ),
                      child: Form(
                        key: state.forgetPasswordState!.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GroupItemWithChild(
                              title: state.forgetPasswordState!.valueChanger! ? "Phone" : "Email",
                              style: Styles.bold_app_accent_12.copyWith(fontSize: screenSize.width * 0.035),
                              child: state.forgetPasswordState!.valueChanger!
                                  ? Container(
                                decoration: BoxDecoration(
                                  color: MyTheme.solitude,
                                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                ),
                                child: isOtpSystem!
                                    ? InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    store.dispatch(SetForgetPasswordPhoneNumberAction(payload: number.phoneNumber));
                                  },
                                  spaceBetweenSelectorAndTextField: 0,
                                  countries: store.state.commonState!.countriesToString(),
                                  selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG),
                                  inputDecoration: InputStyle.inputDecoration_text_field(hint: "01XXX XXX XXX"),
                                  textStyle: TextStyle(fontSize: screenSize.width * 0.04),
                                )
                                    : const SizedBox.shrink(),
                              )
                                  : TextFormField(
                                controller: state.forgetPasswordState!.forgetpasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter email address';
                                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return "Please enter a valid email address";
                                  return null;
                                },
                                decoration: InputStyle.inputDecoration_text_field(hint: "johndoe@example.com"),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            InkWell(
                              onTap: () => store.dispatch(ForgetPasswordEmailOrPhoneAction()),
                              child: SizedBox(
                                width: screenSize.width,
                                child: Text(
                                  state.forgetPasswordState!.valueChanger!
                                      ? AppLocalizations.of(context)!.common_screen_use_email
                                      : isOtpSystem!
                                      ? AppLocalizations.of(context)!.common_screen_use_phone
                                      : '',
                                  textAlign: TextAlign.right,
                                  style: Styles.italic_app_accent_10_underline.copyWith(fontSize: screenSize.width * 0.03),
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.05),
                            InkWell(
                              onTap: () => store.dispatch(SendCodeAction(payloadContext: context)),
                              child: Container(
                                height: screenSize.height * 0.06,
                                width: screenSize.width,
                                decoration: BoxDecoration(
                                  gradient: Styles.buildLinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight),
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Center(
                                  child: state.forgetPasswordState!.fp_loader == false
                                      ? Text(
                                    AppLocalizations.of(context)!.forget_screen_send_code,
                                    style: Styles.bold_white_14.copyWith(fontSize: screenSize.width * 0.04),
                                  )
                                      :  CircularProgressIndicator(color: MyTheme.storm_grey),
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.forget_screen_or_back_to,
                                  style: Styles.regular_gull_grey_12.copyWith(fontSize: screenSize.width * 0.035),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    ' ${AppLocalizations.of(context)!.forget_screen_login}',
                                    style: Styles.bold_app_accent_12.copyWith(fontSize: screenSize.width * 0.035),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}