import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/repository/interest_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/my_interest_middleware.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../../../components/my_interest_card.dart';
import '../../../helpers/aiz_route.dart';
import '../../../middleware/profile_view_middleware.dart';
import '../../user_pages/user_public_profile.dart';
import '../interest_request/interest_requests.dart';

class MyInterest extends StatefulWidget {
  const MyInterest({super.key});

  @override
  State<MyInterest> createState() => _MyInterestState();
}

class _MyInterestState extends State<MyInterest> {
  ScrollController scrollController = ScrollController();

  Future<void> deleteInterest(int interestId, int index) async {
    try {
      await InterestRepository().reject_interest_requests(userId: interestId);

      setState(() {
        store.state.myInterestState!.myInterestList!.removeAt(index);
      });

      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interest deleted successfully'),
          backgroundColor: MyTheme.success,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("DELETE ERROR: $e");

      // Error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete interest'),
          backgroundColor: MyTheme.failure,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void showDeleteDialog(int interestId, int index, String userName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: MyTheme.app_accent_color,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text('Delete Interest', style: Styles.bold_arsenic_16),
            ],
          ),
          content: Text(
            'Are you sure you want to delete interest from "$userName"?',
            style: Styles.regular_arsenic_14,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: MyTheme.arsenic),
              child: Text('Cancel', style: Styles.bold_arsenic_14),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteInterest(interestId, index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text('Delete', style: Styles.bold_white_14),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (!store.state.userVerifyState!.isApprove!) {
      OneContext().pop();
      store.dispatch(
        ShowMessageAction(
          msg: "Please verify your account",
          color: MyTheme.failure,
        ),
      );
    } else {
      store.dispatch(Reset.myInterestList);
      store.dispatch(myInterestMiddleware());
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (store.state.myInterestState!.hasMore!) {
          store.dispatch(myInterestMiddleware());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) => Scaffold(
            appBar: CommonAppBar(
              text:
                  AppLocalizations.of(context)!.my_interest_screen_appbar_title,
            ).build(context),
            body: Column(
              children: [
                GestureDetector(
                  onTap:
                      () =>
                          NavigatorPush.push(context, const InterestRequest()),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: Const.kPaddingHorizontal,
                    ),
                    height: 45,
                    width: DeviceInfo(context).width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: const Alignment(0.8, 1),
                        colors: [
                          MyTheme.gradient_color_1,
                          MyTheme.gradient_color_2,
                        ],
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.my_interest_screen_request_interests,
                        style: Styles.bold_white_14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                state.myInterestState!.isFetching!
                    ? Expanded(child: CommonWidget.circularIndicator)
                    : buildListViewSeparated(context, state),
              ],
            ),
          ),
    );
  }

  Widget buildListViewSeparated(BuildContext maincontext, AppState state) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          store.dispatch(Reset.myInterestList);
          store.dispatch(myInterestMiddleware());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child:
              state.myInterestState!.myInterestList!.isNotEmpty
                  ? ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        state.myInterestState!.myInterestList!.length + 1,
                    separatorBuilder:
                        (BuildContext context, int index) =>
                            state.myInterestState!.myInterestList![index] ==
                                    null
                                ? Const.heightShrink
                                : Const.height15,
                    itemBuilder: (BuildContext context, int index) {
                      if (index ==
                          state.myInterestState!.myInterestList!.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child:
                              state.myInterestState!.hasMore!
                                  ? CommonWidget.circularIndicator
                                  : CommonWidget.noMoreData,
                        );
                      }
                      if (state.myInterestState!.myInterestList![index] ==
                          null) {
                        return Const.heightShrink;
                      }

                      final interest =
                          state.myInterestState!.myInterestList![index];

                      return GestureDetector(
                        onTap: () {
                          AIZRoute.push(
                            context,
                            UserPublicProfile(userId: interest.userId!),
                            middleware: ProfileViewMiddleware(
                              context: context,
                              user: store.state.authState?.userData,
                            ),
                          );
                        },
                        child: MyInterestCard(
                          photo: interest.photo,
                          name: interest.name,
                          status: interest.status,
                          age: interest.age,
                          country: interest.country,
                          religion: interest.religion,
                          motherTongue: interest.mothereTongue,
                          onDelete: () {
                            if (interest.id != null && interest.name != null) {
                              showDeleteDialog(
                                interest.id!,
                                index,
                                interest.name!,
                              );
                            }
                          },
                        ),
                      );
                    },
                  )
                  : state.myInterestState!.fullReset!
                  ? Container()
                  : SizedBox(
                    height: DeviceInfo(context).height,
                    child: CommonWidget.noData,
                  ),
        ),
      ),
    );
  }
}
