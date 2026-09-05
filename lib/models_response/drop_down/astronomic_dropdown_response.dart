import 'dart:convert';
import 'package:active_matrimonial_flutter_app/models_response/common_models/ddown.dart';

AstronomicDropdownResponse astronomicDropdownResponseFromJson(String str) =>
    AstronomicDropdownResponse.fromJson(json.decode(str));

String astronomicDropdownResponseToJson(AstronomicDropdownResponse data) =>
    json.encode(data.toJson());

class AstronomicDropdownResponse {
  AstronomicDropdownResponse({this.result, this.data});

  bool? result;
  AstronomicDropdownData? data;

  factory AstronomicDropdownResponse.fromJson(Map<String, dynamic> json) =>
      AstronomicDropdownResponse(
        result: json["result"],
        // The API returns the fields directly at the root, so we pass 'json'
        data: AstronomicDropdownData.fromJson(json),
      );

  Map<String, dynamic> toJson() => {"result": result, "data": data?.toJson()};

  AstronomicDropdownResponse.initialState()
    : result = false,
      data = AstronomicDropdownData.init();
}

class AstronomicDropdownData {
  AstronomicDropdownData.init()
    : sunSigns = [],
      moonSigns = [],
      nakshatras = [],
      gana = [],
      nadi = [],
      manglik = [];

  AstronomicDropdownData({
    this.sunSigns,
    this.moonSigns,
    this.nakshatras,
    this.gana,
    this.nadi,
    this.manglik,
  });

  List<dynamic>? sunSigns;
  List<dynamic>? moonSigns;
  List<dynamic>? nakshatras;
  List<dynamic>? gana;
  List<dynamic>? nadi;
  List<dynamic>? manglik;

  static List<dynamic> _parseList(dynamic jsonList) {
    if (jsonList == null) return [];
    final list = jsonList as List<dynamic>;
    return list.map((x) {
      if (x is Map<String, dynamic>) {
        if (x.containsKey('value') || x.containsKey('label')) {
          return AstronomicSignModel.fromJson(x);
        }
        return DDown.fromJson(x);
      }
      return x;
    }).toList();
  }

  factory AstronomicDropdownData.fromJson(Map<String, dynamic> json) =>
      AstronomicDropdownData(
        sunSigns: _parseList(json["sun_signs"]),
        moonSigns: _parseList(json["moon_signs"]),
        nakshatras: _parseList(json["nakshatras"]),
        gana: _parseList(json["gana"]),
        nadi: _parseList(json["nadi"]),
        manglik: _parseList(json["manglik"]),
      );

  Map<String, dynamic> toJson() => {
    "sun_signs":
        sunSigns == null
            ? null
            : sunSigns!
                .map(
                  (x) =>
                      x is AstronomicSignModel
                          ? x.toJson()
                          : (x is DDown ? x.toJson() : x),
                )
                .toList(),
    "moon_signs":
        moonSigns == null
            ? null
            : moonSigns!
                .map(
                  (x) =>
                      x is AstronomicSignModel
                          ? x.toJson()
                          : (x is DDown ? x.toJson() : x),
                )
                .toList(),
    "nakshatras":
        nakshatras == null
            ? null
            : nakshatras!.map((x) => x is DDown ? x.toJson() : x).toList(),
    "gana":
        gana == null
            ? null
            : gana!.map((x) => x is DDown ? x.toJson() : x).toList(),
    "nadi":
        nadi == null
            ? null
            : nadi!.map((x) => x is DDown ? x.toJson() : x).toList(),
    "manglik":
        manglik == null
            ? null
            : manglik!.map((x) => x is DDown ? x.toJson() : x).toList(),
  };
}
