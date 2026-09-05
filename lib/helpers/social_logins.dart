
import 'package:active_matrimonial_flutter_app/redux/libs/auth/social_login_middleware.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class SocialLogins {
onPressedGoogleLogin(BuildContext context) async {
    // 1. Create an instance of GoogleSignIn
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // 2. Start the sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // 3. Handle if the user cancelled the sign-in
      if (googleUser == null) {
        print("Google Sign-In was cancelled by the user.");
        return; // Exit the function if sign-in was cancelled
      }

      // 4. Get the authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      // Ensure you have an access token before proceeding
      if (accessToken == null) {
        print("Failed to retrieve Google access token.");
        return;
      }
      
      // 5. Dispatch your Redux action
      store.dispatch(
        socialLoginMiddleware(
          context: context,
          social_provider: "google",
          email: googleUser.email,
          name: googleUser.displayName,
          provider: googleUser.id,
          access_token: accessToken,
        ),
      );

    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  // Your onPressedFacebookLogin method remains the same
  onPressedFacebookLogin(BuildContext context) async {
    // ... your existing code
  }
}