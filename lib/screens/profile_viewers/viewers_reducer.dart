// redux/reducer.dart
import 'package:active_matrimonial_flutter_app/screens/profile_viewers/viewers_action.dart';
import 'package:active_matrimonial_flutter_app/screens/profile_viewers/viewers_state.dart';
import 'package:redux/redux.dart';

final profileViewersReducer = combineReducers<ProfileViewersState>([
  TypedReducer<ProfileViewersState, FetchViewersRequest>(_onFetchRequest),
  TypedReducer<ProfileViewersState, FetchViewersSuccess>(_onFetchSuccess),
  TypedReducer<ProfileViewersState, FetchViewersFailure>(_onFetchFailure),
  TypedReducer<ProfileViewersState, ClearViewersAction>(_onClear),
]);

ProfileViewersState _onFetchRequest(ProfileViewersState state, FetchViewersRequest action) {
  return state.copyWith(
    loadingState: state.loadingState == LoadingState.loading ? LoadingState.loading : LoadingState.loading,
    error: null,
  );
}

ProfileViewersState _onFetchSuccess(ProfileViewersState state, FetchViewersSuccess action) {
  final newList = action.append ? [...state.viewers, ...action.viewers] : action.viewers;
  return state.copyWith(
    viewers: newList,
    links: action.links,
    meta: action.meta,
    result: action.result,
    loadingState: LoadingState.success,
    error: null,
  );
}

ProfileViewersState _onFetchFailure(ProfileViewersState state, FetchViewersFailure action) {
  return state.copyWith(
    loadingState: LoadingState.failure,
    error: action.error,
  );
}

ProfileViewersState _onClear(ProfileViewersState state, ClearViewersAction action) {
  return ProfileViewersState.initial();
}
