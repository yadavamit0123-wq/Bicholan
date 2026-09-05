import 'package:active_matrimonial_flutter_app/models_response/drop_down/astronomic_dropdown_response.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/astronomic_get_response.dart';
import 'package:flutter/material.dart';

class AstronomicState {
  bool? isloading;
  bool? pageloader;
  final AstronomicGetResponse? astronomicGetResponse;
  AstronomicDropdownResponse? astronomicDropdownResponse;

  // Selected dropdown values
  dynamic sunSignValue;
  dynamic moonSignValue;
  dynamic nakshatraValue;
  dynamic ganaValue;
  dynamic nadiValue;
  dynamic manglikValue;

  // Text controller for city of birth
  TextEditingController cityOfBirthController = TextEditingController();

  AstronomicState({
    this.isloading,
    this.pageloader,
    this.astronomicGetResponse,
    this.astronomicDropdownResponse,
    this.sunSignValue,
    this.moonSignValue,
    this.nakshatraValue,
    this.ganaValue,
    this.nadiValue,
    this.manglikValue,
  });

  AstronomicState.initialState()
    : astronomicGetResponse = AstronomicGetResponse.initialState(),
      astronomicDropdownResponse = AstronomicDropdownResponse.initialState(),
      isloading = false,
      pageloader = false,
      sunSignValue = null,
      moonSignValue = null,
      nakshatraValue = null,
      ganaValue = null,
      nadiValue = null,
      manglikValue = null;
}
