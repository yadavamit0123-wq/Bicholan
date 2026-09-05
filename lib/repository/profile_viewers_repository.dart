// repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../helpers/main_helpers.dart';
import '../models_response/profile/profile_viewers_respons.dart';

abstract class ProfileViewersRepository {
  Future<ProfileViewersResponse> fetchProfileViewers({int page = 1});
}

class ProfileViewersRepositoryImpl implements ProfileViewersRepository {
  final http.Client client;

  ProfileViewersRepositoryImpl({
    http.Client? client,
  }) : client = client ?? http.Client();

  @override
  Future<ProfileViewersResponse> fetchProfileViewers({int page = 1}) async {
    final uri = Uri.parse("${AppConfig.BASE_URL}/member/my-profile-viewers?page=$page");
    var accessToken = getToken;
    final response = await client.get(uri, headers: {
      'Accept': 'application/json',
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return ProfileViewersResponse.fromJson(jsonMap);
    } else {
      throw HttpException('Failed to load: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => 'HttpException: $message';
}
