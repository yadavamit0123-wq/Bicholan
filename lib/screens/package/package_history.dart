
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/components/name_date_row.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_middlewares.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';

class PackageHistory extends StatefulWidget {
  bool from_package;

  PackageHistory({super.key, this.from_package = false});

  @override
  State<PackageHistory> createState() => _PackageHistoryState();
}

class _PackageHistoryState extends State<PackageHistory> {
  ScrollController scrollController = ScrollController();

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
      store.dispatch(Reset.packageHistory);
      store.dispatch(packageHistoryMiddleware());
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (store.state.packageState!.hasMore!) {
          store.dispatch(packageHistoryMiddleware());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
  Future<void> _onRefresh() async {
    store.dispatch(Reset.packageHistory);
    store.dispatch(packageHistoryMiddleware());

    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) => WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppNavigation()),
                (route) => false,
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0.0,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              AppLocalizations.of(context)!.package_history,
              style: Styles.bold_app_accent_16,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AppNavigation()),
                      (route) => false,
                );
              },
            ),
          ),

          body: SafeArea(
            child:
            state.packageState!.isFetching!
                ? Center(
              child: CircularProgressIndicator(
                color: MyTheme.storm_grey,
              ),
            )
                : RefreshIndicator(
              onRefresh: _onRefresh,
              color: MyTheme.app_accent_color,
              child: buildListViewSeperated(context, state),
            ),
          ),
        ),


      ),
    );
  }

  Widget buildListViewSeperated(BuildContext maincontext, AppState state) {
    return Container(
      child:
      state.packageState!.packageHistoryList!.isNotEmpty
          ? ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.packageState!.packageHistoryList!.length + 1,
        separatorBuilder:
            (BuildContext context, int index) =>
        const SizedBox(height: 20),
        itemBuilder: (BuildContext context, int index) {
          if (index == state.packageState!.packageHistoryList!.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Center(
                child:
                state.packageState!.hasMore!
                    ? CircularProgressIndicator(
                  color: MyTheme.storm_grey,
                )
                    : const Text('No more data'),
              ),
            );
          }
          return Container(
            /// box decoration
            margin: EdgeInsets.symmetric(
              horizontal: Const.kPaddingHorizontal,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
              boxShadow: [CommonWidget.box_shadow()],
            ),

            // child
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 14,
                bottom: 14,
                right: 5,
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NameDataRow(
                        name:
                        AppLocalizations.of(
                          context,
                        )!.package_history_code,
                        data:
                        state
                            .packageState!
                            .packageHistoryList![index]
                            .paymentCode,
                      ),
                      Const.height5,
                      NameDataRow(
                        name:
                        AppLocalizations.of(
                          context,
                        )!.package_history_package,
                        data:
                        state
                            .packageState!
                            .packageHistoryList![index]
                            .packageName,
                      ),
                      Const.height5,
                      NameDataRow(
                        name:
                        AppLocalizations.of(
                          context,
                        )!.package_history_payment_method,
                        data:
                        state
                            .packageState!
                            .packageHistoryList![index]
                            .paymentMethod,
                      ),
                      Const.height5,
                      NameDataRow(
                        name:
                        AppLocalizations.of(
                          context,
                        )!.package_history_amount,
                        data:
                        state
                            .packageState!
                            .packageHistoryList![index]
                            .amount,
                      ),
                      Const.height5,
                      NameDataRow(
                        name:
                        AppLocalizations.of(
                          context,
                        )!.package_history_payment_status,
                        data:
                        state
                            .packageState!
                            .packageHistoryList![index]
                            .paymentStatus,
                      ),
                      Const.height5,
                      NameDataRow(
                        name:
                        AppLocalizations.of(
                          context,
                        )!.package_history_purchase_date,
                        data:
                        state
                            .packageState!
                            .packageHistoryList![index]
                            .date,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )
          : SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(maincontext).size.height * 0.7,
          child: Center(
            child: Text(AppLocalizations.of(maincontext)!.common_no_data),
          ),
        ),
      ),
    );
  }
}