
import 'dart:async';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../../components/chat_list_widget.dart';
import '../../components/deactivate_Massage.dart';
import '../../components/matched_profile_widget.dart';
import '../../const/my_theme.dart';
import '../../redux/libs/matched_profile/matched_profile_middleware.dart';

class ChatList extends StatefulWidget {
  final bool? backButtonAppearance;

  const ChatList({super.key, this.backButtonAppearance});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  PageController matched_profile_controller = PageController();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    bool isDeactivated = store.state.authState?.userData?.deactivated == 1;

    if (!store.state.userVerifyState!.isApprove!) {
      if (widget.backButtonAppearance == true) {
        OneContext().pop();
      }
      store.dispatch(
        ShowMessageAction(
          msg: "Please verify your account",
          color: MyTheme.failure,
        ),
      );
    } else if (isDeactivated) {

    } else {

      store.dispatch(Reset.chatList);
      store.dispatch(chatMiddleware());
      store.dispatch(matchedProfileFetchAction());
      timer = Timer.periodic(
        const Duration(seconds: 20),
            (Timer t) => store.dispatch(chatMiddleware()),
      );
    }
  }

  @override
  void dispose() {

    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        final isDeactivated = state.authState?.userData?.deactivated == 1;
        return Scaffold(
          appBar: buildAppBar(context, screenSize),
          body: isDeactivated
              ? Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
              child: DeactivatedAccountMessage(),
            ),
          )
              : SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                store.dispatch(chatMiddleware());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MatchedProfileWidget(
                    matched_profile_controller:
                    matched_profile_controller,
                    state: state,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(

                      horizontal: screenSize.width * 0.07,
                    ),
                    child: Column(
                      children: [

                        SizedBox(height: screenSize.height * 0.015),
                        Text(
                          AppLocalizations.of(context)!
                              .chat_list_messages,

                          style: Styles.bold_app_accent_16.copyWith(
                              fontSize: screenSize.width * 0.045),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                      ],
                    ),
                  ),

                  /// messages container
                  buildListViewMessagesContainer(context, state, screenSize),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context, Size screenSize) {
    void handleRestrictedNavigation(VoidCallback onActive) {
      bool isDeactivated = store.state.authState?.userData?.deactivated == 1;

      if (isDeactivated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Your account is deactivated. Please reactivate it to use this feature.',textAlign: TextAlign.center,),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        onActive();
      }
    }
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Padding(
        padding: EdgeInsets.symmetric(
          // Responsive change: Proportional padding
            horizontal: screenSize.width * 0.07),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.backButtonAppearance == true)
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/icon/icon_pop.png',
                          // Responsive change: Proportional icon size
                          height: screenSize.width * 0.05,
                          width: screenSize.width * 0.05,
                        ),
                      ),
                      // Responsive change: Proportional spacing
                      SizedBox(width: screenSize.width * 0.025),
                    ],
                  ),
                Text(
                  AppLocalizations.of(context)!.profile_screen_messages,
                  // Responsive change: Proportional font size
                  style: Styles.bold_app_accent_16
                      .copyWith(fontSize: screenSize.width * 0.045),
                ),
              ],
            ),
            CommonWidget.social_button(
              onpressed: () {
               handleRestrictedNavigation((){
                 NavigatorPush.push(context, const Notifications());
               });
              },
              icon: "icon_bell.png",
              gradient: Styles.buildLinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListViewMessagesContainer(
      BuildContext context, AppState state, Size screenSize) {
    return Expanded(
      child: state.chatState!.isFetching!
          ? CommonWidget.circularIndicator
          : state.chatState!.chatList!.isNotEmpty
          ? ListView.separated(
        itemCount: state.chatState!.chatList!.length,
        separatorBuilder: (BuildContext context, int index) {
          // Responsive change: Proportional separator height
          return SizedBox(height: screenSize.height * 0.02);
        },
        itemBuilder: (BuildContext context, int index) {
          if (state.chatState!.chatList![index] == null) {
            return const SizedBox.shrink();
          }

          return ChatListWidget(
            chatId: state.chatState!.chatList![index].id,
            userId: state.chatState!.chatList![index].userId,
            name: state.chatState!.chatList![index].memberName,
            photo: state.chatState!.chatList![index].memberPhoto,
            active: state.chatState!.chatList![index].active,
            packageImage:
            state.chatState!.chatList![index].memberPackage.image,
            lastMessage:
            state.chatState!.chatList![index].lastMessage,
            unseenMessageCount: state
                .chatState!.chatList![index].unseenMessageCount,
          );
        },
      )
          : CommonWidget.noData,
    );
  }
}