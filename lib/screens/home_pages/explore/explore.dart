//
//
// import 'package:active_matrimonial_flutter_app/app_config.dart';
// import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
// import 'package:active_matrimonial_flutter_app/components/package_card.dart';
// import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
// import 'package:active_matrimonial_flutter_app/const/style.dart';
// import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
// import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
// import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
// import 'package:active_matrimonial_flutter_app/screens/blog/blogs.dart';
// import 'package:active_matrimonial_flutter_app/screens/core.dart';
// import 'package:active_matrimonial_flutter_app/screens/happy_story/happy_stories.dart';
// import 'package:active_matrimonial_flutter_app/screens/notifications/notifications.dart';
// import 'package:active_matrimonial_flutter_app/screens/search_screens/search.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
//
// import '../../../components/banner_widget.dart';
// import '../../../components/blog_card.dart';
// import '../../../components/custom_popup.dart';
// import '../../../components/deactivate_Massage.dart';
// import '../../../components/happy_stories_card.dart';
// import '../../../components/member_card.dart';
// import '../../../components/my_images.dart';
// import '../../../components/trusted_user_card.dart';
// import '../../../models_response/Explore/review_response.dart';
// import 'explore_middleware.dart';
//
// class Explore extends StatefulWidget {
//   const Explore({super.key});
//
//   @override
//   State<Explore> createState() => _ExploreState();
// }
//
// class _ExploreState extends State<Explore> {
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return StoreConnector<AppState, ExploreViewModel>(
//       converter: (store) => ExploreViewModel.fromStore(store),
//       onInit: (store) => [
//         store.dispatch(fetchSliderAction()),
//         store.dispatch(fetchPremiumMembersAction()),
//         store.dispatch(fetchBannerAction()),
//         store.dispatch(fetchTrustedByAction()),
//         store.dispatch(fetchNewMembersAction()),
//         store.dispatch(fetchHappyStoriesAction()),
//         store.dispatch(fetchPackagesAction()),
//         store.dispatch(fetchReviewAction()),
//         store.dispatch(fetchBlogsAction()),
//       ],
//       builder: (_, ExploreViewModel vm) {
//         return Scaffold(
//           appBar: buildAppBar(context, screenSize, vm.isLogin),
//           body: vm.isDeactivated ?? false
//               ? Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//               child: const DeactivatedAccountMessage()
//             ),
//           )
//               : SafeArea(
//             child: RefreshIndicator(
//               onRefresh: () async {
//                 store.dispatch(fetchSliderAction());
//                 store.dispatch(fetchPremiumMembersAction());
//                 store.dispatch(fetchBannerAction());
//                 store.dispatch(fetchTrustedByAction());
//                 store.dispatch(fetchNewMembersAction());
//                 store.dispatch(fetchHappyStoriesAction());
//                 store.dispatch(fetchPackagesAction());
//                 store.dispatch(fetchReviewAction());
//                 store.dispatch(fetchBlogsAction());
//               },
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildFirstBanner(context, vm, screenSize),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenSize.width * 0.07,
//                         vertical: screenSize.height * 0.02,
//                       ),
//                       child: buildFindBestFriend(context, screenSize),
//                     ),
//                     buildSecondBanner(context, vm, screenSize),
//                     if (settingIsActive(
//                         "show_trusted_by_millions_section", "on"))
//                       buildTrustedByUsers(context, vm, screenSize),
//                     if (settingIsActive(
//                         "show_premium_member_section", "on"))
//                       buildPremiumMembers(context, vm, screenSize),
//                     if (settingIsActive("show_new_member_section", "on"))
//                       buildNewMembers(context, vm, screenSize),
//                     if (settingIsActive("show_happy_story_section", "on"))
//                       buildHappyStories(context, vm, screenSize),
//                     if (settingIsActive(
//                         "show_homapege_package_section", "on"))
//                       buildPackages(context, vm, screenSize),
//                     if (settingIsActive(
//                         "show_homepage_review_section", "on"))
//                       buildReview(context, vm, screenSize),
//                     if (settingIsActive("show_blog_section", "on"))
//                       buildBlogSection(context, vm, screenSize),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildBlogSection(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       children: [
//         SizedBox(height: screenSize.height * 0.035),
//         Padding(
//           padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
//           child: Column(
//             children: [
//               Padding(
//                 padding:
//                 EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//                 child: InkWell(
//                   onTap: () => NavigatorPush.push(context, const BlogPage()),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.home_9_blog_section,
//                         style: Styles.bold_app_accent_22.copyWith(
//                             fontSize: screenSize.width *
//                                 0.055), // Responsive font
//                       ),
//                       Image.asset(
//                         'assets/icon/icon_right.png',
//                         color: MyTheme.gull_grey,
//                         height:
//                         screenSize.width * 0.04,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: screenSize.height * 0.012),
//               BlogCard(isFetching: vm.isFetchingBlog!, blogList: vm.blogs!),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildReview(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//           child: Text(
//             AppLocalizations.of(context)!.home_9_real_reviews,
//             style: Styles.bold_app_accent_22.copyWith(
//                 fontSize: screenSize.width * 0.055),
//           ),
//         ),
//         SizedBox(height: screenSize.height * 0.012),
//         AspectRatio(
//           aspectRatio:
//           1 / 1,
//           child: Container(
//             width: screenSize.width,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: MyImage.imageProvider(vm.reviews?.bgImage) ??
//                     const AssetImage(
//                         'assets/images/real_review_back_img.png'),
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 vm.isFetchingReview!
//                     ? CommonWidget.circularIndicator
//                     : vm.reviews != null
//                     ? CarouselSlider.builder(
//                   carouselController: vm.reviewController,
//                   itemCount: vm.reviews!.items!.length,
//                   itemBuilder: (context, index, realIndex) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           radius: screenSize.width *
//                               0.11, // Proportional radius
//                           backgroundColor: Colors.white,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(
//                                 screenSize.width * 0.11),
//                             child: SizedBox(
//                               width: screenSize.width * 0.2,
//                               height: screenSize.width * 0.2,
//                               child: MyImages.normalImage(
//                                   vm.reviews?.items?[index].image),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: screenSize.height * 0.02),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: screenSize.width * 0.05),
//                           child: Text(
//                             vm.reviews!.items![index].review!,
//                             textAlign: TextAlign.center,
//                             style: Styles.italic_white_14.copyWith(
//                                 fontSize: screenSize.width *
//                                     0.04), // Responsive font
//                             maxLines: 5,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(height: screenSize.height * 0.012),
//                         Image.asset(
//                           'assets/icon/icon_qoute.png',
//                           height: screenSize.width *
//                               0.08, // Proportional size
//                         ),
//                       ],
//                     );
//                   },
//                   options: CarouselOptions(
//                     aspectRatio: 1 / 1,
//                     enlargeCenterPage: true,
//                     autoPlay: true,
//                     viewportFraction: 1,
//                   ),
//                 )
//                     : const Center(
//                     child: Text("No Data Found",
//                         style: TextStyle(color: Colors.black))),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildNewMembers(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//           child: Text(
//             AppLocalizations.of(context)!.home_9_new_members,
//             style: Styles.bold_app_accent_22.copyWith(
//                 fontSize: screenSize.width * 0.055),
//           ),
//         ),
//         SizedBox(height: screenSize.height * 0.012),
//         MemberCard(
//           isLogin: vm.isLogin,
//           isFetching: vm.isFetchingNewMembers!,
//           memberList: vm.newMemberList!,
//           controller: vm.pageController,
//           isProfileView: vm.isFullProfileView!,
//           memberType: vm.myMembershipType.toString(),
//         ),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   Widget buildHappyStories(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () => NavigatorPush.push(context, const HappyStories()),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)!.home_9_happy_stories,
//                   style: Styles.bold_app_accent_22.copyWith(
//                       fontSize:
//                       screenSize.width * 0.055),
//                 ),
//                 Image.asset(
//                   'assets/icon/icon_right.png',
//                   color: MyTheme.gull_grey,
//                   height: screenSize.width * 0.04,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: screenSize.height * 0.012),
//         HappyStoriesCard(
//           isFetching: vm.isFetchingHappyStories!,
//           happyStories: vm.happyStories!,
//           controller: vm.happyStoriesController,
//           happyStoriesIndex: vm.happyStoriesIndex!,
//         ),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   Widget buildPackages(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//           child: Text(
//             AppLocalizations.of(context)!.home_9_packages,
//             style: Styles.bold_app_accent_22.copyWith(
//                 fontSize: screenSize.width * 0.055),
//           ),
//         ),
//         SizedBox(height: screenSize.height * 0.012),
//         PackageCard(
//           isFetching: vm.isFetchingPackages!,
//           packageList: vm.packages!,
//           isLogin: vm.isLogin,
//           profilePicturePrivacy: vm.profilePicturePrivacy!,
//           galleryPicturePrivacy: vm.galleryPicturePrivacy!,
//         ),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   Widget buildTrustedByUsers(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//           child: Text(
//             AppLocalizations.of(context)!.home_9_trusted_by_users,
//             style: Styles.bold_app_accent_22.copyWith(
//                 fontSize: screenSize.width * 0.055),
//           ),
//         ),
//         SizedBox(height: screenSize.height * 0.012),
//         TrustedUserCard(
//             isFetching: vm.isFetchingTrustBy!, cardList: vm.trustedByList!),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   Widget buildSecondBanner(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       children: [
//         BannerWidget(
//           isSlider: false,
//           isFetching: vm.isFetchingBanner!,
//           bannerList: vm.bannerList!,
//           carouselIndex: vm.carouselIndex2,
//           controller: vm.carouselController2,
//         ),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   Widget buildPremiumMembers(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//           child: Text(
//             getSettingValue("premium_member_section_title"),
//             style: Styles.bold_app_accent_22.copyWith(
//                 fontSize: screenSize.width * 0.055),
//           ),
//         ),
//         SizedBox(height: screenSize.height * 0.012),
//         MemberCard(
//           isLogin: vm.isLogin,
//           isFetching: vm.isFetchingPremiumMembers!,
//           memberList: vm.premiumMembersList!,
//           controller: vm.pageController,
//           isProfileView: vm.isFullProfileView!,
//           memberType: vm.myMembershipType.toString(),
//         ),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   Widget buildFindBestFriend(BuildContext context, Size screenSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           AppLocalizations.of(context)!.landing_page_title,
//           style: Styles.bold_app_accent_30
//               .copyWith(fontSize: screenSize.width * 0.08),
//         ),
//         SizedBox(height: screenSize.height * 0.012),
//         Text(
//           AppLocalizations.of(context)!.landing_page_sub_title,
//           style: Styles.regular_arsenic_14.copyWith(
//               fontSize: screenSize.width * 0.04),
//         ),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   Widget buildFirstBanner(
//       BuildContext context, ExploreViewModel vm, Size screenSize) {
//     return Column(
//       children: [
//         BannerWidget(
//           isSlider: true,
//           isFetching: vm.isFetchingSlider!,
//           bannerList: vm.sliderImages!,
//           carouselIndex: vm.carouselIndex,
//           controller: vm.carouselController,
//         ),
//         SizedBox(height: screenSize.height * 0.035),
//       ],
//     );
//   }
//
//   AppBar buildAppBar(BuildContext context, Size screenSize, bool isLogin) {
//     void handleRestrictedNavigation(VoidCallback onActive) {
//       bool isDeactivated = store.state.authState?.userData?.deactivated == 1;
//
//       if (isDeactivated) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//                 'Your account is deactivated. Please reactivate it to use this feature.',
//             textAlign: TextAlign.center,),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 1),
//           ),
//         );
//       } else {
//         onActive();
//       }
//     }
//     return AppBar(
//       automaticallyImplyLeading: false,
//       titleSpacing: 0,
//       elevation: 0.0,
//       backgroundColor: Colors.white,
//       title: Padding(
//         padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.07),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   'assets/logo/appbar_logo.png',
//                   fit: BoxFit.contain,
//                   height: screenSize.height * 0.04,
//                   width: screenSize.width * 0.1,
//                 ),
//                 SizedBox(width: screenSize.width * 0.02),
//                 Text(
//                   AppConfig.app_name,
//                   style: Styles.bold_app_accent_16.copyWith(
//                       fontSize:
//                       screenSize.width * 0.045),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 CommonWidget.social_button(
//                   gradient: Styles.buildLinearGradient(
//                       begin: Alignment.topLeft, end: Alignment.bottomRight),
//                   icon: "icon_bell.png",
//                   onpressed: () {
//                    handleRestrictedNavigation((){
//                      isLogin
//                          ? NavigatorPush.push(context, const Notifications())
//                          : CustomPopUp(context).loginDialog(context);
//                    });
//                   },
//                 ),
//                 SizedBox(width: screenSize.width * 0.02),
//                 CommonWidget.social_button(
//                   gradient: Styles.buildLinearGradient(
//                       begin: Alignment.topLeft, end: Alignment.bottomRight),
//                   icon: "icon_search.png",
//                   onpressed: () {
//
//                     handleRestrictedNavigation((){
//                       isLogin
//                           ? showModalBottomSheet(
//                         context: context,
//                         isScrollControlled: true,
//                         builder: (context) => FractionallySizedBox(
//                           heightFactor: 0.9,
//                           child: Search(),
//                         ),
//                       )
//                           : CustomPopUp(context).loginDialog(context);
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ExploreViewModel {
//   final bool isLogin;
//   final bool? isDeactivated;
//   final bool? isFullProfileView;
//   final dynamic myMembershipType;
//   final bool? profilePicturePrivacy;
//   final bool? galleryPicturePrivacy;
//   final String? error;
//   final int? carouselIndex;
//   final int? carouselIndex2;
//   final int? happyStoriesIndex;
//   final dynamic carouselController;
//   final dynamic carouselController2;
//   final dynamic happyStoriesController;
//   final dynamic reviewController;
//   final dynamic pageController;
//   final bool? isFetchingSlider;
//   final List? sliderImages;
//   final bool? isFetchingPremiumMembers;
//   final List<MemberData>? premiumMembersList;
//   final bool? isFetchingBanner;
//   final List? bannerList;
//   final bool? isFetchingTrustBy;
//   final List? trustedByList;
//   final bool? isFetchingNewMembers;
//   final List<MemberData>? newMemberList;
//   final bool? isFetching;
//   final bool? isFetchingPackages;
//   final List? packages;
//   final bool? isFetchingHappyStories;
//   final List? happyStories;
//   final bool? isFetchingReview;
//   final ReviewData? reviews;
//   final bool? isFetchingBlog;
//   final List? blogs;
//   final String? currencyCode;
//
//   ExploreViewModel({
//     required this.isLogin,
//     this.isDeactivated,
//     this.isFullProfileView,
//     this.myMembershipType,
//     this.profilePicturePrivacy,
//     this.galleryPicturePrivacy,
//     this.error,
//     this.carouselIndex,
//     this.carouselIndex2,
//     this.happyStoriesIndex,
//     this.carouselController,
//     this.carouselController2,
//     this.happyStoriesController,
//     this.reviewController,
//     this.pageController,
//     this.isFetchingSlider,
//     this.sliderImages,
//     this.isFetchingPremiumMembers,
//     this.premiumMembersList,
//     this.isFetchingBanner,
//     this.bannerList,
//     this.isFetchingTrustBy,
//     this.trustedByList,
//     this.isFetchingNewMembers,
//     this.newMemberList,
//     this.isFetching,
//     this.isFetchingPackages,
//     this.packages,
//     this.isFetchingHappyStories,
//     this.happyStories,
//     this.isFetchingReview,
//     this.reviews,
//     this.isFetchingBlog,
//     this.blogs,
//     this.currencyCode,
//   });
//
//   static ExploreViewModel fromStore(Store<AppState> store) {
//     return ExploreViewModel(
//       isLogin: store.state.authState?.userData?.id != null,
//       isDeactivated:
//       store.state.authState?.userData?.deactivated == 1,
//       isFullProfileView: settingIsActive(
//         "full_profile_show_according to_membership",
//         "1",
//       ),
//       myMembershipType: store.state.packageDetailsState?.data?.name,
//       profilePicturePrivacy: settingIsActive(
//         "profile_picture_privacy",
//         "only_me",
//       ),
//       galleryPicturePrivacy: settingIsActive(
//         "gallery_image_privacy",
//         "only_me",
//       ),
//       error: store.state.exploreState?.error,
//       carouselIndex: store.state.exploreState?.carouselIndex,
//       carouselIndex2: store.state.exploreState?.carouselIndex2,
//       carouselController: store.state.exploreState?.carouselController,
//       carouselController2: store.state.exploreState?.carouselController2,
//       happyStoriesIndex: store.state.exploreState?.happyStoriesIndex,
//       happyStoriesController:
//       store.state.exploreState?.happyStoriesController,
//       reviewController: store.state.exploreState?.reviewController,
//       pageController: store.state.exploreState?.pageController,
//       isFetchingSlider: store.state.exploreState?.isFetchingSlider,
//       sliderImages: store.state.exploreState?.sliderImageList,
//       isFetchingPremiumMembers:
//       store.state.exploreState?.isFetchingPremiumMembers,
//       premiumMembersList: store.state.exploreState?.premiumMemberList,
//       isFetchingBanner: store.state.exploreState?.isFetchingBanner,
//       bannerList: store.state.exploreState?.bannerList,
//       isFetchingTrustBy: store.state.exploreState?.isFetchingTrustedBy,
//       trustedByList: store.state.exploreState?.trustedByList,
//       isFetchingNewMembers: store.state.exploreState?.isFetchingNewMembers,
//       newMemberList: store.state.exploreState?.newMemberList,
//       isFetchingHappyStories:
//       store.state.exploreState?.isFetchingHappyStories,
//       happyStories: store.state.exploreState?.happyStoriesList,
//       isFetchingPackages: store.state.exploreState?.isFetchingPackage,
//       packages: store.state.exploreState?.packageList,
//       isFetchingReview: store.state.exploreState?.isFetchingReview,
//       reviews: store.state.exploreState?.review,
//       isFetchingBlog: store.state.exploreState?.isFetchingBlog,
//       blogs: store.state.exploreState?.blogList,
//       currencyCode: getSettingValue("system_default_currency"),
//     );
//   }
// }

import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/components/package_card.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:active_matrimonial_flutter_app/screens/blog/blogs.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/happy_story/happy_stories.dart';
import 'package:active_matrimonial_flutter_app/screens/notifications/notifications.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../../../components/banner_widget.dart';
import '../../../components/blog_card.dart';
import '../../../components/custom_popup.dart';
import '../../../components/deactivate_Massage.dart';
import '../../../components/happy_stories_card.dart';
import '../../../components/member_card.dart';
import '../../../components/my_images.dart';
import '../../../components/trusted_user_card.dart';
import '../../../models_response/Explore/review_response.dart';
import 'explore_middleware.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  void handleRestrictedNavigation(VoidCallback onActive) {
    bool isDeactivated = store.state.authState?.userData?.deactivated == 1;
    bool isVerified = store.state.userVerifyState?.isApprove ?? false;

    var profile = store.state.accountState?.profileData;
    var package = profile?.currentPackageInfo;
    bool hasActivePkg = package?.packageId != null;

    if (isDeactivated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your account is deactivated. Please reactivate it to use this feature.', textAlign: TextAlign.center),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please verify your account.", textAlign: TextAlign.center),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!hasActivePkg) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please purchase a package", textAlign: TextAlign.center),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    onActive();
  }
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions once
    final screenSize = MediaQuery.of(context).size;

    // Define responsive constants for consistent spacing and sizing
    final double hPadding = screenSize.width * 0.07;
    final double vItemSpacer = screenSize.height * 0.012;
    final double vSectionSpacer = screenSize.height * 0.035;

    // Define responsive font sizes with clamping to ensure readability on all devices
    final double headerFontSize = (screenSize.width * 0.08).clamp(28.0, 40.0);
    final double titleFontSize = (screenSize.width * 0.055).clamp(20.0, 28.0);
    final double subtitleFontSize = (screenSize.width * 0.04).clamp(14.0, 18.0);
    final double appBarTitleSize = (screenSize.width * 0.045).clamp(16.0, 22.0);

    // Define responsive icon sizes
    final double appBarIconSize = screenSize.height * 0.04;
    final double arrowIconSize = screenSize.width * 0.04;

    return StoreConnector<AppState, ExploreViewModel>(
      converter: (store) => ExploreViewModel.fromStore(store),
      onInit: (store) => [
        store.dispatch(fetchSliderAction()),
        store.dispatch(fetchPremiumMembersAction()),
        store.dispatch(fetchBannerAction()),
        store.dispatch(fetchTrustedByAction()),
        store.dispatch(fetchNewMembersAction()),
        store.dispatch(fetchHappyStoriesAction()),
        store.dispatch(fetchPackagesAction()),
        store.dispatch(fetchReviewAction()),
        store.dispatch(fetchBlogsAction()),
      ],
      builder: (_, ExploreViewModel vm) {
        return Scaffold(
          appBar: buildAppBar(context, vm.isLogin, hPadding, appBarTitleSize, appBarIconSize),
          body: vm.isDeactivated ?? false
              ? Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: const DeactivatedAccountMessage(),
            ),
          )
              : SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                store.dispatch(fetchSliderAction());
                store.dispatch(fetchPremiumMembersAction());
                store.dispatch(fetchBannerAction());
                store.dispatch(fetchTrustedByAction());
                store.dispatch(fetchNewMembersAction());
                store.dispatch(fetchHappyStoriesAction());
                store.dispatch(fetchPackagesAction());
                store.dispatch(fetchReviewAction());
                store.dispatch(fetchBlogsAction());
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFirstBanner(context, vm, vSectionSpacer),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding),
                      child: buildFindBestFriend(
                        context,
                        headerFontSize,
                        subtitleFontSize,
                        vItemSpacer,
                        vSectionSpacer,
                      ),
                    ),
                    buildSecondBanner(context, vm, vSectionSpacer),
                    if (settingIsActive("show_trusted_by_millions_section", "on"))
                      buildTrustedByUsers(
                          context, vm, hPadding, vItemSpacer, vSectionSpacer, titleFontSize),
                    if (settingIsActive("show_premium_member_section", "on"))
                      buildPremiumMembers(
                          context, vm, hPadding, vItemSpacer, vSectionSpacer, titleFontSize),
                    if (settingIsActive("show_new_member_section", "on"))
                      buildNewMembers(
                          context, vm, hPadding, vItemSpacer, vSectionSpacer, titleFontSize),
                    if (settingIsActive("show_happy_story_section", "on"))
                      buildHappyStories(context, vm, hPadding, vItemSpacer, vSectionSpacer,
                          titleFontSize, arrowIconSize),
                    if (settingIsActive("show_homapege_package_section", "on"))
                      buildPackages(
                          context, vm, hPadding, vItemSpacer, vSectionSpacer, titleFontSize),
                    if (settingIsActive("show_homepage_review_section", "on"))
                      buildReview(context, vm, screenSize, hPadding, vItemSpacer, titleFontSize,
                          subtitleFontSize),
                    if (settingIsActive("show_blog_section", "on"))
                      buildBlogSection(context, vm, hPadding, vItemSpacer, vSectionSpacer,
                          titleFontSize, arrowIconSize),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBlogSection(
      BuildContext context,
      ExploreViewModel vm,
      double hPadding,
      double vItemSpacer,
      double vSectionSpacer,
      double titleFontSize,
      double arrowIconSize) {
    return Column(
      children: [
        SizedBox(height: vSectionSpacer),
        Padding(
          padding: EdgeInsets.only(bottom: vItemSpacer),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: InkWell(
                  onTap: () => NavigatorPush.push(context, const BlogPage()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.home_9_blog_section,
                        style: Styles.bold_app_accent_22
                            .copyWith(fontSize: titleFontSize),
                      ),
                      Image.asset(
                        'assets/icon/icon_right.png',
                        color: MyTheme.gull_grey,
                        height: arrowIconSize,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: vItemSpacer),
              BlogCard(isFetching: vm.isFetchingBlog!, blogList: vm.blogs!),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildReview(
      BuildContext context,
      ExploreViewModel vm,
      Size screenSize,
      double hPadding,
      double vItemSpacer,
      double titleFontSize,
      double subtitleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Text(
            AppLocalizations.of(context)!.home_9_real_reviews,
            style: Styles.bold_app_accent_22.copyWith(fontSize: titleFontSize),
          ),
        ),
        SizedBox(height: vItemSpacer),
        AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: MyImage.imageProvider(vm.reviews?.bgImage) ??
                    const AssetImage(
                        'assets/images/real_review_back_img.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                vm.isFetchingReview!
                    ? CommonWidget.circularIndicator
                    : vm.reviews != null && vm.reviews!.items!.isNotEmpty
                    ? CarouselSlider.builder(
                  carouselController: vm.reviewController,
                  itemCount: vm.reviews!.items!.length,
                  itemBuilder: (context, index, realIndex) {
                    final item = vm.reviews!.items![index];
                    // Proportional sizing for avatar and icon
                    final avatarRadius = screenSize.width * 0.11;
                    final quoteIconSize = screenSize.width * 0.08;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(avatarRadius),
                            child: SizedBox(
                              width: avatarRadius * 1.8,
                              height: avatarRadius * 1.8,
                              child:
                              MyImages.normalImage(item.image),
                            ),
                          ),
                        ),
                        SizedBox(height: vItemSpacer * 1.5),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Text(
                            item.review!,
                            textAlign: TextAlign.center,
                            style: Styles.italic_white_14.copyWith(
                                fontSize: subtitleFontSize),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: vItemSpacer),
                        Image.asset(
                          'assets/icon/icon_qoute.png',
                          height: quoteIconSize,
                        ),
                      ],
                    );
                  },
                  options: CarouselOptions(
                    aspectRatio: 1 / 1,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 1,
                  ),
                )
                    : const Center(
                    child: Text("No Reviews Found",
                        style: TextStyle(color: Colors.white, fontSize: 16))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNewMembers(
      BuildContext context,
      ExploreViewModel vm,
      double hPadding,
      double vItemSpacer,
      double vSectionSpacer,
      double titleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Text(
            AppLocalizations.of(context)!.home_9_new_members,
            style: Styles.bold_app_accent_22.copyWith(fontSize: titleFontSize),
          ),
        ),
        SizedBox(height: vItemSpacer),
        MemberCard(
          isLogin: vm.isLogin,
          isFetching: vm.isFetchingNewMembers!,
          memberList: vm.newMemberList!,
          controller: vm.pageController,
          isProfileView: vm.isFullProfileView!,
          memberType: vm.myMembershipType.toString(),
        ),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  Widget buildHappyStories(
      BuildContext context,
      ExploreViewModel vm,
      double hPadding,
      double vItemSpacer,
      double vSectionSpacer,
      double titleFontSize,
      double arrowIconSize) {
    return Column(
      children: [
        InkWell(
          onTap: () => NavigatorPush.push(context, const HappyStories()),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.home_9_happy_stories,
                  style:
                  Styles.bold_app_accent_22.copyWith(fontSize: titleFontSize),
                ),
                Image.asset(
                  'assets/icon/icon_right.png',
                  color: MyTheme.gull_grey,
                  height: arrowIconSize,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: vItemSpacer),
        HappyStoriesCard(
          isFetching: vm.isFetchingHappyStories!,
          happyStories: vm.happyStories!,
          controller: vm.happyStoriesController,
          happyStoriesIndex: vm.happyStoriesIndex!,
        ),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  Widget buildPackages(
      BuildContext context,
      ExploreViewModel vm,
      double hPadding,
      double vItemSpacer,
      double vSectionSpacer,
      double titleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Text(
            AppLocalizations.of(context)!.home_9_packages,
            style: Styles.bold_app_accent_22.copyWith(fontSize: titleFontSize),
          ),
        ),
        SizedBox(height: vItemSpacer),
        PackageCard(
          isFetching: vm.isFetchingPackages!,
          packageList: vm.packages!,
          isLogin: vm.isLogin,
          profilePicturePrivacy: vm.profilePicturePrivacy!,
          galleryPicturePrivacy: vm.galleryPicturePrivacy!,
        ),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  Widget buildTrustedByUsers(
      BuildContext context,
      ExploreViewModel vm,
      double hPadding,
      double vItemSpacer,
      double vSectionSpacer,
      double titleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Text(
            AppLocalizations.of(context)!.home_9_trusted_by_users,
            style: Styles.bold_app_accent_22.copyWith(fontSize: titleFontSize),
          ),
        ),
        SizedBox(height: vItemSpacer),
        TrustedUserCard(
            isFetching: vm.isFetchingTrustBy!, cardList: vm.trustedByList!),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  Widget buildSecondBanner(
      BuildContext context, ExploreViewModel vm, double vSectionSpacer) {
    return Column(
      children: [
        BannerWidget(
          isSlider: false,
          isFetching: vm.isFetchingBanner!,
          bannerList: vm.bannerList!,
          carouselIndex: vm.carouselIndex2,
          controller: vm.carouselController2,
        ),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  Widget buildPremiumMembers(
      BuildContext context,
      ExploreViewModel vm,
      double hPadding,
      double vItemSpacer,
      double vSectionSpacer,
      double titleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          child: Text(
            getSettingValue("premium_member_section_title"),
            style: Styles.bold_app_accent_22.copyWith(fontSize: titleFontSize),
          ),
        ),
        SizedBox(height: vItemSpacer),
        MemberCard(
          isLogin: vm.isLogin,
          isFetching: vm.isFetchingPremiumMembers!,
          memberList: vm.premiumMembersList!,
          controller: vm.pageController,
          isProfileView: vm.isFullProfileView!,
          memberType: vm.myMembershipType.toString(),
        ),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  Widget buildFindBestFriend(
      BuildContext context,
      double headerFontSize,
      double subtitleFontSize,
      double vItemSpacer,
      double vSectionSpacer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.landing_page_title,
          style: Styles.bold_app_accent_30.copyWith(fontSize: headerFontSize),
        ),
        SizedBox(height: vItemSpacer),
        Text(
          AppLocalizations.of(context)!.landing_page_sub_title,
          style: Styles.regular_arsenic_14
              .copyWith(fontSize: subtitleFontSize),
        ),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  Widget buildFirstBanner(
      BuildContext context, ExploreViewModel vm, double vSectionSpacer) {
    return Column(
      children: [
        BannerWidget(
          isSlider: true,
          isFetching: vm.isFetchingSlider!,
          bannerList: vm.sliderImages!,
          carouselIndex: vm.carouselIndex,
          controller: vm.carouselController,
        ),
        SizedBox(height: vSectionSpacer),
      ],
    );
  }

  AppBar buildAppBar(
      BuildContext context, bool isLogin, double hPadding, double titleFontSize, double iconSize) {


    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: iconSize * 1.7,
              width: MediaQuery.of(context).size.width * 0.52,
              child: Image.asset(
                'assets/logo/splash_logo.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
            Row(
              children: [
                CommonWidget.social_button(
                  gradient: Styles.buildLinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  icon: "icon_bell.png",
                  onpressed: () {
                    handleRestrictedNavigation(() {
                      isLogin
                          ? NavigatorPush.push(context, const Notifications())
                          : CustomPopUp(context).loginDialog(context);
                    });
                  },
                ),
                const SizedBox(width: 8),
                CommonWidget.social_button(
                  gradient: Styles.buildLinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  icon: "icon_search.png",
                  onpressed: () {
                    handleRestrictedNavigation(() {
                      isLogin
                          ? showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: 0.9,
                          child: Search(),
                        ),
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
}

// The ExploreViewModel remains unchanged as its logic is not related to UI responsiveness.
class ExploreViewModel {
  final bool isLogin;
  final bool? isDeactivated;
  final bool? isFullProfileView;
  final dynamic myMembershipType;
  final bool? profilePicturePrivacy;
  final bool? galleryPicturePrivacy;
  final String? error;
  final int? carouselIndex;
  final int? carouselIndex2;
  final int? happyStoriesIndex;
  final dynamic carouselController;
  final dynamic carouselController2;
  final dynamic happyStoriesController;
  final dynamic reviewController;
  final dynamic pageController;
  final bool? isFetchingSlider;
  final List? sliderImages;
  final bool? isFetchingPremiumMembers;
  final List<MemberData>? premiumMembersList;
  final bool? isFetchingBanner;
  final List? bannerList;
  final bool? isFetchingTrustBy;
  final List? trustedByList;
  final bool? isFetchingNewMembers;
  final List<MemberData>? newMemberList;
  final bool? isFetching;
  final bool? isFetchingPackages;
  final List? packages;
  final bool? isFetchingHappyStories;
  final List? happyStories;
  final bool? isFetchingReview;
  final ReviewData? reviews;
  final bool? isFetchingBlog;
  final List? blogs;
  final String? currencyCode;

  ExploreViewModel({
    required this.isLogin,
    this.isDeactivated,
    this.isFullProfileView,
    this.myMembershipType,
    this.profilePicturePrivacy,
    this.galleryPicturePrivacy,
    this.error,
    this.carouselIndex,
    this.carouselIndex2,
    this.happyStoriesIndex,
    this.carouselController,
    this.carouselController2,
    this.happyStoriesController,
    this.reviewController,
    this.pageController,
    this.isFetchingSlider,
    this.sliderImages,
    this.isFetchingPremiumMembers,
    this.premiumMembersList,
    this.isFetchingBanner,
    this.bannerList,
    this.isFetchingTrustBy,
    this.trustedByList,
    this.isFetchingNewMembers,
    this.newMemberList,
    this.isFetching,
    this.isFetchingPackages,
    this.packages,
    this.isFetchingHappyStories,
    this.happyStories,
    this.isFetchingReview,
    this.reviews,
    this.isFetchingBlog,
    this.blogs,
    this.currencyCode,
  });

  static ExploreViewModel fromStore(Store<AppState> store) {
    return ExploreViewModel(
      isLogin: store.state.authState?.userData?.id != null,
      isDeactivated:
      store.state.authState?.userData?.deactivated == 1,
      isFullProfileView: settingIsActive(
        "full_profile_show_according to_membership",
        "1",
      ),
      myMembershipType: store.state.packageDetailsState?.data?.name,
      profilePicturePrivacy: settingIsActive(
        "profile_picture_privacy",
        "only_me",
      ),
      galleryPicturePrivacy: settingIsActive(
        "gallery_image_privacy",
        "only_me",
      ),
      error: store.state.exploreState?.error,
      carouselIndex: store.state.exploreState?.carouselIndex,
      carouselIndex2: store.state.exploreState?.carouselIndex2,
      carouselController: store.state.exploreState?.carouselController,
      carouselController2: store.state.exploreState?.carouselController2,
      happyStoriesIndex: store.state.exploreState?.happyStoriesIndex,
      happyStoriesController:
      store.state.exploreState?.happyStoriesController,
      reviewController: store.state.exploreState?.reviewController,
      pageController: store.state.exploreState?.pageController,
      isFetchingSlider: store.state.exploreState?.isFetchingSlider,
      sliderImages: store.state.exploreState?.sliderImageList,
      isFetchingPremiumMembers:
      store.state.exploreState?.isFetchingPremiumMembers,
      premiumMembersList: store.state.exploreState?.premiumMemberList,
      isFetchingBanner: store.state.exploreState?.isFetchingBanner,
      bannerList: store.state.exploreState?.bannerList,
      isFetchingTrustBy: store.state.exploreState?.isFetchingTrustedBy,
      trustedByList: store.state.exploreState?.trustedByList,
      isFetchingNewMembers: store.state.exploreState?.isFetchingNewMembers,
      newMemberList: store.state.exploreState?.newMemberList,
      isFetchingHappyStories:
      store.state.exploreState?.isFetchingHappyStories,
      happyStories: store.state.exploreState?.happyStoriesList,
      isFetchingPackages: store.state.exploreState?.isFetchingPackage,
      packages: store.state.exploreState?.packageList,
      isFetchingReview: store.state.exploreState?.isFetchingReview,
      reviews: store.state.exploreState?.review,
      isFetchingBlog: store.state.exploreState?.isFetchingBlog,
      blogs: store.state.exploreState?.blogList,
      currencyCode: getSettingValue("system_default_currency"),
    );
  }
}