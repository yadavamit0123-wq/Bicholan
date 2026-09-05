// To parse this JSON data, do
//
//     final astronomicGetResponse = astronomicGetResponseFromJson(jsonString);

import 'dart:convert';

AstronomicGetResponse astronomicGetResponseFromJson(String str) =>
    AstronomicGetResponse.fromJson(json.decode(str));

String astronomicGetResponseToJson(AstronomicGetResponse data) =>
    json.encode(data.toJson());

class AstronomicGetResponse {
  AstronomicGetResponse({this.data, this.result});

  Data? data;
  bool? result;

  factory AstronomicGetResponse.fromJson(Map<String, dynamic> json) =>
      AstronomicGetResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};

  AstronomicGetResponse.initialState()
    : data = Data.initialState(),
      result = false;
}

class Data {
  Data({
    this.sunSign,
    this.moonSign,
    this.timeOfBirth,
    this.cityOfBirth,
    this.nakshatra,
    this.gana,
    this.nadi,
    this.manglik,
  });

  String? sunSign;
  String? moonSign;
  var timeOfBirth;
  var cityOfBirth;
  String? nakshatra;
  String? gana;
  String? nadi;
  String? manglik;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sunSign: json["sun_sign"],
    moonSign: json["moon_sign"],
    timeOfBirth: json["time_of_birth"],
    cityOfBirth: json["city_of_birth"],
    nakshatra: json["nakshatra"]?.toString(),
    gana: json["gana"]?.toString(),
    nadi: json["nadi"]?.toString(),
    manglik: json["manglik"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "sun_sign": sunSign,
    "moon_sign": moonSign,
    "time_of_birth": timeOfBirth,
    "city_of_birth": cityOfBirth,
    "nakshatra": nakshatra,
    "gana": gana,
    "nadi": nadi,
    "manglik": manglik,
  };

  Data.initialState()
    : sunSign = '',
      moonSign = '',
      timeOfBirth = '',
      cityOfBirth = '',
      nakshatra = null,
      gana = null,
      nadi = null,
      manglik = null;
}
