import 'package:active_matrimonial_flutter_app/redux/libs/matched_profile/matched_profile_action.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/matched_profile/matched_profile_state.dart';

MatchedProfileState? matched_profile_state(
  MatchedProfileState? state,
  dynamic action,
) {
  if (action is MatchedProfileStoreAction) {
    state!.isFetching = false;
    state.matchedProfiles = action.payload!.data;
    return state;
  }
  if (action is MatchedProfileFailureAction) {
    state!.error = action.error;
    return state;
  }

  return state;
}


///Horoscope Profile Match
/// Horoscope Profile Match Reducer
HoroscopMatchProfileState? horoscop_match_profile_state(
    HoroscopMatchProfileState? state,
    dynamic action,
    ) {
  if (action is HoroscopMatchProfileStoreAction) {
    // ডাটা নাল হলে যেন খালি লিস্ট সেভ হয়
    state!.horoscopMatchedProfiles = action.payload!.data ?? [];
    state.isFeatching = false;
    return state;
  }

  if (action is HoroscopMatchProfileFailureAction) {
    state!.error = action.error;
    state.isFeatching = false; // লোডিং বন্ধ করুন
    return state;
  }

  return state;
}