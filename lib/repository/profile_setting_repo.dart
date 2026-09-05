import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';

import '../helpers/main_helpers.dart';

class ProfileSettingsRepository {
  Future<int> fetchHasPurchasedFreePackage() async {
    var accessToken = getToken;
    try {
      var url = Uri.parse("${AppConfig.BASE_URL}/member/profile-settings");

      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${accessToken}",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['result'] == true) {
          return data['member']['has_purchased_free_package'] ?? 0;
        }
      }
      return 0;
    } catch (e) {
      print("Error fetching profile settings: $e");
      return 0;
    }
  }
}
