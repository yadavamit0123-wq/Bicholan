import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/repository/interest_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import '../../home_pages/home/home_action.dart';

ThunkAction<AppState> expressInterestMiddleware({required int userId}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInterestLoadingAction(userId: userId, isLoading: true));

    try {
      var response = await InterestRepository().express_interest(
        userId: userId,
      );

      if (response.result == true) {
        store.dispatch(
          UpdateInterestStatusAction(userId: userId, interestStatus: "1"),
        );

        store.dispatch(
          ShowMessageAction(
            msg: response.message ?? "Interest sent successfully",
            color: MyTheme.success,
          ),
        );
      } else {
        store.dispatch(
          ShowMessageAction(
            msg: response.message ?? "Failed to send interest",
            color: MyTheme.failure,
          ),
        );
      }
    } catch (e) {
      store.dispatch(
        ShowMessageAction(msg: "Error: $e", color: MyTheme.failure),
      );
    } finally {
      store.dispatch(
        SetInterestLoadingAction(userId: userId, isLoading: false),
      );
    }
  };
}
