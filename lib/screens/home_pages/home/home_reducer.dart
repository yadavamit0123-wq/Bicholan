import 'package:active_matrimonial_flutter_app/main.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/helpers/show_message_state.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home/home_action.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home/home_state.dart';
import 'package:active_matrimonial_flutter_app/screens/ignore/add_ignore_middleware.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

HomeState _homeFetching(HomeState state, HomeFetchingAction action) {
  state.isFetching = true;
  return state;
}

HomeState _homeStore(HomeState state, HomeStoreAction action) {
  state.isFetching = false;
  state.homeDataList = action.payload!.data;
  return state;
}

HomeState _homeFailure(HomeState state, HomeFailureAction action) {
  state.isFetching = false;
  state.error = action.error;
  return state;
}

HomeState _addToIgnore(HomeState state, AddToIgnoreListFromHome action) {
  store.dispatch(addIgnoreMiddleware(userId: action.user.userId!));
  state.homeDataList!.remove(action.user);
  return state;
}

HomeState _setCurrentIndex(HomeState state, SetCurrentIndex action) {
  state.currentIndex = action.payload;
  return state;
}

HomeState _goNextPage(HomeState state, GoNextPage action) {
  if (state.homeDataList != null &&
      state.currentIndex! < state.homeDataList!.length - 1) {
    state.controller!.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
  return state;
}

HomeState _goPrevPage(HomeState state, GoPrevPage action) {
  if (state.currentIndex! > 0) {
    state.controller!.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
  return state;
}

HomeState _setInterestLoading(
  HomeState state,
  SetInterestLoadingAction action,
) {
  state.interestLoadingStates[action.userId] = action.isLoading;
  return state;
}

HomeState _setShortlistLoading(
  HomeState state,
  SetShortlistLoadingAction action,
) {
  state.shortlistLoadingStates[action.userId] = action.isLoading;
  return state;
}

HomeState _setIgnoreLoading(HomeState state, SetIgnoreLoadingAction action) {
  state.ignoreLoadingStates[action.userId] = action.isLoading;
  return state;
}

HomeState _updateInterestStatus(
  HomeState state,
  UpdateInterestStatusAction action,
) {
  if (state.homeDataList != null) {
    for (var member in state.homeDataList!) {
      if (member.userId == action.userId) {
        member.interestStatus = action.interestStatus;
        break;
      }
    }
  }
  return state;
}

final homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, HomeFetchingAction>(_homeFetching),
  TypedReducer<HomeState, HomeStoreAction>(_homeStore),
  TypedReducer<HomeState, HomeFailureAction>(_homeFailure),
  TypedReducer<HomeState, AddToIgnoreListFromHome>(_addToIgnore),
  TypedReducer<HomeState, SetCurrentIndex>(_setCurrentIndex),
  TypedReducer<HomeState, GoNextPage>(_goNextPage),
  TypedReducer<HomeState, GoPrevPage>(_goPrevPage),

  TypedReducer<HomeState, SetInterestLoadingAction>(_setInterestLoading),
  TypedReducer<HomeState, SetShortlistLoadingAction>(_setShortlistLoading),
  TypedReducer<HomeState, SetIgnoreLoadingAction>(_setIgnoreLoading),
  TypedReducer<HomeState, UpdateInterestStatusAction>(_updateInterestStatus),
]);
