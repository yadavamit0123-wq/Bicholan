import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../helpers/device_info.dart';
import '../screens/core.dart';
import '../screens/home_pages/explore/explore_action.dart';
import 'common_widget.dart';
import 'my_animated_smooth_indicator.dart';

class BannerWidget extends StatelessWidget {
  final bool? isSlider;
  final isFetching;
  final bannerList;
  final carouselIndex;
  final controller;

  const BannerWidget({
    super.key,
    this.isSlider,
    this.isFetching,
    this.bannerList,
    this.carouselIndex,
    this.controller,
  });

  /// Home slider: 1920x1080 = 16:9 (same on app + website, no crop)
  /// Banner section: 1200x600 = 2:1 landscape
  double get _aspectRatio => isSlider == true ? 16 / 9 : 2 / 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceInfo(context).width ?? MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth / _aspectRatio;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: screenWidth,
          height: bannerHeight,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Color(0xFFFAF6F6),
          ),
          clipBehavior: Clip.antiAlias,
          child: isFetching
              ? CommonWidget.circularIndicator
              : bannerList.isNotEmpty
                  ? CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: bannerList.length,
                      itemBuilder: (context, index, realIndex) {
                        return bannerList[index].image != null
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/342x200.png',
                                image: bannerList[index].image,
                                width: double.infinity,
                                height: bannerHeight,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              )
                            : CommonWidget.noData;
                      },
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          isSlider! == false
                              ? store.dispatch(
                                  SetExploreSecondBannerCarouselIndex(
                                      payload: index))
                              : store.dispatch(
                                  SetExploreFirstBannerCarouselIndex(
                                      payload: index));
                        },
                        height: bannerHeight,
                        enlargeCenterPage: isSlider == true,
                        autoPlayInterval: const Duration(seconds: 10),
                        viewportFraction: isSlider == true ? 0.9 : 1.0,
                        autoPlay: true,
                      ),
                    )
                  : CommonWidget.noData,
        ),
        Positioned(
          bottom: 10,
          child: MyAnimatedSmoothIndicator(
              carouselIndex: carouselIndex,
              images: bannerList ?? 0 as List<dynamic>),
        )
      ],
    );
  }
}
