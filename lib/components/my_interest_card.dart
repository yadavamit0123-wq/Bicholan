import 'package:flutter/material.dart';

import '../const/my_theme.dart';
import '../const/style.dart';
import '../helpers/device_info.dart';
import 'common_widget.dart';
import 'my_images.dart';

class MyInterestCard extends StatelessWidget {
  final String? photo;
  final String? name;
  final String? status;
  final int? age;
  final String? country;
  final String? religion;
  final String? motherTongue;
  final VoidCallback? onDelete;

  const MyInterestCard({
    super.key,
    this.photo,
    this.name,
    this.status,
    this.age,
    this.country,
    this.religion,
    this.motherTongue,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        boxShadow: [CommonWidget.box_shadow()],
      ),
      child: Row(
        children: [
          // Image section
          SizedBox(
            height: DeviceInfo(context).height,
            width: 84.0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
              child: MyImages.normalImage(photo),
            ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
                top: 16.0,
                right: 10.0,
                bottom: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  Text(name!,  style: Styles.regular_arsenic_14.copyWith(fontSize: 13),),

                  const SizedBox(height: 4),

                  // Age and Country row
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${age.toString()} years",
                          style: Styles.regular_arsenic_14.copyWith(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(country!,  style: Styles.regular_arsenic_14.copyWith(fontSize: 12),),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Religion and Mother Tongue row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          religion!,
                          style: Styles.regular_arsenic_14.copyWith(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          motherTongue!,
                          style: Styles.regular_arsenic_14.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Status and Delete section (right side)
          Container(
            width: 80,
            decoration: const BoxDecoration(
              // color: Colors.red,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Status badge (Pending)
                Container(
                  decoration: BoxDecoration(
                    color:
                        status! == "Approved"
                            ? MyTheme.medium_sea_green
                            : MyTheme.very_light_grey,
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(status!, style: Styles.bold_white_10),
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
