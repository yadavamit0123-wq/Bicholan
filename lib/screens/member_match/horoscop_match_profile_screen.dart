import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/user.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/matched_profile/matched_profile_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common_app_bar.dart';
import '../../l10n/app_localizations.dart';

class HoroscopMatchProfileScreen extends StatefulWidget {
  const HoroscopMatchProfileScreen({Key? key}) : super(key: key);

  @override
  State<HoroscopMatchProfileScreen> createState() =>
      _HoroscopMatchProfileScreenState();
}

class _HoroscopMatchProfileScreenState
    extends State<HoroscopMatchProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure store dispatch happens after frame building
      StoreProvider.of<AppState>(
        context,
      ).dispatch(horoscopMatchedProfileFetchAction());
    });
  }

  // Refresh list data
  Future<void> _onRefresh() async {
    StoreProvider.of<AppState>(
      context,
    ).dispatch(horoscopMatchedProfileFetchAction());
    // Delay to show the loading spinner briefly
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(text: "Horoscope Match Profile").build(context),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, _ViewModel vm) {
          if (vm.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error.isNotEmpty) {
            return Center(child: Text("Error: ${vm.error}"));
          }

          // Wrapped with RefreshIndicator
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: MyTheme.app_accent_color,
            child:
                vm.profiles.isEmpty
                    // Use SingleChildScrollView to allow scrolling when data is empty
                    ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(
                          child: Text("No horoscope matches found."),
                        ),
                      ),
                    )
                    // Use ListView when data is available
                    : ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(), // Important for pull-to-refresh functionality
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
                      itemCount: vm.profiles.length,
                      itemBuilder: (context, index) {
                        final profile = vm.profiles[index];
                        return _buildProfileCard(context, vm, profile);
                      },
                    ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    _ViewModel vm,
    MemberData profile,
  ) {
    return GestureDetector(
      onTap: () {
        // ID null check added to prevent routing errors
        if (profile.userId != null) {
          AIZRoute.push(
            context,
            UserPublicProfile(userId: profile.userId!),
            middleware: ProfileViewMiddleware(
              context: context,
              user: vm.currentUser,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  image: DecorationImage(
                    // Fallback for missing photos
                    image: NetworkImage(profile.photo ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name ?? "Unknown User",
                      style: Styles.bold_white_14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${profile.age ?? 0} yrs, ${profile.height ?? 0} ft, ${profile.maritalStatus ?? "N/A"}',
                      style: Styles.regular_white_12,
                    ),
                    Text(
                      '${profile.religion ?? ""}, ${profile.caste ?? ""}',
                      style: Styles.regular_white_12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final bool isFetching;
  final List<MemberData> profiles;
  final String error;
  final User? currentUser;
  final bool? isUserVerified;
  final String? packageExpiry;

  _ViewModel({
    required this.isFetching,
    required this.profiles,
    required this.error,
    required this.currentUser,
    required this.isUserVerified,
    required this.packageExpiry,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    // Crucial: Use ?? [] to prevent 'removeWhere' on null errors
    final List<MemberData> rawProfiles =
        store.state.horoscopeMatchedProfileState?.horoscopMatchedProfiles ?? [];

    return _ViewModel(
      isFetching:
          store.state.horoscopeMatchedProfileState?.isFeatching ?? false,
      profiles: rawProfiles,
      error: store.state.horoscopeMatchedProfileState?.error ?? '',
      currentUser: store.state.authState?.userData,
      isUserVerified: store.state.userVerifyState?.isApprove,
      packageExpiry:
          store
              .state
              .accountState
              ?.profileData
              ?.currentPackageInfo
              ?.packageExpiry,
    );
  }
}
