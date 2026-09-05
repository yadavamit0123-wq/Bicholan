import 'package:active_matrimonial_flutter_app/components/btn_padding_zero.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/components/my_text_button.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/action_helper.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/grid_items.dart';
import 'package:active_matrimonial_flutter_app/helpers/lang_text.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/auth_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/deactivate_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/feature/feature_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/matched_profile/matched_profile_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/account/account_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_page.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/happy_story/my_happy_stories/get_happy_story_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/manage_profiles/manage_profile.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/gallery/my_gallery.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_details.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_history.dart';
import 'package:active_matrimonial_flutter_app/screens/package/premium_plans.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../../components/common_privacy_and_terms_page.dart';
import '../../components/horoscop_profile_widget.dart';
import '../../components/matched_profile_widget.dart';
import '../../components/remaining_box.dart';
import '../../redux/libs/auth/acccount_delete_middleware.dart';
import '../../redux/libs/auth/signout_middleware.dart';
import '../../redux/libs/drop_down/profile_dropdown_middleware.dart';
import '../../redux/libs/staticPage/static_page.dart';
import '../auth/change_password/change_password.dart';
import '../auth/verify/verify_action.dart';
import '../contact_us/contact_us.dart';
import '../profile_viewers/profile_viewers_screen.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool? isSupport = store.state.addonState?.data?.supportTickets ?? false;
  bool? isReferral = store.state.addonState?.data?.referralSystem ?? false;
  var _menuList;

  fetchMenu() {
    var obj = GridItems();
    obj.addMenu();
    _menuList = obj.gridMenuItems;
  }

  final isDeactivated = store.state.authState?.userData?.deactivated == 1;
  void showDeactivatedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Your account is deactivated. Please reactivate it to use this feature.',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit:
          (store) => [
            fetchMenu(),
            store.dispatch(accountMiddleware()),
            store.dispatch(getUserIsApproveAction()),
            store.dispatch(happyStoryCheckMiddleware()),
            store.dispatch(fetchStaticPageAction()),
            store.dispatch(horoscopMatchedProfileFetchAction()),
            store.dispatch(matchedProfileFetchAction()),
            store.dispatch(profiledropdownMiddleware()),
          ],
      builder: (_, state) {
        bool isUserDeactivated = state.authState?.userData?.deactivated == 0;

        List<MyMenuItem> myMenuItems = [
          MyMenuItem('FAQ'),
          MyMenuItem('Logout'),
          MyMenuItem('Contact Us'),
          MyMenuItem('Delete account'),
          MyMenuItem('Change Password'),
          isUserDeactivated
              ? MyMenuItem('Deactivate Account')
              : MyMenuItem('Reactivate Account'),
        ];

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () {
              fetchMenu();
              store.dispatch(accountMiddleware());
              store.dispatch(getUserIsApproveAction());
              store.dispatch(authMiddleware());
              store.dispatch(featureCheckMiddleware());
              store.dispatch(matchedProfileFetchAction());

              return Future.delayed(const Duration(seconds: 2));
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildGradientBoxContainer(context, state, myMenuItems),
                  buildGridContainer(context, state),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Const.kPaddingHorizontal,
                      right: Const.kPaddingHorizontal,
                      bottom: 20,
                    ),
                    child: buildPackageDetails(context, state),
                  ),

                  InkWell(
                    onTap: () => protectedPush(context, ViewersPage()),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(color: MyTheme.app_accent_color),
                      ),
                      child: Center(
                        child: Text(
                          'Who Viewed My Profile',
                          style: TextStyle(color: MyTheme.app_accent_color),
                        ),
                      ),
                    ),
                  ),

                  if (!state.userVerifyState!.isApprove!)
                    Padding(
                      padding: EdgeInsets.only(
                        left: Const.kPaddingHorizontal,
                        right: Const.kPaddingHorizontal,
                        bottom: 20,
                      ),
                      child: buildVerify(context, state),
                    ),
                  if ((state.matchedProfileState?.matchedProfiles as List)
                      .isNotEmpty)
                    MatchedProfileWidget(
                      matched_profile_controller:
                          state.accountState!.matched_profile_controller,
                      state: state,
                    ),

                  if ((state
                              .horoscopeMatchedProfileState
                              ?.horoscopMatchedProfiles
                          as List)
                      .isNotEmpty)
                    HoroscopeMatchedProfileWidget(
                      horoscope_controller:
                          state.accountState!.horoscop_profile_controller,
                      state: state,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGradientBoxContainer(
    BuildContext mainContext,
    AppState state,
    List<MyMenuItem> menuItems,
  ) {
    final isDeactivated = state.authState?.userData?.deactivated == 1;
    void showDeactivatedMessage() {
      ScaffoldMessenger.of(mainContext).showSnackBar(
        const SnackBar(
          content: Text(
            'Your account is deactivated. Please reactivate it to use this feature.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }

    return Container(
      width: DeviceInfo(mainContext).width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: const Alignment(0.8, 1),
          colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: MyImages.normalImage(
                            state.accountState?.profileData?.memberPhoto,
                          ),
                        ),
                      ),
                      Const.width10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.state.authState?.userData?.name ?? "",
                            style: Styles.bold_white_14,
                          ),
                          Text(
                            store.state.authState?.userData?.email ?? "",
                            style: Styles.regular_white_12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 30.0,
                      maxWidth: 25.0,
                    ),
                    child: PopupMenuButton<MyMenuItem>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                      onSelected: (value) async {
                        final selectedAction =
                            value.title.toString().toLowerCase();
                        // These actions are allowed even when deactivated
                        final allowedActions = [
                          'logout',
                          'contact us',
                          'delete account',
                          'reactivate account',
                          'deactivate account',
                        ];
                        if (isDeactivated &&
                            !allowedActions.contains(selectedAction)) {
                          showDeactivatedMessage();
                          return;
                        }

                        switch (selectedAction) {
                          case 'contact us':
                            NavigatorPush.push(mainContext, const ContactUs());
                            break;
                          case 'faq':
                            NavigatorPush.push(
                              mainContext,
                              CommonPrivacyAndTerms(
                                title: "Frequently Asked Questions (FAQ)",
                                content: state.staticPageState!.faq,
                              ),
                            );
                            break;
                          case 'change password':
                            NavigatorPush.push(mainContext, ChangePassword());
                            break;
                          case 'reactivate account':
                            await _dialogBuilder(
                              mainContext,
                              state,
                              isDeactivating: false,
                            );
                            break;
                          case 'deactivate account':
                            await _dialogBuilder(
                              mainContext,
                              state,
                              isDeactivating: true,
                            );
                            break;
                          case 'delete account':
                            accountDeletion(state);
                            break;
                          case 'logout':
                            store.dispatch(signOutMiddleware(mainContext));
                            break;
                        }
                      },
                      itemBuilder:
                          (BuildContext context) =>
                              menuItems.map((MyMenuItem item) {
                                return PopupMenuItem<MyMenuItem>(
                                  value: item,
                                  child: Text(item.title),
                                );
                              }).toList(),
                    ),
                  ),
                ],
              ),
              Const.height15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextButton(
                    text: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        AppLocalizations.of(
                          mainContext,
                        )!.profile_screen_public_profile,
                        style: Styles.regularWhite(mainContext, 3),
                      ),
                    ),

                    onPressed:
                        () => protectedPush(
                          mainContext,
                          UserPublicProfile(
                            userId: store.state.authState!.userData!.id!,
                          ),
                        ),
                  ),
                  MyTextButton(
                    onPressed:
                        () => protectedPush(mainContext, const MyProfile()),
                    text: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        AppLocalizations.of(
                          mainContext,
                        )!.profile_screen_manage_profile,
                        style: Styles.regularWhite(mainContext, 3),
                      ),
                    ),
                  ),
                  MyTextButton(
                    onPressed:
                        () => protectedPush(mainContext, const MyGallery()),
                    text: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        AppLocalizations.of(
                          mainContext,
                        )!.profile_screen_gallery,
                        style: Styles.regularWhite(mainContext, 3),
                      ),
                    ),
                  ),
                ],
              ),
              Const.height15,
              Const.whiteDivider,
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  dragStartBehavior: DragStartBehavior.start,
                  children: [
                    const SizedBox(width: 22),
                    RemainingBox(
                      context: mainContext,
                      localization_text:
                          AppLocalizations.of(
                            mainContext,
                          )!.profile_screen_r_interest,
                      value: state.accountState!.profileData?.remainingInterest,
                    ),
                    RemainingBox(
                      context: mainContext,
                      localization_text:
                          AppLocalizations.of(
                            mainContext,
                          )!.profile_screen_r_contact_view,
                      value:
                          state.accountState!.profileData?.remainingContactView,
                    ),
                    RemainingBox(
                      context: mainContext,
                      localization_text:
                          AppLocalizations.of(
                            mainContext,
                          )!.profile_screen_r_gallery_image_upload,
                      value:
                          state
                              .accountState!
                              .profileData
                              ?.remainingPhotoGallery,
                    ),
                    if (state
                            .accountState!
                            .profileData
                            ?.remainingProfileImageView !=
                        "")
                      RemainingBox(
                        context: mainContext,
                        localization_text:
                            AppLocalizations.of(
                              mainContext,
                            )!.profile_screen_r_profile_image_view,
                        value:
                            state
                                .accountState!
                                .profileData
                                ?.remainingProfileImageView,
                      ),
                    if (state
                            .accountState!
                            .profileData
                            ?.remainingGalleryImageView !=
                        "")
                      RemainingBox(
                        context: mainContext,
                        localization_text:
                            AppLocalizations.of(
                              mainContext,
                            )!.profile_screen_r_gallery_image_view,
                        value:
                            state
                                .accountState!
                                .profileData
                                ?.remainingGalleryImageView,
                      ),
                  ],
                ),
              ),
              // Maintain consistent spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridContainer(BuildContext context, AppState state) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _menuList.length,
      controller: state.accountState!.gridScrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.only(left: 24.0, top: 20, right: 24),
      itemBuilder: (context, index) {
        return _menuList[index];
      },
    );
  }

  Widget buildVerify(BuildContext context, AppState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MyTheme.app_accent_color),
        color: MyTheme.app_accent_color.withOpacity(.09),
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          top: 15.0,
          right: 8.0,
          bottom: 15.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icon/verify.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        Text(LangText(context).local.not_verified),
                      ],
                    ),
                  ],
                ),
                MyTextButton(
                  onPressed: () {
                    NavigatorPush.push(context, VerifyPage());
                  },
                  text: Text(
                    LangText(context).local.verify_now,
                    style: Styles.bold_white_10,
                  ),
                  color: MyTheme.app_accent_color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPackageDetails(BuildContext context, AppState state) {
    void showDeactivatedMessage() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your account is deactivated. Please reactivate it to use this feature.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }

    final isDeactivated = state.authState?.userData?.deactivated == 1;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MyTheme.app_accent_color),
        color: MyTheme.solitude,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 15.0,
          right: 8.0,
          bottom: 15.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.profile_screen_package,
                          style: Styles.regular_arsenic_12,
                        ),
                        Text(
                          state
                                  .accountState
                                  ?.profileData
                                  ?.currentPackageInfo
                                  ?.packageName ??
                              "",
                          style: Styles.bold_storm_grey_12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.profile_screen_expire_on,
                          style: Styles.regular_arsenic_12,
                        ),
                        Text(
                          state
                                  .accountState
                                  ?.profileData
                                  ?.currentPackageInfo
                                  ?.packageExpiry ??
                              "",
                          style: Styles.bold_storm_grey_12,
                        ),
                      ],
                    ),
                  ],
                ),
                MyTextButton(
                  onPressed: () => NavigatorPush.push(context, PremiumPlans()),
                  text: Text(
                    AppLocalizations.of(context)!.profile_screen_upgrade,
                    style: Styles.bold_white_10,
                  ),
                  color: MyTheme.app_accent_color,
                ),
              ],
            ),
            Const.height5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonPaddingZero(
                  text: Text(
                    AppLocalizations.of(
                      context,
                    )!.profile_screen_package_details,
                    style: Styles.bold_app_accent_12,
                  ),
                  onPressed: () {
                    int? currentPkgId =
                        state
                            .accountState
                            ?.profileData
                            ?.currentPackageInfo
                            ?.packageId;
                    protectedPush(
                      context,
                      PackageDetails(packageId: currentPkgId),
                    );
                  },
                ),
                ButtonPaddingZero(
                  text: Text(
                    AppLocalizations.of(
                      context,
                    )!.profile_screen_package_history,
                    style: Styles.bold_app_accent_12,
                  ),
                  onPressed: () {
                    if (isDeactivated) {
                      showDeactivatedMessage();
                    } else {
                      NavigatorPush.push(context, PackageHistory());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  accountDeletion(AppState state) {
    return OneContext().showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LangText(context).local.delete_account,
            style: Styles.bold_arsenic_14,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color.fromRGBO(255, 221, 218, 1),
                ),
                child: Text(
                  LangText(context).local.common_cancel,
                  style: TextStyle(color: MyTheme.arsenic),
                ),
              ),
              onPressed: () {
                OneContext().popDialog();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color.fromRGBO(201, 227, 202, 1),
                ),
                child: Text(
                  LangText(context).local.common_confirm,
                  style: TextStyle(color: MyTheme.arsenic),
                ),
              ),
              onPressed: () {
                store.dispatch(accountDeletionMiddleware());
                OneContext().popDialog();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilder(
    BuildContext mainContext,
    AppState state, {
    required bool isDeactivating,
  }) async {
    await showDialog<void>(
      context: mainContext,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          content: SizedBox(
            height: 290,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  isDeactivating
                      ? AppLocalizations.of(context)!.deactivate
                      : AppLocalizations.of(context)!.reactivate,
                  textAlign: TextAlign.center,
                  style: Styles.bold_app_accent_20,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: Styles.buildLinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await store.dispatch(
                            deactivateMiddleware(
                              deactivate_status: isDeactivating ? 1 : 0,
                            ),
                          );
                          Navigator.of(context).pop();
                          store.dispatch(accountMiddleware());
                          store.dispatch(getUserIsApproveAction());
                          store.dispatch(authMiddleware());
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(90.0, 45.0),
                          ),
                          overlayColor: MaterialStateProperty.all(
                            MyTheme.app_accent_color,
                          ),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                              side: BorderSide(color: MyTheme.app_accent_color),
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.yes,
                          style: Styles.bold_arsenic_16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          const Size(90.0, 45.0),
                        ),
                        overlayColor: MaterialStateProperty.all(
                          MyTheme.app_accent_color,
                        ),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            side: BorderSide(color: MyTheme.app_accent_color),
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.no,
                        style: Styles.bold_arsenic_16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyMenuItem {
  final String title;

  MyMenuItem(this.title);
}
