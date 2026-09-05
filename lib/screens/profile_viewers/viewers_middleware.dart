// viewers_middleware.dart
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../../repository/profile_viewers_repository.dart';
import '../../redux/app/app_state.dart';
import 'viewers_action.dart';

// <-- important: use AppState here
ThunkAction<AppState> fetchViewersThunk(ProfileViewersRepository repository, {int page = 1, bool append = false}) {
  return (Store<AppState> store) async {
    // debug print to confirm thunk runs
    print('fetchViewersThunk called: page=$page append=$append');

    // dispatch request action
    store.dispatch(FetchViewersRequest(append: append, page: page));

    try {
      final resp = await repository.fetchProfileViewers(page: page);
      print('fetchViewersThunk: got ${resp.data.length} viewers');

      store.dispatch(FetchViewersSuccess(
        viewers: resp.data,
        links: resp.links,
        meta: resp.meta,
        result: resp.result,
        append: append,
      ));
    } catch (e, st) {
      print('fetchViewersThunk error: $e\n$st');
      store.dispatch(FetchViewersFailure(e.toString()));
    }
  };
}
