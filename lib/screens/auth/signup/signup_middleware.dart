
import 'package:active_matrimonial_flutter_app/components/make_alert.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/helpers/auth_helper.dart';
import 'package:active_matrimonial_flutter_app/helpers/localization.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/helpers/show_message_state.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../package/premium_plans.dart';

ThunkAction<AppState> signupMiddleware(
    BuildContext context, {
      firstName,
      lastName,
      emailOrPhone,
      emailOrPhoneText,
      onBehalf,
      gender,
      dateOfBirth,
      password,
      passwordConfirmation,
      referral,
      recapthca,
    }) {
  return (Store<AppState> store) async {
    store.dispatch(SignUpAction());
    var g = int.parse(gender);

    try {
      var data = await AuthRepository().postSignUp(
        firstName: firstName,
        lastName: lastName,
        emailOrPhone: emailOrPhone,
        emailOrPhoneText: emailOrPhoneText,
        onBehalf: onBehalf,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: passwordConfirmation,
        referral: referral,
        gender: g,
        recapthca: recapthca,
      );
      store.dispatch(SignUpAction());
      store.dispatch(SignupReset());
      if (data.result == true) {
        setUserData(data);
        store.dispatch(
            ShowMessageAction(msg: data.message, color: MyTheme.success));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PremiumPlans()),
        );
      } else if (data.message.runtimeType == String && data.user == null) {
        MakeAlert.show(LangText(context: context).getLocal().info, data.message,
            AlertType.warning);
      } else if (data.message.runtimeType == List) {
        MakeAlert.show(
            LangText(context: context).getLocal().something_went_wrong,
            data.message.first,
            AlertType.failed);
      }
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  };
}
