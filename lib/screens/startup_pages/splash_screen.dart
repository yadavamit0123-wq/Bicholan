import 'dart:async';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/add_on/addon_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/app_info/app_info_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/auth_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/feature/feature_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:info_getter/info_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/shared_pref.dart';

late SharedPreferences prefs;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _appVersion = 'Loading version...';

  @override
  void initState() {
    super.initState();
    startTimer();

    store.dispatch(featureCheckMiddleware());
    store.dispatch(appInfoMiddleware());
    store.dispatch(addonCheckMiddleware());

    _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {

    final String? version = await InfoGetter.getAppVersion();

    if (mounted) {
      setState(() {
        _appVersion = version ?? 'Unknown';
      });
    }
  }

  startTimer() async {
    prefs = await SharedPreferences.getInstance();
    store.dispatch(authMiddleware());
    var duration = const Duration(seconds: 3);
    return Timer(duration, onBoardingPage);
  }

  onBoardingPage() {
    SharedPref().isView = true;
    NavigatorPush.push(context, const AppNavigation());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: DeviceInfo(context).width,
          height: DeviceInfo(context).height,
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Image.asset(
                  'assets/logo/splash_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 116,
                child: Column(
                  children: [
                    Text(
                      'v $_appVersion',
                      style: Styles.bold_arsenic_12,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      AppConfig.copyright_text,
                      style: Styles.regular_light_grey_12,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
