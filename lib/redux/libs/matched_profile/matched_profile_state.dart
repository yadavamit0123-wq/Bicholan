import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';

class MatchedProfileState {
  bool? isFetching;
  // Use your MemberData class here
  List<MemberData>? matchedProfiles = [];
  String? error;

  MatchedProfileState({this.isFetching, this.matchedProfiles, this.error});

  MatchedProfileState.initialState()
    : isFetching = true,
      matchedProfiles = [],
      error = '';

  MatchedProfileState copyWith({
    bool? isFetching,
    List<MemberData>? matchedProfiles, // Update the type here
    String? error,
  }) {
    return MatchedProfileState(
      isFetching: isFetching ?? this.isFetching,
      matchedProfiles: matchedProfiles ?? this.matchedProfiles,
      error: error ?? this.error,
    );
  }
}

///Horoscope Profile Match
class HoroscopMatchProfileState {
  bool? isFeatching;
  List<MemberData>? horoscopMatchedProfiles = [];
  String? error;

  HoroscopMatchProfileState({
    this.isFeatching,
    this.horoscopMatchedProfiles,
    this.error,
  });
  HoroscopMatchProfileState.initialState()
    : isFeatching = true,
      horoscopMatchedProfiles = [],
      error = '';

  HoroscopMatchProfileState copyWith({
    bool? isFeatching,
    List<MemberData>? horoscopMatchedProfiles,
    String? error,
  }) {
    return HoroscopMatchProfileState(
      isFeatching: isFeatching ?? this.isFeatching,
      horoscopMatchedProfiles:
          horoscopMatchedProfiles ?? this.horoscopMatchedProfiles,
      error: error ?? this.error,
    );
  }
}
