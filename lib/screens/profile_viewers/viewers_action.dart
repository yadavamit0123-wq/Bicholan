
// Action types

import '../../models_response/profile/profile_viewers_respons.dart';

class FetchViewersRequest {
  final bool append;
  final int page;
  FetchViewersRequest({this.append = false, this.page = 1});
}

class FetchViewersSuccess {
  final List<Viewer> viewers;
  final Links links;
  final Meta meta;
  final bool result;
  final bool append;

  FetchViewersSuccess({
    required this.viewers,
    required this.links,
    required this.meta,
    required this.result,
    this.append = false,
  });
}

class FetchViewersFailure {
  final String error;
  FetchViewersFailure(this.error);
}

class ClearViewersAction {}
