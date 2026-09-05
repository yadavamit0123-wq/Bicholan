import 'dart:convert';

class DDown {
  DDown({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory DDown.fromJson(Map<String, dynamic> json) => DDown(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  String getIds(List<DDown> data) {
    List<int> tmp = [];

    for (var element in data) {
      tmp.add(element.id!);
    }
    return tmp.toString();
  }

  DDown.initialState()
      : id = 0,
        name = '';
}


// To parse this JSON data, do
// final astronomicDropdownResponse = astronomicDropdownResponseFromJson(jsonString);



AstronomicDropdownResponse astronomicDropdownResponseFromJson(String str) => AstronomicDropdownResponse.fromJson(json.decode(str));

class AstronomicDropdownResponse {
  bool? result;
  AstronomicDropdownData? data;

  AstronomicDropdownResponse({
    this.result,
    this.data,
  });

  factory AstronomicDropdownResponse.fromJson(Map<String, dynamic> json) => AstronomicDropdownResponse(
    result: json["result"],
    // API te root json er vitorei sob data ache, tai direct json tai pass koresi
    data: AstronomicDropdownData.fromJson(json),
  );
}

class AstronomicDropdownData {
  List<AstronomicSignModel>? sunSigns;
  List<AstronomicSignModel>? moonSigns;
  List<String>? nakshatras;
  List<String>? gana;
  List<String>? nadi;
  List<String>? manglik;

  AstronomicDropdownData({
    this.sunSigns,
    this.moonSigns,
    this.nakshatras,
    this.gana,
    this.nadi,
    this.manglik,
  });

  factory AstronomicDropdownData.fromJson(Map<String, dynamic> json) => AstronomicDropdownData(
    sunSigns: json["sun_signs"] == null ? [] : List<AstronomicSignModel>.from(json["sun_signs"].map((x) => AstronomicSignModel.fromJson(x))),
    moonSigns: json["moon_signs"] == null ? [] : List<AstronomicSignModel>.from(json["moon_signs"].map((x) => AstronomicSignModel.fromJson(x))),
    nakshatras: json["nakshatras"] == null ? [] : List<String>.from(json["nakshatras"].map((x) => x.toString())),
    gana: json["gana"] == null ? [] : List<String>.from(json["gana"].map((x) => x.toString())),
    nadi: json["nadi"] == null ? [] : List<String>.from(json["nadi"].map((x) => x.toString())),
    manglik: json["manglik"] == null ? [] : List<String>.from(json["manglik"].map((x) => x.toString())),
  );
}

// Notun model jeta apnar existing DDown ke distrub korbe na
class AstronomicSignModel {
  String? value;
  String? label;

  AstronomicSignModel({
    this.value,
    this.label,
  });

  factory AstronomicSignModel.fromJson(Map<String, dynamic> json) => AstronomicSignModel(
    value: json["value"]?.toString(),
    label: json["label"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}