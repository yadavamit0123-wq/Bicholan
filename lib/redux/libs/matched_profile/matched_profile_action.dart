import '../../../models_response/matched_profile_response.dart';

class MatchedProfileStoreAction {
  MatchedProfileResponse? payload;

  MatchedProfileStoreAction({this.payload});

  @override
  String toString() {
    return 'MatchedProfileStoreAction{data: $payload}';
  }
}

class MatchedProfileFailureAction {
  String? error;

  MatchedProfileFailureAction({this.error});

  @override
  String toString() {
    return 'MatchedProfileFailureAction{error: $error}';
  }
}

/// horoscop matching
class HoroscopMatchProfileStoreAction {
  MatchedProfileResponse? payload;

  HoroscopMatchProfileStoreAction({this.payload});

  @override
  String toString() {
    return "HoroscopMatchProfileStoreAction{data: $payload}";
  }
}

class HoroscopMatchProfileFailureAction {
  String? error;

  HoroscopMatchProfileFailureAction({this.error});
  @override
  String toString() {
    return 'HoroscopMatchProfileFailureAction{error: $error}';
  }
}
