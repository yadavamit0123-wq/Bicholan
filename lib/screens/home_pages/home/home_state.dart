import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:flutter/material.dart';

class HomeState {
  bool? isFetching;
  List<MemberData>? homeDataList;
  String? error;
  int? currentIndex;
  PageController? controller;
  TextEditingController? reportController;

  // loading
  Map<int, bool> interestLoadingStates = {};
  Map<int, bool> shortlistLoadingStates = {};
  Map<int, bool> ignoreLoadingStates = {};

  HomeState({
    this.error,
    this.isFetching,
    this.homeDataList,
    this.currentIndex,
    this.controller,
    this.reportController,
    Map<int, bool>? interestLoadingStates,
    Map<int, bool>? shortlistLoadingStates,
    Map<int, bool>? ignoreLoadingStates,
  }) {
    this.interestLoadingStates = interestLoadingStates ?? {};
    this.shortlistLoadingStates = shortlistLoadingStates ?? {};
    this.ignoreLoadingStates = ignoreLoadingStates ?? {};
  }

  factory HomeState.initial() {
    return HomeState(
      isFetching: false,
      error: '',
      currentIndex: 0,
      homeDataList: [],
      controller: PageController(initialPage: 0, viewportFraction: 1),
      reportController: TextEditingController(),
      interestLoadingStates: {},
      shortlistLoadingStates: {},
      ignoreLoadingStates: {},
    );
  }

  // helper
  bool isInterestLoading(int userId) => interestLoadingStates[userId] ?? false;
  bool isShortlistLoading(int userId) =>
      shortlistLoadingStates[userId] ?? false;
  bool isIgnoreLoading(int userId) => ignoreLoadingStates[userId] ?? false;
}
