import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:active_matrimonial_flutter_app/models_response/home_response.dart';

class HomeFetchingAction {}

class HomeStoreAction {
  HomeResponse? payload;

  HomeStoreAction({this.payload});

  @override
  String toString() {
    return 'HomeStoreAction{payload: $payload}';
  }
}

class HomeFailureAction {
  String? error;

  HomeFailureAction({this.error});

  @override
  String toString() {
    return 'HomeFailureAction{error: $error}';
  }
}

class AddToIgnoreListFromHome {
  var context;
  MemberData user;

  @override
  String toString() {
    return 'AddToIgnoreListFromHome{context: $context, user: $user}';
  }

  AddToIgnoreListFromHome({required this.user, this.context});
}

class SetCurrentIndex {
  int? payload;

  SetCurrentIndex({this.payload});

  @override
  String toString() {
    return 'SetCurrentIndex{payload: $payload}';
  }
}

class GoNextPage {
  @override
  String toString() {
    return 'GoNextPage{}';
  }
}

class GoPrevPage {
  @override
  String toString() {
    return 'GoPrevPage{}';
  }
}

class SetInterestLoadingAction {
  int userId;
  bool isLoading;

  SetInterestLoadingAction({required this.userId, required this.isLoading});

  @override
  String toString() {
    return 'SetInterestLoadingAction{userId: $userId, isLoading: $isLoading}';
  }
}

class SetShortlistLoadingAction {
  int userId;
  bool isLoading;

  SetShortlistLoadingAction({required this.userId, required this.isLoading});

  @override
  String toString() {
    return 'SetShortlistLoadingAction{userId: $userId, isLoading: $isLoading}';
  }
}

class SetIgnoreLoadingAction {
  int userId;
  bool isLoading;

  SetIgnoreLoadingAction({required this.userId, required this.isLoading});

  @override
  String toString() {
    return 'SetIgnoreLoadingAction{userId: $userId, isLoading: $isLoading}';
  }
}

class UpdateInterestStatusAction {
  int userId;
  String interestStatus;

  UpdateInterestStatusAction({
    required this.userId,
    required this.interestStatus,
  });

  @override
  String toString() {
    return 'UpdateInterestStatusAction{userId: $userId, interestStatus: $interestStatus}';
  }
}
