import 'dart:io';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/const/const.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/auth_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import '../../../components/common_widget.dart';
import '../../../components/container_with_icon.dart';
import '../../../components/custom_popup.dart';
import '../../../components/deactivate_Massage.dart';
import '../../../components/my_circular_indicator.dart';
import '../../../components/my_images.dart';
import '../../../helpers/aiz_route.dart';
import '../../../helpers/main_helpers.dart';
import '../../../helpers/shared_pref.dart';
import '../../../l10n/app_localizations.dart';
import '../../../redux/libs/report/report_middleware.dart';
import '../../account/account_middleware.dart';
import '../../auth/verify/verify_action.dart';
import '../../my_dashboard_pages/interest/express_interest_middleware.dart';
import '../../my_dashboard_pages/shortlist/add_shortlist_middleware.dart';
import '../../notifications/notifications.dart';
import '../../package/premium_plans.dart';
import '../../search_screens/search.dart';
import 'home_action.dart';
import 'home_middleware.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  onRefresh() {
    store.dispatch(accountMiddleware());
    store.dispatch(homeMiddleware());
  }

  void handleRestrictedNavigation(VoidCallback onActive) {
    bool isDeactivated = store.state.authState?.userData?.deactivated == 1;
    bool isVerified = store.state.userVerifyState?.isApprove ?? false;

    var profile = store.state.accountState?.profileData;
    var package = profile?.currentPackageInfo;
    bool hasActivePkg = package?.packageId != null;

    if (isDeactivated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your account is deactivated. Please reactivate it to use this feature',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please verify your account.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (!hasActivePkg) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please purchase a package",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PremiumPlans()),
      );

      return;
    }

    onActive();
  }

  @override
  void initState() {
    super.initState();
    store.dispatch(authMiddleware());
    store.dispatch(accountMiddleware());
    store.dispatch(getUserIsApproveAction());
    store.dispatch(homeMiddleware());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? screenHeight = DeviceInfo(context).height;
    double? screenWidth = DeviceInfo(context).width;

    return StoreConnector<AppState, HomeViewModel>(
      converter: (store) => HomeViewModel.fromStore(store),
      builder:
          (_, HomeViewModel vm) => WillPopScope(
            onWillPop: () async {
              final shouldPop =
                  (await OneContext().showDialog<bool>(
                    builder: (BuildContext context) {
                      return exit_alert_dialog(context);
                    },
                  ))!;
              return shouldPop;
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: buildAppBar(context, screenHeight, screenWidth),
              body: SafeArea(
                child:
                    vm.isAccountDataLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: MyTheme.app_accent_color,
                          ),
                        )
                        : vm.isDeactivated
                        ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth! * 0.07,
                            ),
                            child: const DeactivatedAccountMessage(),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: () {
                            onRefresh();
                            return Future.delayed(const Duration(seconds: 1));
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Container(
                              height:
                                  DeviceInfo(context).height! -
                                  (AppBar().preferredSize.height + 100),
                              padding: EdgeInsets.only(
                                left: Const.kPaddingHorizontal,
                                right: Const.kPaddingHorizontal,
                                bottom: Const.kPaddingHorizontal,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (vm.activeMembers == null ||
                                      vm.activeMembers!.isEmpty)
                                    CircularProgressIndicator(
                                      color: MyTheme.app_accent_color,
                                    )
                                  else
                                    vm.isFetch == false
                                        ? view_card(vm, context, screenWidth)
                                        : Expanded(
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: MyTheme.storm_grey,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
              ),
            ),
          ),
    );
  }

  Widget view_card(HomeViewModel vm, BuildContext context, double? width) {
    return Expanded(
      child:
          vm.activeMembers!.isNotEmpty
              ? PageView.builder(
                controller: vm.controller,
                itemCount: vm.activeMembers!.length,
                itemBuilder: (listViewContext, index) {
                  var members = vm.activeMembers!;
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MyImage.imageProvider(members[index].photo),
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.4, 1],
                            colors: [Colors.transparent, Colors.black],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: DeviceInfo(context).width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildNameAndId(members, index, vm, width),
                                buildAgeAndFullProfileRow(
                                  members,
                                  index,
                                  vm,
                                  context,
                                ),
                                Const.height10,
                                buildPageNavigatorWithSubscribeLoveFollow(
                                  context,
                                  index,
                                  members[index],
                                  vm,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                onPageChanged: (index) {
                  store.dispatch(SetCurrentIndex(payload: index));
                  SharedPref().showDialog = false;
                },
              )
              : CommonWidget.noData,
    );
  }

  Widget buildAgeAndFullProfileRow(
    List<dynamic> members,
    int index,
    HomeViewModel vm,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ImageIcon(
                  AssetImage('assets/icon/icon_person.png'),
                  size: 12,
                  color: MyTheme.white,
                ),
                Const.width5,
                Text(
                  '${members[index].age} yrs, ${members[index].height} ft',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                const ImageIcon(
                  AssetImage('assets/icon/icon_location.png'),
                  size: 12,
                  color: MyTheme.white,
                ),
                Const.width5,
                Text(
                  '${members[index].country}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            handleRestrictedNavigation(() {
              AIZRoute.push(
                context,
                UserPublicProfile(userId: members[index].userId),
                middleware: ProfileViewMiddleware(
                  context: context,
                  user: store.state.authState?.userData,
                ),
              );
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              Colors.white.withValues(alpha: 0.1),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            ),
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.white),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.home_screen_full_profile,
            style: Styles.bold_white_12,
          ),
        ),
      ],
    );
  }

  Widget buildNameAndId(
    List<dynamic> members,
    int index,
    HomeViewModel vm,
    double? width,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(
                  '${members[index].name}',
                  style:
                      (width ?? 0) > 350
                          ? Styles.bold_white_16
                          : Styles.bold_white_14,
                ),
                Const.height7,
                if (members[index].membership == 2)
                  ImageIcon(
                    const AssetImage('assets/icon/icon_premium.png'),
                    size: 18,
                    color: MyTheme.icon_premium_color,
                  ),
              ],
            ),
            Const.height7,
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.common_screen_member_id,
                  style: const TextStyle(color: MyTheme.white),
                ),
                Text(
                  members[index].code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerRight,
          child: PopupMenuButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            child: const SizedBox(
              width: 16,
              child: Icon(Icons.more_vert, color: Colors.white),
            ),
            onSelected: (dynamic value) {
              if (value.toString().toLowerCase() == 'report') {
                handleRestrictedNavigation(() {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return buildAlertDialog(
                        context,
                        vm.activeMembers![index],
                        vm,
                      );
                    },
                  );
                });
              }
            },
            itemBuilder: (context) {
              return ['Report']
                  .map(
                    (e) => PopupMenuItem(
                      height: 30,
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                  .toList();
            },
          ),
        ),
      ],
    );
  }

  Widget exit_alert_dialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.exit,
        style: Styles.bold_arsenic_14,
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () {
            Platform.isAndroid ? SystemNavigator.pop() : exit(0);
          },
          child: Text('Yes', style: Styles.regular_arsenic_14),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('No', style: Styles.regular_arsenic_14),
        ),
      ],
    );
  }

  Widget buildAlertDialog(BuildContext context, user, HomeViewModel vm) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.flag_outlined,
                    color: MyTheme.failure ?? Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.common_report_member,
                    style: Styles.bold_arsenic_16?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: MyTheme.solitude ?? Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reporting: ${user.name ?? user.userId}',
                      style: Styles.regular_arsenic_12?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              AppLocalizations.of(context)!.common_report_reason,
              style: Styles.bold_arsenic_14?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: MyTheme.solitude ?? Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: TextField(
                maxLines: 5,
                controller: vm.reportController,
                style: Styles.regular_arsenic_14,
                decoration: InputDecoration(
                  hintText: 'Please describe your reason...',
                  hintStyle: Styles.regular_arsenic_12?.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.common_cancel,
                      style: Styles.regular_arsenic_14?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      vm.userReport!(
                        user: user.userId,
                        reason: vm.reportController!.text,
                      );
                      Navigator.of(context).pop();
                      vm.reportController!.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.failure ?? Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.common_report,
                      style: Styles.bold_white_14?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, double? height, double? width) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: Const.kPaddingHorizontal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo/appbar_logo.png',
                  fit: BoxFit.contain,
                  height: (width ?? 0) > 350 ? 36 : 30,
                  width: (width ?? 0) > 350 ? 46 : 40,
                ),
                const SizedBox(width: 8.3),
                buildAppName(width),
              ],
            ),
            Row(
              children: [
                CommonWidget.social_button(
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: "icon_bell.png",
                  onpressed: () {
                    handleRestrictedNavigation(() {
                      SharedPref().isLoggedIn
                          ? NavigatorPush.push(context, const Notifications())
                          : CustomPopUp(context).loginDialog(context);
                    });
                  },
                ),
                const SizedBox(width: 8.0),
                CommonWidget.social_button(
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: "icon_search.png",
                  onpressed: () {
                    handleRestrictedNavigation(() {
                      SharedPref().isLoggedIn
                          ? showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const SizedBox(
                                height: 1000,
                                child: Search(),
                              );
                            },
                          )
                          : CustomPopUp(context).loginDialog(context);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppName(sw) {
    return Text(
      AppConfig.app_name,
      style:
          (sw ?? 0) > 350
              ? Styles.bold_app_accent_16
              : Styles.bold_app_accent_16.copyWith(fontSize: 12),
    );
  }

  Widget buildPageNavigatorWithSubscribeLoveFollow(
    BuildContext context,
    int index,
    dynamic user,
    HomeViewModel vm,
  ) {
    int userId = user.userId;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ContainerWithIcon(
          onpressed: () => vm.goToPrev!(),
          icon: 'icon_left.png',
          width: 40,
          height: 40,
          radius: 20,
          opacity: 0.1,
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Ignore Button
            vm.isIgnoreLoading(userId)
                ? MyCircularIndicator(
                  width: 40,
                  height: 40,
                  radius: 20,
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                )
                : ContainerWithIcon(
                  onpressed: () {
                    handleRestrictedNavigation(() {
                      store.dispatch(
                        SetIgnoreLoadingAction(userId: userId, isLoading: true),
                      );
                      vm.ignoreUser!(user: user);
                    });
                  },
                  icon: 'icon_ignore.png',
                  width: 40,
                  height: 40,
                  radius: 20,
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

            SizedBox(width: DeviceInfo(context).width! * 0.05),

            // Love (Express Interest) Button
            vm.packageExpire != "Expired"
                ? vm.isInterestLoading(userId)
                    ? MyCircularIndicator(
                      width: 40,
                      height: 40,
                      radius: 20,
                      gradient: Styles.buildLinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    )
                    : ContainerWithIcon(
                      onpressed: () {
                        handleRestrictedNavigation(() {
                          (vm.isFullProfileView! &&
                                  (vm.myMembershipType == 'Free'))
                              ? store.dispatch(
                                ShowMessageAction(
                                  msg: "Please update your package.",
                                ),
                              )
                              : vm.expressInterest(userId: user.userId);
                        });
                      },
                      icon:
                          user.interestStatus == "received interest" ||
                                  user.interestStatus == "1"
                              ? 'icon_love_full.png'
                              : 'icon_love.png',
                      width: 40,
                      height: 40,
                      radius: 20,
                      isChecked:
                          user.interestStatus == '1' ||
                          user.interestStatus == "received interest",
                      gradient: Styles.buildLinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    )
                : ContainerWithIcon(
                  onpressed: () {
                    handleRestrictedNavigation(() {
                      store.dispatch(
                        ShowMessageAction(msg: "Please update your package."),
                      );
                    });
                  },
                  icon: 'icon_love.png',
                  width: 40,
                  height: 40,
                  radius: 20,
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

            SizedBox(width: DeviceInfo(context).width! * 0.05),

            vm.isShortlistLoading(userId)
                ? MyCircularIndicator(
                  width: 40,
                  height: 40,
                  radius: 20,
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                )
                : ContainerWithIcon(
                  onpressed: () {
                    handleRestrictedNavigation(() {
                      store.dispatch(
                        SetShortlistLoadingAction(
                          userId: userId,
                          isLoading: true,
                        ),
                      );
                      vm.addShortlist!(user: user.userId);
                    });
                  },
                  icon: 'icon_subscribe.png',
                  width: 40,
                  height: 40,
                  radius: 20,
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
          ],
        ),

        ContainerWithIcon(
          onpressed: () => vm.goToNext!(),
          icon: 'icon_right.png',
          width: 40,
          height: 40,
          radius: 20,
          opacity: 0.1,
          color: Colors.white,
        ),
      ],
    );
  }
}

class HomeViewModel {
  final bool? isFullProfileView;
  final List? activeMembers;
  final bool? isFetch;
  final String? packageExpire;

  final String? myMembershipType;
  final bool isDeactivated;
  final bool isAccountDataLoading;
  final PageController? controller;
  final TextEditingController? reportController;

  final bool Function(int userId) isInterestLoading;
  final bool Function(int userId) isShortlistLoading;
  final bool Function(int userId) isIgnoreLoading;

  final void Function({dynamic user, dynamic reason})? userReport;
  final void Function({dynamic user})? addShortlist;
  final void Function({required int userId}) expressInterest;
  final void Function({dynamic user})? ignoreUser;
  final void Function()? goToNext;
  final void Function()? goToPrev;

  HomeViewModel({
    this.packageExpire,
    this.isFetch,
    this.activeMembers,
    this.isFullProfileView,

    this.userReport,
    this.addShortlist,
    required this.expressInterest,
    this.ignoreUser,
    this.myMembershipType,
    required this.isDeactivated,
    required this.isAccountDataLoading,
    this.controller,
    this.reportController,
    required this.isInterestLoading,
    required this.isShortlistLoading,
    required this.isIgnoreLoading,
    this.goToNext,
    this.goToPrev,
  });

  static fromStore(Store<AppState> store) {
    bool isLoading = store.state.accountState?.profileData == null;

    return HomeViewModel(
      isAccountDataLoading: isLoading,
      isDeactivated: store.state.authState?.userData?.deactivated == 1,
      isFullProfileView: settingIsActive(
        "full_profile_show_according_to_membership",
        "1",
      ),
      activeMembers: store.state.homeState!.homeDataList,
      isFetch: store.state.homeState!.isFetching,
      packageExpire:
          store
              .state
              .accountState!
              .profileData
              ?.currentPackageInfo
              ?.packageExpiry,

      isInterestLoading: (int userId) {
        return store.state.homeState?.interestLoadingStates[userId] ?? false;
      },
      isShortlistLoading: (int userId) {
        return store.state.homeState?.shortlistLoadingStates[userId] ?? false;
      },
      isIgnoreLoading: (int userId) {
        return store.state.homeState?.ignoreLoadingStates[userId] ?? false;
      },

      myMembershipType: store.state.packageDetailsState!.data?.name,
      controller: store.state.homeState!.controller,
      reportController: store.state.homeState!.reportController,

      userReport:
          ({dynamic user, dynamic reason}) =>
              store.dispatch(reportMiddleware(userId: user, reason: reason)),

      addShortlist: ({dynamic user}) {
        store.dispatch(
          SetShortlistLoadingAction(userId: user, isLoading: true),
        );
        store.dispatch(addShortlistMiddleware(userId: user));
      },

      expressInterest: ({required int userId}) {
        store.dispatch(
          SetInterestLoadingAction(userId: userId, isLoading: true),
        );
        store.dispatch(expressInterestMiddleware(userId: userId));
      },

      ignoreUser: ({dynamic user}) {
        store.dispatch(
          SetIgnoreLoadingAction(userId: user.userId, isLoading: true),
        );
        store.dispatch(AddToIgnoreListFromHome(user: user));
      },

      goToNext: () => store.dispatch(GoNextPage()),
      goToPrev: () => store.dispatch(GoPrevPage()),
    );
  }
}
