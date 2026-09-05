import 'package:active_matrimonial_flutter_app/components/common_input.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/caste_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/city_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/state_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/sub_caste_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/search_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/show_basic_search.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import 'search_action.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({super.key});

  @override
  State<AdvancedSearch> createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  final _formKey = GlobalKey<FormState>();
  var _group_value = 2;

  // controllers
  final TextEditingController _ageFromController = TextEditingController();
  final TextEditingController _ageToController = TextEditingController();
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _minHeightController = TextEditingController();
  final TextEditingController _maxHeightController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _group_value = 2;
    });
    super.initState();
  }

  var marital_status_value;
  var religion_value;
  var caste_value;
  var sub_caste_value;

  var packages = ['Premium', 'Free', 'All'];

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return StoreConnector<AppState, AppState>(

      converter: (store) => store.state,
      //onInit: (store) => store.dispatch(profiledropdownMiddleware()),
      builder:
          (_, state) => Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Const.kPaddingHorizontal,
                  ),
                  child: Column(
                    children: [
                      // height from the notification bar
                    SizedBox(height: responsiveHeight*0.018),

                      Center(
                        child: SizedBox(
                          height: responsiveHeight*0.034,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icon/icon_search__.png'),
                               SizedBox(width: responsiveWidth*0.016),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.search_screen_title,
                                style: Styles.bold_app_accent_16,
                              ),
                            ],
                          ),
                        ),
                      ),

                       SizedBox(height: responsiveHeight*0.03),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildAgeFromTo(context),
                             SizedBox(height: responsiveHeight*0.012),
                            buildMemberId(context),
                             SizedBox(height: responsiveHeight*0.012),
                            buildMaritalReligion(context, state),
                             SizedBox(height: responsiveHeight*0.012),
                            buildCasteSubCaste(context, state),
                             SizedBox(height: responsiveHeight*0.012),
                            buildCountry(context, state),
                             SizedBox(height: responsiveHeight*0.012),
                            buildStateCity(context, state),
                             SizedBox(height: responsiveHeight*0.012),
                            buildMinMaxHeight(context),
                             SizedBox(height: responsiveHeight*0.012),
                            buildMemberType(context),
                             SizedBox(height: responsiveHeight*0.049),
                            buildSearchButton(context, state),
                             SizedBox(height: responsiveHeight*0.0369),
                            buildSwitchBasicSearch(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  TextButton buildSwitchBasicSearch(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        AppLocalizations.of(context)!.common_basic_search_switch,
        style: Styles.bold_app_accent_12,
      ),
    );
  }

  Widget buildSearchButton(BuildContext context, AppState state) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (!_formKey.currentState!.validate()) {

        } else {

          store.dispatch(Reset.search);

          store.dispatch(
            searchMiddleware(
              age: _ageFromController.text,
              to: _ageToController.text,
              memberCode: _memberIdController.text,
              maritalStatus: marital_status_value,
              religion: religion_value,
              caste: caste_value,
              subCaste: sub_caste_value,
              country: state.basicSearchState!.country_value,
              state: state.basicSearchState!.state_value,
              city: state.basicSearchState!.city_value,
              minHeight: _minHeightController.text,
              maxHeight: _maxHeightController.text,
              memberType: _group_value,
            ),
          );
          NavigatorPush.push(context, ShowBasicSearch());
        }
      },
      child: Container(
        height: responsiveHeight*0.0615,
        width: DeviceInfo(context).width,
        decoration: BoxDecoration(
          gradient: Styles.buildLinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius:  BorderRadius.all(Radius.circular(responsiveWidth*0.032)),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.advanced_search_screen_btn_text,
            style: Styles.bold_white_14,
          ),
        ),
      ),
    );
  }

  buildAgeFromTo(BuildContext context) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.search_secreen_age_from,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _ageFromController,
                decoration: InputStyle.inputDecoration_text_field(),
              ),
            ],
          ),
        ),
         SizedBox(width: responsiveWidth*0.0373),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.search_screen_to,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _ageToController,
                decoration: InputStyle.inputDecoration_text_field(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildMemberId(BuildContext context) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.common_screen_member_id,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              TextFormField(
                controller: _memberIdController,
                decoration: InputStyle.inputDecoration_text_field(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildMaritalReligion(BuildContext context, AppState state) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                )!.advanced_search_screen_marital_status,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveWidth*0.032),
                  color: MyTheme.solitude,
                ),
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth*0.026),
               // height: responsiveHeight*0.0615,
                child: CommonWidget().buildDropdownButtonFormField(context,
                  state
                      .manageProfileCombineState!
                      .profiledropdownResponseData!
                      .data!
                      .maritialStatus!,
                  (value) {
                    marital_status_value = value.id;
                  },
                ),
              ),
            ],
          ),
        ),
         SizedBox(width:responsiveWidth*0.0373),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.search_screen_religion,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveWidth*0.032),
                  color: MyTheme.solitude,
                ),
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth*0.026),
              //  height: responsiveHeight*0.0615,
                child: CommonWidget().buildDropdownButtonFormField(context,
                  state
                      .manageProfileCombineState!
                      .profiledropdownResponseData!
                      .data!
                      .religionList!,
                  (value) {
                    store.dispatch(
                      SearchAddReligionValueAction(value: value.id),
                    );

                    if (state
                        .basicSearchState!
                        .casteResponse!
                        .data!
                        .isNotEmpty) {
                      store.dispatch(SearchEmptyCaste());
                    }
                    if (state
                        .basicSearchState!
                        .subcasteResponse!
                        .data!
                        .isNotEmpty) {
                      store.dispatch(SearchEmptySubCaste());
                    }

                    store.dispatch(casteMiddleware(value.id));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildCasteSubCaste(BuildContext context, AppState state) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.advanced_search_screen_caste,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveWidth*0.032),
                  color: MyTheme.solitude,
                ),
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth*0.026),
               // height: responsiveHeight*0.0615,
                child: DropdownButtonFormField<dynamic>(
                  isExpanded: true,
                  iconSize: 0.0,
                  value: state.basicSearchState!.caste_value,
                  decoration: InputDecoration(
                    hintText: "Select One",
                    isDense: true,
                    hintStyle: Styles.regular_gull_grey_12,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: MyTheme.gull_grey,
                    ),
                    // helperText: 'Helper text',
                  ),
                  items:
                      state.basicSearchState!.casteResponse!.data!
                          .map<DropdownMenuItem<dynamic>>((e) {
                            return DropdownMenuItem<dynamic>(
                              value: e.id,
                              child: Text(
                                e.name!,
                                style: Styles.regular_gull_grey_12,
                              ),
                            );
                          })
                          .toList(),
                  onChanged: (dynamic newValue) {
                    store.dispatch(SearchAddCasteValueAction(value: newValue));

                    if (state
                        .basicSearchState!
                        .subcasteResponse!
                        .data!
                        .isNotEmpty) {
                      store.dispatch(SearchEmptySubCaste());
                    }

                    store.dispatch(subcasteMiddleware(newValue));
                  },
                ),
              ),
            ],
          ),
        ),
         SizedBox(width: responsiveWidth*0.0373),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.advanced_search_screen_sub_caste,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveWidth*0.032),
                  color: MyTheme.solitude,
                ),
                padding: EdgeInsets.symmetric(horizontal:responsiveWidth*0.026 ),
                height: responsiveHeight*0.0615,
                child: DropdownButtonFormField<dynamic>(
                  isExpanded: true,
                  iconSize: 0.0,
                  value: state.basicSearchState!.sub_caste_value,
                  decoration: InputDecoration(
                    hintText: "Select One",
                    isDense: true,
                    hintStyle: Styles.regular_gull_grey_12,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: MyTheme.gull_grey,
                    ),
                    // helperText: 'Helper text',
                  ),
                  items:
                      state.basicSearchState!.subcasteResponse!.data!
                          .map<DropdownMenuItem<dynamic>>((e) {
                            return DropdownMenuItem<dynamic>(
                              value: e.id,
                              child: Text(
                                e.name!,
                                style: Styles.regular_gull_grey_12,
                              ),
                            );
                          })
                          .toList(),
                  onChanged: (dynamic newValue) {
                    store.dispatch(
                      SearchAddSubCasteValueAction(value: newValue),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildCountry(BuildContext context, AppState state) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.advanced_search_screen_country,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height:responsiveHeight*0.00615 ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveWidth*0.032),
                  color: MyTheme.solitude,
                ),
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth*0.026),
                height: responsiveHeight*0.0615,
                child: CommonWidget().buildDropdownButtonFormField(context,
                  state
                      .manageProfileCombineState!
                      .profiledropdownResponseData!
                      .data!
                      .countryList!,
                  (value) {
                    // country_value = value.id;
                    store.dispatch(
                      SearchCountryAddValueAction(value: value.id),
                    );

                    if (state
                        .basicSearchState!
                        .stateResponse!
                        .data!
                        .isNotEmpty) {
                      store.dispatch(SearchEmptyState());
                    }
                    if (state
                        .basicSearchState!
                        .cityResponse!
                        .data!
                        .isNotEmpty) {
                      store.dispatch(SearchEmptyCity());
                    }

                    store.dispatch(
                      stateMiddleware(
                        value.id,
                        state: AppStates.advancedSearch,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildStateCity(BuildContext context, AppState state) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.advanced_search_screen_state,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveWidth*0.032),
                  color: MyTheme.solitude,
                ),
                height: responsiveHeight*0.0615,
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth*0.026),
                child: DropdownButtonFormField<dynamic>(
                  isExpanded: true,
                  iconSize: 0.0,
                  value: state.basicSearchState!.state_value,
                  decoration: InputDecoration(
                    hintText: "Select One",
                    isDense: true,
                    hintStyle: Styles.regular_gull_grey_12,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: MyTheme.gull_grey,
                    ),
                    // helperText: 'Helper text',
                  ),
                  items:
                      state.basicSearchState!.stateResponse!.data!
                          .map<DropdownMenuItem<dynamic>>((e) {
                            return DropdownMenuItem<dynamic>(
                              value: e.id,
                              child: Text(
                                e.name!,
                                style: Styles.regular_gull_grey_12,
                              ),
                            );
                          })
                          .toList(),
                  onChanged: (dynamic newValue) {
                    store.dispatch(SearchStateAddValueAction(value: newValue));

                    if (state
                        .basicSearchState!
                        .cityResponse!
                        .data!
                        .isNotEmpty) {
                      store.dispatch(SearchEmptyCity());
                    }

                    store.dispatch(
                      cityMiddleware(newValue, AppStates.advancedSearch),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
         SizedBox(width: responsiveWidth*0.0373),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.advanced_search_screen_city,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveWidth*0.032),
                  color: MyTheme.solitude,
                ),
                height: responsiveHeight*0.0615,
                padding:  EdgeInsets.symmetric(horizontal: responsiveWidth*0.026),
                child: DropdownButtonFormField<dynamic>(
                  isExpanded: true,
                  iconSize: 0.0,
                  decoration: InputDecoration(
                    hintText: "Select One",
                    isDense: true,
                    hintStyle: Styles.regular_gull_grey_12,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: MyTheme.gull_grey,
                    ),
                    // helperText: 'Helper text',
                  ),
                  value: state.basicSearchState!.city_value,
                  items:
                      state.basicSearchState!.cityResponse!.data!
                          .map<DropdownMenuItem<dynamic>>((e) {
                            return DropdownMenuItem<dynamic>(
                              value: e.id,
                              child: Text(
                                e.name!,
                                style: Styles.regular_gull_grey_12,
                              ),
                            );
                          })
                          .toList(),
                  onChanged: (dynamic newValue) {
                    store.dispatch(SearchCityAddValueAction(value: newValue));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildMinMaxHeight(BuildContext context) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.advanced_search_screen_min_height,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              TextFormField(
                controller: _minHeightController,
                decoration: InputStyle.inputDecoration_text_field(),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
         SizedBox(width: responsiveWidth*0.0373),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.advanced_search_screen_max_height,
                style: Styles.bold_app_accent_12,
              ),
               SizedBox(height: responsiveHeight*0.00615),
              TextFormField(
                controller: _maxHeightController,
                decoration: InputStyle.inputDecoration_text_field(),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildMemberType(BuildContext context) {
    final responsiveHeight = MediaQuery.of(context).size.height;
    final responsiveWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.advanced_search_screen_member_type,
          style: Styles.bold_app_accent_12,
        ),
         SizedBox(height: responsiveHeight*0.00615),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(
                  value: 0,
                  groupValue: _group_value,
                  onChanged: (dynamic value) {
                    setState(() {
                      _group_value = 0;
                    });
                  },
                ),
                Text(
                  AppLocalizations.of(context)!.advanced_search_screen_premium,
                ),
              ],
            ),
             SizedBox(width: responsiveWidth*0.026),
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: _group_value,
                  onChanged: (dynamic value) {
                    setState(() {
                      _group_value = 1;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)!.advanced_search_screen_free),
              ],
            ),
             SizedBox(width: responsiveWidth*0.026),
            Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: _group_value,
                  onChanged: (dynamic value) {
                    setState(() {
                      _group_value = 2;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)!.advanced_search_screen_all),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
