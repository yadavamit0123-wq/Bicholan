import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/member_info/member_info.dart';
import 'package:active_matrimonial_flutter_app/repository/shortlist_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/shortlist_action.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../../const/my_theme.dart';
import '../../../redux/libs/helpers/show_message_state.dart';
import '../../home_pages/home/home_action.dart';

// ThunkAction<AppState> addShortlistMiddleware({required int userId}) {
//   return (Store<AppState> store) async {
//     store.dispatch(LoadAction());
//     try {
//       var data = await ShortlistRepository().add_to_shortList(userId: userId);
//       store.dispatch(LoadAction());
//
//       if (data.result) {
//         store.dispatch(
//             ShowMessageAction(msg: data.message, color: MyTheme.success));
//         store.dispatch(memberInfoMiddleware(userId: userId));
//       } else {
//         store.dispatch(
//             ShowMessageAction(msg: data.message, color: MyTheme.failure));
//       }
//     } catch (e) {
//       //debugPrint(e);
//       return;
//     }
//   };
// }

// add_shortlist_middleware.dart আপডেট করুন
ThunkAction<AppState> addShortlistMiddleware({required int userId}) {
  return (Store<AppState> store) async {
    try {
    //  var response = await ShortlistRepository().addShortlist(userId: userId);
      var response = await ShortlistRepository().add_to_shortList(userId: userId);

      if (response.result == true) {
        store.dispatch(ShowMessageAction(
          msg: response.message ?? "Added to shortlist",
          color: MyTheme.success,
        ));
      } else {
        store.dispatch(ShowMessageAction(
          msg: response.message ?? "Failed to add to shortlist",
          color: MyTheme.failure,
        ));
      }
    } catch (e) {
      store.dispatch(ShowMessageAction(
        msg: "Error: $e",
        color: MyTheme.failure,
      ));
    } finally {
      store.dispatch(SetShortlistLoadingAction(
          userId: userId,
          isLoading: false
      ));
    }
  };
}