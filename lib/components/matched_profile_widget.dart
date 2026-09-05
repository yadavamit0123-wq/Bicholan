
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import '../const/const.dart';
import '../const/my_theme.dart';
import '../const/style.dart';
import '../redux/app/app_state.dart';
import '../screens/user_pages/user_public_profile.dart';
import 'common_widget.dart';
import 'my_smooth_indicator.dart';

class MatchedProfileWidget extends StatelessWidget {
  MatchedProfileWidget({
    super.key,
    required this.matched_profile_controller,
    required this.state,
  });

  final PageController matched_profile_controller;
  AppState state;

  @override
  Widget build(BuildContext context) {
    final isDeactivated = state.authState?.userData?.deactivated == 1;
    void showDeactivatedMessage() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Your account is deactivated. Please reactivate it to use this feature.',
            textAlign: TextAlign.center,),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Const.kPaddingHorizontal,
        vertical: Const.kPaddingVertical,
      ),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
          ),
        ),
        child: state.matchedProfileState!.isFetching!
            ? CommonWidget.circularIndicator
            : Padding(
          padding: const EdgeInsets.only(
            left: 14.0,
            bottom: 10,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.chat_list_matched_profile,
                style: Styles.bold_white_12,
              ),
              Const.height10,
              SizedBox(
                height: 72,
                child: state
                    .matchedProfileState!.matchedProfiles!.isNotEmpty
                    ? PageView.builder(
                  controller: matched_profile_controller,
                  itemCount: state
                      .matchedProfileState!.matchedProfiles!.length,
                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    var user = state
                        .matchedProfileState!.matchedProfiles![index];
                    return GestureDetector(
                      onTap: () {
                        if (isDeactivated) {
                          showDeactivatedMessage();
                        } else {
                          AIZRoute.push(
                            context,
                            UserPublicProfile(
                              userId: user.userId!,
                            ),
                            middleware: ProfileViewMiddleware(
                              context: context,
                              user: state.authState?.userData,
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  user.photo ?? "",
                                ),
                              ),
                            ),
                          ),
                          Const.width15,
                          SizedBox(
                            height: 60,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  user.name ?? "",
                                  style: Styles.bold_white_14,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user.age} yrs, ${user.height} feet, ${user.maritalStatus ?? ""},',
                                      style:
                                      Styles.regular_white_12,
                                    ),
                                    Text(
                                      '${user.religion}, ${user.caste}',
                                      style:
                                      Styles.regular_white_12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.common_no_data,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: MySmoothIndicator.worm_effect(
                  controller: matched_profile_controller,
                  length:
                  state.matchedProfileState!.matchedProfiles!.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}