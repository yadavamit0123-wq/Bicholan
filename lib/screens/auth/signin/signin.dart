import 'package:active_matrimonial_flutter_app/components/common_input.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/main.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/feature/feature_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin_reducer.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../components/auth_screen_wordmark.dart';
import '../../../helpers/functions.dart';
import '../../../helpers/main_helpers.dart';
import '../forgetPassword/forget_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? isGoogle = settingIsActive('google_login_activation', '1');
  bool? isFacebook = settingIsActive('facebook_login_activation', '1');
  bool? isTwitter = settingIsActive('twitter_login_activation', "1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit:
            (store) => [
              SharedPref().isView = true,
              store.dispatch(featureCheckMiddleware()),
            ],
        builder:
            (_, state) => SizedBox(
              height: DeviceInfo(context).height,
              child: buildBody(context, state),
            ),
      ),
    );
  }

  Widget buildBody(BuildContext context, AppState state) {
    final horizontal = DeviceInfo(context).width! * 0.07;

    return Container(
      color: MyTheme.auth_screen_bg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, 12, horizontal, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Center(child: AuthScreenWordmark()),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.login_text_sub_title,
                textAlign: TextAlign.center,
                style: Styles.regular_white_14,
              ),
              const SizedBox(height: 28),
              if (isOtpSystem && (state.addonState?.data?.otpSystem ?? false))
                state.signInState!.isPhone!
                    ? InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        store.dispatch(
                          SetPhoneNumberAction(payload: number.phoneNumber),
                        );
                      },
                      countries:
                          store.state.commonState!.countriesToString(),
                      spaceBetweenSelectorAndTextField: 0,
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                      ),
                      inputDecoration: InputStyle.authWhiteTextField(
                        hint: "01XXX XXX XXX",
                        prefixIcon: Icons.phone_outlined,
                      ),
                    )
                    : TextField(
                      controller: state.signInState!.emailController,
                      onTap: () => store.dispatch(ClearAction()),
                      decoration: InputStyle.authWhiteTextField(hint: "Email"),
                    )
              else
                TextField(
                  controller: state.signInState!.emailController,
                  onTap: () => store.dispatch(ClearAction()),
                  decoration: InputStyle.authWhiteTextField(hint: "Email"),
                ),
              if (state.addonState?.data?.otpSystem ?? false) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => store.dispatch(IsPhoneOrEmailChangeAction()),
                  child: Text(
                    isOtpSystem
                        ? state.signInState!.isPhone!
                            ? AppLocalizations.of(context)!.common_screen_use_email
                            : AppLocalizations.of(context)!.common_screen_use_phone
                        : AppLocalizations.of(context)!.common_screen_use_email,
                    textAlign: TextAlign.right,
                    style: Styles.italic_auth_magenta_10_underline,
                  ),
                ),
              ],
              if (state.signInState!.emailErrorText!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  state.signInState!.emailErrorText!,
                  style: TextStyle(color: MyTheme.failure, fontSize: 11),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                controller: state.signInState!.passwordController,
                obscureText: state.signInState!.isObscure!,
                decoration: InputStyle.authWhitePasswordField(
                  hint: "Password",
                  suffixIcon: GestureDetector(
                    onTap: () => store.dispatch(IsObscureAction()),
                    child: Icon(
                      state.signInState!.isObscure!
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: MyTheme.gull_grey,
                    ),
                  ),
                ),
              ),
              if (state.signInState!.passwordErrorText!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  state.signInState!.passwordErrorText!,
                  style: TextStyle(color: MyTheme.failure, fontSize: 11),
                ),
              ],
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPassword(),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.login_screen_forget_password,
                  textAlign: TextAlign.right,
                  style: Styles.bold_auth_magenta_12,
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap:
                    () => store.dispatch(
                      LoginRequest(payloadContext: context),
                    ),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: Styles.authPrimaryButtonDecoration(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child:
                        state.signInState!.isLogin == false
                            ? Text(
                              '${AppLocalizations.of(context)!.login_button_text} →',
                              style: Styles.bold_white_14,
                            )
                            : CircularProgressIndicator(
                              color: MyTheme.storm_grey,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const SocialLoginWidget(loginScreenStyle: true),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.login_screen_if_have_account,
                    style: Styles.regular_white_12,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      ' ${AppLocalizations.of(context)!.login_screen_signup}',
                      style: Styles.bold_auth_magenta_12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
