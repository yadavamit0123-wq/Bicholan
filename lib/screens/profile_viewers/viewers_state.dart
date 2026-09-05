// redux/state.dart

import '../../models_response/profile/profile_viewers_respons.dart';

enum LoadingState { idle, loading, success, failure }

class ProfileViewersState {
  final List<Viewer> viewers;
  final Links? links;
  final Meta? meta;
  final bool result;
  final LoadingState loadingState;
  final String? error;

  ProfileViewersState({
    required this.viewers,
    this.links,
    this.meta,
    required this.result,
    required this.loadingState,
    this.error,
  });

  factory ProfileViewersState.initial() => ProfileViewersState(
    viewers: [],
    links: null,
    meta: null,
    result: false,
    loadingState: LoadingState.idle,
    error: null,
  );

  ProfileViewersState copyWith({
    List<Viewer>? viewers,
    Links? links,
    Meta? meta,
    bool? result,
    LoadingState? loadingState,
    String? error,
  }) {
    return ProfileViewersState(
      viewers: viewers ?? this.viewers,
      links: links ?? this.links,
      meta: meta ?? this.meta,
      result: result ?? this.result,
      loadingState: loadingState ?? this.loadingState,
      error: error,
    );
  }
}
