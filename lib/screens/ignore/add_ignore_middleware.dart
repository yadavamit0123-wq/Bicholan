import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/helpers/show_message_state.dart';
import 'package:active_matrimonial_flutter_app/repository/ignore_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/ignore/ignore_action.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../home_pages/home/home_action.dart';

// add_ignore_middleware.dart আপডেট করুন
ThunkAction<AppState> addIgnoreMiddleware({required int userId}) {
  return (Store<AppState> store) async {
    try {
      var response = await IgnoreRepository().addToIgnore(userId: userId);

      if (response.result == true) {
        store.dispatch(ShowMessageAction(
          msg: response.message ?? "User ignored",
          color: MyTheme.success,
        ));
      } else {
        store.dispatch(ShowMessageAction(
          msg: response.message ?? "Failed to ignore user",
          color: MyTheme.failure,
        ));
      }
    } catch (e) {
      store.dispatch(ShowMessageAction(
        msg: "Error: $e",
        color: MyTheme.failure,
      ));
    } finally {
      store.dispatch(SetIgnoreLoadingAction(
          userId: userId,
          isLoading: false
      ));
    }
  };
}