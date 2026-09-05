
import 'package:active_matrimonial_flutter_app/redux/libs/helpers/show_message_state.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_state.dart';
import 'package:flutter/cupertino.dart';
import '../../../helpers/data_time_format.dart';
import '../../core.dart';
import 'signup_middleware.dart';

SignUpState sign_up_reducer(SignUpState state, dynamic action) {
  if (action is SignupReset) {
    return state.copyWith(
        firstNameController: "",
        lastNameController: "",
        emailController: "",
        passwordController: "",
        phoneNumber: "",
        confirmPasswordController: "",
        checkBox: false,
        isCodeSent: false,
        isVerified: false,
        isSendingCode: false,
        isVerifyingCode: false,
        verificationCodeController: TextEditingController(text: ""));
  }

  if (action is SignUpRequestAction) {
    if (state.checkBox == false) {
      store.dispatch(
        ShowMessageAction(
          msg: 'Agree to terms and condition!',
        ),
      );
      return state;
    }
    if (!state.signUpFormKey.currentState!.validate()) {
      return state;
    }

    if (state.currentGender == "Male") {
      state.genderController!.text = "1";
    } else {
      state.genderController!.text = "2";
    }

    bool isOtp = store.state.addonState!.data!.otpSystem ?? false;
    bool isPhone = isOtp && state.emailOrPhone!;

    var emailOrPhoneText = isPhone ? "phone" : "email";

    var emailOrPhoneValue =
    isPhone ? action.phoneNumber?.phoneNumber : state.emailController!.text;

    if (emailOrPhoneValue == null || emailOrPhoneValue.isEmpty) {
      store.dispatch(ShowMessageAction(msg: 'Email or Phone cannot be empty!'));
      return state;
    }

    store.dispatch(
      signupMiddleware(
        action.payloadContext,
        firstName: state.firstNameController!.text,
        lastName: state.lastNameController!.text,
        emailOrPhone: emailOrPhoneValue,
        emailOrPhoneText: emailOrPhoneText,
        onBehalf: state.on_behalves_value.toString(),
        gender: state.genderController!.text,
        dateOfBirth: yearMonthDay(state.date!),
        password: state.passwordController!.text,
        passwordConfirmation: state.confirmPasswordController!.text,
        referral: state.referController!.text,
        recapthca: state.googleRecaptchaKey,
      ),
    );

    return state;
  }

  if (action is SignUpAction) {
    return loader(state, action);
  }
  if (action is SignupSetDateTimeAction) {
    return state.copyWith(date: action.payload!);
  }
  if (action is SignupSetOnBehalvesAction) {
    return state.copyWith(on_behalves_value: action.payload);
  }
  if (action is SignupSetGenderAction) {
    return state.copyWith(currentGender: action.payload);
  }
  if (action is SignupCheckBoxAction) {
    return state.copyWith(checkBox: !state.checkBox!);
  }
  if (action is SignupSetEmailOrPhoneAction) {
    return state.copyWith(emailOrPhone: !state.emailOrPhone!);
  }
  if (action is SignupStoreOnBehalfAction) {
    return state.copyWith(
      onBehalfList: action.payload!.data,
      on_behalves_value: action.payload!.data?.first.id,
    );
  }
  if (action is SetKeyValueAction) {
    return state.copyWith(googleRecaptchaKey: action.keyValuePayload);
  }
  if (action is SetIsCaptchaShowingAction) {
    return state.copyWith(isCaptchaShowing: action.payload);
  }
  if (action is IsSendingCodeAction) {
    return state.copyWith(isSendingCode: !state.isSendingCode!);
  }
  if (action is IsVerifyingCodeAction) {
    return state.copyWith(isVerifyingCode: !state.isVerifyingCode!);
  }
  if (action is SetIsCodeSentAction) {
    return state.copyWith(isCodeSent: action.payload);
  }
  if (action is SetIsVerifiedAction) {
    return state.copyWith(isVerified: action.payload);
  }

  return state;
}

loader(SignUpState state, SignUpAction action) {
  return state.copyWith(isLoading: !state.isLoading!);
}