import 'dart:convert';

import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';

MatchedProfileResponse matchedProfileResponseFromJson(String str) =>
    MatchedProfileResponse.fromJson(json.decode(str));

String matchedProfileResponseToJson(MatchedProfileResponse data) =>
    json.encode(data.toJson());

class MatchedProfileResponse {
  MatchedProfileResponse({this.data});

  List<MemberData>? data;

  factory MatchedProfileResponse.fromJson(Map<String, dynamic> json) {
    if (json["data"] != null) {
      json["data"].removeWhere((element) {
        return element == null;
      });
    }
    return MatchedProfileResponse(
      data:
          json["data"] == null
              ? []
              : List<MemberData>.from(
                json["data"].map((x) => MemberData.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
