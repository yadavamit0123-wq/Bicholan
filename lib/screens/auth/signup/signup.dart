import 'dart:developer';
import 'package:active_matrimonial_flutter_app/components/common_input.dart';
import 'package:active_matrimonial_flutter_app/components/common_privacy_and_terms_page.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/components/group_item_with_child.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/add_on/addon_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../app_config.dart';
import '../../../components/contact_faq_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../../redux/libs/drop_down/on_behalf_middleware.dart';
import '../../../redux/libs/staticPage/static_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final bool _isRecaptchaActive = settingIsActive(
    'recaptcha_user_register',
    '1',
  );

  late final WebViewController _controller;
  final String _recaptchaUrl = "${AppConfig.BASE_URL}/google-recaptcha";

  final bool _isObscure = true;

  PhoneNumber _selectedPhoneNumber = PhoneNumber(isoCode: '');
  final TextEditingController _otpController = TextEditingController();
  bool _isCodeSent = false;
  bool _isSendingCode = false;
  bool _isVerified = false;
  bool _verificationFailed = false;
  bool _isVerifyingCode = false;

  bool? isGoogle = settingIsActive('google_login_activation', '1');
  bool? isFacebook = settingIsActive('facebook_login_activation', '1');
  bool? isTwitter = settingIsActive('twitter_login_activation', "1");

  bool? isOtpSystem = store.state.addonState!.data!.otpSystem ?? false;
  bool? isReferralSystem =
      store.state.addonState!.data!.referralSystem ?? false;

  @override
  void initState() {
    super.initState();
    if (_isRecaptchaActive) {
      _setupWebViewController();
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _setupWebViewController() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..addJavaScriptChannel(
            'Captcha',
            onMessageReceived: (JavaScriptMessage message) {
              log("reCAPTCHA v3 Token Received: ${message.message}");
              if (message.message.isNotEmpty && message.message != "error") {
                store.dispatch(
                  SetKeyValueAction(keyValuePayload: message.message),
                );
              }
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                if (request.url == _recaptchaUrl) {
                  return NavigationDecision.navigate;
                } else {
                  _launchUrl(request.url);
                  return NavigationDecision.prevent;
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(_recaptchaUrl));
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      log('Could not launch $url');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the page.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) {
          store.dispatch(fetchOnbehalfMiddleware());
          store.dispatch(addonCheckMiddleware());
          store.dispatch(fetchStaticPageAction());
          final AppState state = store.state;
          final String? initialGender = state.signUpState?.currentGender;

          if (state.systemSettingState?.settingResponse?.data != null &&
              initialGender != null &&
              initialGender.isNotEmpty) {
            String minAgeString = '0';
            if (initialGender == 'Male') {
              minAgeString =
                  state
                      .systemSettingState!
                      .settingResponse!
                      .data!['male_min_age'] ??
                  '0';
            } else if (initialGender == 'Female') {
              minAgeString =
                  state
                      .systemSettingState!
                      .settingResponse!
                      .data!['female_min_age'] ??
                  '0';
            }

            final int minimumAge = int.tryParse(minAgeString) ?? 0;

            final DateTime initialDoB = DateTime(
              DateTime.now().year - minimumAge,
              DateTime.now().month,
              DateTime.now().day,
            );
            store.dispatch(SignupSetDateTimeAction(payload: initialDoB));
          }
        },
        builder:
            (_, state) => SizedBox(
              height: DeviceInfo(context).height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildGradeintLogo(context),
                          Container(
                            width: DeviceInfo(context).width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32.0),
                                topRight: Radius.circular(32.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Form(
                                key: state.signUpState!.signUpFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GroupItemWithChild(
                                      title:
                                          AppLocalizations.of(
                                            context,
                                          )!.signup_screen_onbehalf,
                                      style: Styles.bold_app_accent_12,
                                      child: DropdownButtonFormField<dynamic>(
                                        isExpanded: true,
                                        initialValue:
                                            state
                                                .signUpState!
                                                .on_behalves_value,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: MyTheme.gull_grey,
                                        ),
                                        decoration:
                                            InputStyle.inputDecoration_text_field()
                                                .copyWith(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                ),
                                        items:
                                            state.signUpState!.onBehalfList!.map<
                                              DropdownMenuItem<dynamic>
                                            >((e) {
                                              return DropdownMenuItem<dynamic>(
                                                value: e.id,
                                                child: Text(
                                                  e.name!,
                                                  style:
                                                      Styles.regular_arsenic_14,
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (dynamic newValue) {
                                          store.dispatch(
                                            SignupSetOnBehalvesAction(
                                              payload: newValue,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Const.height18,
                                    GroupItemWithChild(
                                      title:
                                          AppLocalizations.of(
                                            context,
                                          )!.signup_screen_first_name,
                                      style: Styles.bold_app_accent_12,
                                      child: TextFormField(
                                        controller:
                                            store
                                                .state
                                                .signUpState
                                                ?.firstNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter First Name';
                                          }
                                          return null;
                                        },
                                        decoration:
                                            InputStyle.inputDecoration_text_field(
                                              hint: "John",
                                            ),
                                      ),
                                    ),
                                    Const.height18,
                                    GroupItemWithChild(
                                      title:
                                          AppLocalizations.of(
                                            context,
                                          )!.signup_screen_last_name,
                                      style: Styles.bold_app_accent_12,
                                      child: TextFormField(
                                        controller:
                                            store
                                                .state
                                                .signUpState
                                                ?.lastNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Last Name';
                                          }
                                          return null;
                                        },
                                        decoration:
                                            InputStyle.inputDecoration_text_field(
                                              hint: "Doe",
                                            ),
                                      ),
                                    ),
                                    Const.height18,
                                    GroupItemWithChild(
                                      title:
                                          AppLocalizations.of(
                                            context,
                                          )!.signup_screen_gender,
                                      style: Styles.bold_app_accent_12,
                                      child: DropdownButtonFormField<dynamic>(
                                        isExpanded: true,
                                        initialValue:
                                            state.signUpState!.currentGender,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: MyTheme.gull_grey,
                                        ),
                                        validator: (dynamic val) {
                                          if (val == null || val.isEmpty)
                                            return "Required field";
                                          return null;
                                        },
                                        decoration:
                                            InputStyle.inputDecoration_text_field()
                                                .copyWith(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                ),
                                        items:
                                            state.signUpState!.genderItems!.map<
                                              DropdownMenuItem<dynamic>
                                            >((e) {
                                              return DropdownMenuItem<dynamic>(
                                                value: e,
                                                child: Text(
                                                  e,
                                                  style:
                                                      Styles.regular_arsenic_14,
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (dynamic newValue) {
                                          store.dispatch(
                                            SignupSetGenderAction(
                                              payload: newValue,
                                            ),
                                          );

                                          String? selectedGender =
                                              newValue as String?;
                                          if (selectedGender != null &&
                                              selectedGender.isNotEmpty) {
                                            String minAgeString = '0';
                                            if (selectedGender == 'Male') {
                                              minAgeString =
                                                  state
                                                      .systemSettingState
                                                      ?.settingResponse
                                                      ?.data?['male_min_age'] ??
                                                  '0';
                                            } else if (selectedGender ==
                                                'Female') {
                                              minAgeString =
                                                  state
                                                      .systemSettingState
                                                      ?.settingResponse
                                                      ?.data?['female_min_age'] ??
                                                  '0';
                                            }
                                            final int minimumAge =
                                                int.tryParse(minAgeString) ?? 0;

                                            final DateTime lastSelectableDate =
                                                DateTime(
                                                  DateTime.now().year -
                                                      minimumAge,
                                                  DateTime.now().month,
                                                  DateTime.now().day,
                                                );
                                            store.dispatch(
                                              SignupSetDateTimeAction(
                                                payload: lastSelectableDate,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Const.height18,
                                    GroupItemWithChild(
                                      title:
                                          AppLocalizations.of(
                                            context,
                                          )!.signup_screen_dob,
                                      style: Styles.bold_app_accent_12,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: MyTheme.solitude,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          String? selectedGender =
                                              state.signUpState!.currentGender;

                                          if (selectedGender == null ||
                                              selectedGender.isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Please select a gender first.',
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          String minAgeString = '0';
                                          if (selectedGender == 'Male') {
                                            minAgeString =
                                                state
                                                    .systemSettingState
                                                    ?.settingResponse
                                                    ?.data?['male_min_age'] ??
                                                '0';
                                          } else if (selectedGender ==
                                              'Female') {
                                            minAgeString =
                                                state
                                                    .systemSettingState
                                                    ?.settingResponse
                                                    ?.data?['female_min_age'] ??
                                                '0';
                                          }

                                          final int minimumAge =
                                              int.tryParse(minAgeString) ?? 0;

                                          final DateTime lastSelectableDate =
                                              DateTime(
                                                DateTime.now().year -
                                                    minimumAge,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                              );

                                          DateTime initialDate =
                                              state.signUpState!.date ??
                                              lastSelectableDate;

                                          if (initialDate.isAfter(
                                            lastSelectableDate,
                                          )) {
                                            initialDate = lastSelectableDate;
                                          }

                                          DateTime? newDate =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: initialDate,
                                                firstDate: DateTime(1900),
                                                lastDate: lastSelectableDate,
                                              );

                                          if (newDate == null) return;
                                          store.dispatch(
                                            SignupSetDateTimeAction(
                                              payload: newDate,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          height: 35,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Center(
                                                child: Text(
                                                  state.signUpState!.date !=
                                                          null
                                                      ? DateFormat(
                                                        'd MMMM yyyy',
                                                      ).format(
                                                        state
                                                            .signUpState!
                                                            .date!,
                                                      )
                                                      : 'Select Date',
                                                  style:
                                                      Styles.regular_arsenic_14,
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: MyTheme.gull_grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Const.height18,
                                    _buildEmailOrOtpSection(state),
                                    Const.height18,
                                    GroupItemWithChild(
                                      title:
                                          AppLocalizations.of(
                                            context,
                                          )!.common_password_text,
                                      style: Styles.bold_app_accent_12,
                                      child: TextFormField(
                                        controller:
                                            store
                                                .state
                                                .signUpState
                                                ?.passwordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter password';
                                          }
                                          if (value.length <= 7) {
                                            return "Password should be 8 Characters long";
                                          }
                                          return null;
                                        },
                                        obscureText: _isObscure,
                                        decoration:
                                            InputStyle.inputDecoratio_password(
                                              hint: ". . . . . . .",
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: DeviceInfo(context).width,
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.common_screen_8_or_more_char,
                                        style: Styles.regular_gull_grey_10,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Const.height15,
                                    GroupItemWithChild(
                                      title:
                                          AppLocalizations.of(
                                            context,
                                          )!.common_screen_confim_password,
                                      style: Styles.bold_app_accent_12,
                                      child: TextFormField(
                                        controller:
                                            store
                                                .state
                                                .signUpState
                                                ?.confirmPasswordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Confirm Password';
                                          }
                                          if (store
                                                  .state
                                                  .signUpState
                                                  ?.passwordController!
                                                  .text
                                                  .toString() !=
                                              store
                                                  .state
                                                  .signUpState
                                                  ?.confirmPasswordController!
                                                  .text
                                                  .toString()) {
                                            return "Password don't match";
                                          }
                                          return null;
                                        },
                                        obscureText: _isObscure,
                                        decoration:
                                            InputStyle.inputDecoratio_password(
                                              hint: ". . . . . . .",
                                            ),
                                      ),
                                    ),
                                    Const.height18,
                                    if (isReferralSystem!)
                                      GroupItemWithChild(
                                        title:
                                            AppLocalizations.of(
                                              context,
                                            )!.signup_screen_refer_code,
                                        style: Styles.bold_app_accent_12,
                                        child: TextFormField(
                                          controller:
                                              store
                                                  .state
                                                  .signUpState
                                                  ?.referController,
                                          decoration:
                                              InputStyle.inputDecoration_text_field(
                                                hint: "Type your refer code",
                                              ),
                                        ),
                                      ),
                                    Const.height18,
                                    GroupItemWithChild(
                                      title: "",
                                      child: SizedBox(
                                        width: DeviceInfo(context).width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Checkbox(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        6.0,
                                                      ),
                                                ),
                                                value:
                                                    state.signUpState!.checkBox,
                                                activeColor:
                                                    MyTheme.app_accent_color,
                                                onChanged: (bool? value) {
                                                  store.dispatch(
                                                    SignupCheckBoxAction(
                                                      payload: value,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width:
                                                  DeviceInfo(context).width! /
                                                  2,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.signup_screen_terms_part1,
                                                      style:
                                                          Styles
                                                              .regular_app_accent_12,
                                                    ),
                                                    TextSpan(
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              NavigatorPush.push(
                                                                context,
                                                                CommonPrivacyAndTerms(
                                                                  title:
                                                                      "Term Conditions Page",
                                                                  content:
                                                                      state
                                                                          .staticPageState!
                                                                          .termsAndCondition,
                                                                ),
                                                              );
                                                            },
                                                      text:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.signup_screen_terms_part2,
                                                      style:
                                                          Styles
                                                              .bold_app_accent_12,
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.signup_screen_terms_part3,
                                                      style:
                                                          Styles
                                                              .regular_app_accent_12,
                                                    ),
                                                    TextSpan(
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              NavigatorPush.push(
                                                                context,
                                                                CommonPrivacyAndTerms(
                                                                  title:
                                                                      "Privacy Policy Page",
                                                                  content:
                                                                      state
                                                                          .staticPageState!
                                                                          .privacyPolicy,
                                                                ),
                                                              );
                                                            },
                                                      text:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.signup_screen_terms_part4,
                                                      style:
                                                          Styles
                                                              .bold_app_accent_12,
                                                    ),
                                                  ],
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Const.height40,
                                    InkWell(
                                      onTap: () {
                                        final bool regVerification =
                                            settingIsActive(
                                              'registration_verification',
                                              '1',
                                            );

                                        if (regVerification && !_isVerified) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  isOtpSystem!
                                                      ? const Text(
                                                        'Please verify your email or phone first.',
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                      : const Text(
                                                        'Please verify your email first.',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                            ),
                                          );
                                          return;
                                        }

                                        store.dispatch(
                                          SignUpRequestAction(
                                            payloadContext: context,
                                            phoneNumber: _selectedPhoneNumber,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        width: DeviceInfo(context).width,
                                        decoration: BoxDecoration(
                                          gradient: Styles.buildLinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child:
                                            state.signUpState!.isLoading ==
                                                    false
                                                ? Center(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.signup_screen_button_text_signup,
                                                    style: Styles.bold_white_14,
                                                  ),
                                                )
                                                : CommonWidget
                                                    .circularIndicator,
                                      ),
                                    ),
                                    Const.height40,
                                    buildSocialLogin(context),
                                    Const.height20,
                                    ContactAndFaq(
                                      title: "Frequently Asked Questions (FAQ)",
                                      content: state.staticPageState!.faq,
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isRecaptchaActive)
                    Positioned(
                      bottom: 10,
                      right: 15,
                      width: 280,
                      height: 90,
                      child: WebViewWidget(controller: _controller),
                    ),
                ],
              ),
            ),
      ),
    );
  }

  void _sendVerificationCode(AppState state) async {
    final bool isPhone =
        isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);
    final String sendBy = isPhone ? "phone" : "email";

    if (isPhone) {
      if ((_selectedPhoneNumber.phoneNumber ?? '').isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your phone number')),
        );
        return;
      }
    } else {
      if (state.signUpState!.emailController!.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email')),
        );
        return;
      }
    }

    setState(() {
      _isSendingCode = true;
    });

    try {
      var response =
          isPhone
              ? await AuthRepository().sendCode(
                phoneNumber: _selectedPhoneNumber,
                sendBy: sendBy,
              )
              : await AuthRepository().sendCode(
                identifier: state.signUpState!.emailController!.text,
                sendBy: sendBy,
              );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message!),
            backgroundColor: response.status == 1 ? Colors.green : Colors.red,
          ),
        );
        if (response.status == 1) {
          setState(() {
            _isCodeSent = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  void _verifyOtpCode(AppState state) async {
    if (_isVerified || _isVerifyingCode) return;

    final bool isPhone =
        isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);
    final String sendBy = isPhone ? "phone" : "email";
    final String code = _otpController.text;

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP code.')),
      );
      return;
    }

    setState(() {
      _isVerifyingCode = true;
    });

    try {
      var response =
          isPhone
              ? await AuthRepository().verifyCode(
                phoneNumber: _selectedPhoneNumber,
                sendBy: sendBy,
                code: code,
              )
              : await AuthRepository().verifyCode(
                identifier: state.signUpState!.emailController!.text,
                sendBy: sendBy,
                code: code,
              );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message!),
            backgroundColor: (response.status == 1) ? Colors.green : Colors.red,
          ),
        );
      }

      if (response.status == 1) {
        if (mounted) {
          setState(() {
            _isVerified = true;
            _verificationFailed = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isVerified = false;
            _verificationFailed = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerified = false;
          _verificationFailed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifyingCode = false;
        });
      }
    }
  }

  // **MODIFICATION**: Removed the "Verify" button from the suffix logic.
  Widget _buildOtpSuffix(AppState state) {
    if (_isVerifyingCode) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            color: MyTheme.app_accent_color,
            strokeWidth: 2,
          ),
        ),
      );
    }
    if (_isVerified) {
      return Icon(Icons.check_circle, color: MyTheme.success);
    }
    if (_verificationFailed) {
      return Icon(Icons.cancel, color: MyTheme.failure);
    }
    // Return an empty widget when there's no active state.
    return const SizedBox.shrink();
  }

  Widget _buildEmailOrOtpSection(AppState state) {
    final bool regVerification = settingIsActive(
      'registration_verification',
      '1',
    );
    final bool isPhone =
        isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);

    Widget inputSection;
    Widget? toggleLink;

    if (isOtpSystem!) {
      toggleLink = Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: InkWell(
          onTap: () {
            store.dispatch(SignupSetEmailOrPhoneAction());
          },
          child: SizedBox(
            width: DeviceInfo(context).width,
            child: Text(
              isPhone
                  ? AppLocalizations.of(context)!.common_screen_use_email
                  : AppLocalizations.of(context)!.common_screen_use_phone,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 10,
                color: MyTheme.app_accent_color,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      );
    }

    if (!regVerification) {
      inputSection = GroupItemWithChild(
        title: isPhone ? "Phone" : "Email",
        style: Styles.bold_app_accent_12,
        child:
            isPhone
                ? InternationalPhoneNumberInput(
                  initialValue: _selectedPhoneNumber,
                  onInputChanged: (PhoneNumber number) {
                    setState(() {
                      _selectedPhoneNumber = number;
                    });
                  },
                  spaceBetweenSelectorAndTextField: 0,
                  countries: store.state.commonState!.countriesToString(),
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  inputDecoration: InputStyle.inputDecoration_text_field(
                    hint: "01XXX XXX XXX",
                  ),
                )
                : TextFormField(
                  controller: store.state.signUpState?.emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email address';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  decoration: InputStyle.inputDecoration_text_field(
                    hint: "johndoe@example.com",
                  ),
                ),
      );
    } else {
      if (!_isCodeSent) {
        inputSection = GroupItemWithChild(
          title: isPhone ? "Phone" : "Email",
          style: Styles.bold_app_accent_12,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              isPhone
                  ? InternationalPhoneNumberInput(
                    initialValue: _selectedPhoneNumber,
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        _selectedPhoneNumber = number;
                      });
                    },
                    spaceBetweenSelectorAndTextField: 0,
                    countries: store.state.commonState!.countriesToString(),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                    ),
                    inputDecoration: InputStyle.inputDecoration_text_field(
                      hint: "01XXX XXX XXX",
                    ),
                  )
                  : TextFormField(
                    controller: state.signUpState!.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    decoration: InputStyle.inputDecoration_text_field(
                      hint: "johndoe@example.com",
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 90,
                  height: 40,
                  child: TextButton(
                    onPressed:
                        _isSendingCode
                            ? null
                            : () => _sendVerificationCode(state),
                    style: TextButton.styleFrom(
                      backgroundColor: MyTheme.app_accent_color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child:
                        _isSendingCode
                            ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text("Verify", style: Styles.bold_white_12),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        toggleLink = null;
        inputSection = GroupItemWithChild(
          title: "Verification Code",
          style: Styles.bold_app_accent_12,
          child: TextFormField(
            controller: _otpController,
            onChanged: (value) {
              if (value.length == 6 && !_isVerifyingCode) {
                _verifyOtpCode(state);
              }
            },
            readOnly: _isVerified,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter Verification Code",
              hintStyle: Styles.regular_gull_grey_12,
              filled: true,
              fillColor: MyTheme.solitude,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: MyTheme.app_accent_color,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: _buildOtpSuffix(state),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter OTP';
              }
              return null;
            },
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [inputSection, if (toggleLink != null) toggleLink],
    );
  }

  Widget buildSocialLogin(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.signup_screen_already_account,
              style: Styles.regular_gull_grey_12,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                ' ${AppLocalizations.of(context)!.signup_screen_login}',
                style: Styles.bold_app_accent_12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const SocialLoginWidget(),
      ],
    );
  }

  Container buildGradeintLogo(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Styles.buildLinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 78),
          const ImageIcon(
            AssetImage('assets/logo/app_logo.png'),
            size: 93,
            color: MyTheme.white,
          ),
          Text(
            AppLocalizations.of(context)!.signup_screen_title,
            style: Styles.bold_white_22,
          ),
          Text(
            AppLocalizations.of(context)!.signup_screen_subtitle,
            style: Styles.regular_white_14,
          ),
        ],
      ),
    );
  }
}
