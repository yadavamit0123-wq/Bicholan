import 'dart:io';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profile_reducer/astronomic_reducer.dart';
import 'package:active_matrimonial_flutter_app/repository/drop_down_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:path_provider/path_provider.dart';

ThunkAction<AppState> astronomicDropdownMiddleware() {
  return (Store<AppState> store) async {
    try {
      var data = await DropDownRepository().fetchAstronomicDropDown();
      store.dispatch(AstronomicDropdownSetAction(data));
    } catch (e, s) {
      debugPrint("error astronomic dropdown middleware ${e.toString()}");
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/dropdown_error.txt');
        await file.writeAsString('Error: $e\nStacktrace:\n$s');
      } catch (_) {}
      return;
    }
  };
}
