

import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/main.dart';
import 'package:active_matrimonial_flutter_app/screens/package/premium_plans.dart';


bool hasActivePackage() {
  var profile = store.state.accountState?.profileData;
  if (profile == null) return false;
  var package = profile.currentPackageInfo;
  if (package == null) return false;
  if (package.packageId == null) return false;
  return true;
}

void protectedPush(BuildContext context, Widget page) {
  bool isDeactivated = store.state.authState?.userData?.deactivated == 1;

  if (isDeactivated) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Your account is deactivated. Please reactivate it to use this feature.",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }
  bool isVerified = store.state.userVerifyState?.isApprove ?? false;

  if (!isVerified) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Please verify your account.",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );

    return;
  }

  var profile = store.state.accountState?.profileData;
  var package = profile?.currentPackageInfo;

  if (package?.packageId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please purchase a package", textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PremiumPlans()),
    );
    return;
  }
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}