import 'package:active_matrimonial_flutter_app/components/common_app_bar_manageprofile.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import '../../components/common_input.dart';
import '../../redux/libs/drop_down/astronomic_dropdown_middleware.dart';
import '../../redux/libs/manage_profile/manage_profile_middleware/manage_profile_update_middlewares.dart';

class AstronomicInformation extends StatefulWidget {
  const AstronomicInformation({super.key});

  @override
  State<AstronomicInformation> createState() => _AstronomicInformationState();
}

class _AstronomicInformationState extends State<AstronomicInformation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();

  String? _sunSignValue;
  String? _moonSignValue;
  String? _nakshatraValue;
  String? _ganaValue;
  String? _nadiValue;
  String? _manglikValue;

  @override
  void initState() {
    super.initState();
    store.dispatch(astronomicDropdownMiddleware());

    final savedData =
        store
            .state
            .manageProfileCombineState
            ?.astronomicState
            ?.astronomicGetResponse
            ?.data;

    if (savedData != null) {
      _timeController.text = savedData.timeOfBirth?.toString() ?? "";
      store
          .state
          .manageProfileCombineState!
          .astronomicState!
          .cityOfBirthController
          .text = savedData.cityOfBirth?.toString() ?? "";

      _sunSignValue =
          savedData.sunSign?.isNotEmpty == true ? savedData.sunSign : null;
      _moonSignValue =
          savedData.moonSign?.isNotEmpty == true ? savedData.moonSign : null;
      _nakshatraValue =
          savedData.nakshatra?.isNotEmpty == true ? savedData.nakshatra : null;
      _ganaValue = savedData.gana?.isNotEmpty == true ? savedData.gana : null;
      _nadiValue = savedData.nadi?.isNotEmpty == true ? savedData.nadi : null;
      _manglikValue =
          savedData.manglik?.isNotEmpty == true ? savedData.manglik : null;
    }
  }

  Widget _buildStandardDropdown({
    required String label,
    required String? selectedValue,
    required String hint,
    required List<dynamic>? items,
    required ValueChanged<String?> onChanged,
  }) {
    final safeItems = items ?? [];

    String getLabel(dynamic item) {
      if (item.runtimeType.toString() == 'AstronomicSignModel' ||
          item.runtimeType.toString() == 'Map<String, dynamic>') {
        try {
          return item.label ?? '';
        } catch (e) {
          try {
            return item['label']?.toString() ?? '';
          } catch (e) {
            return '';
          }
        }
      }
      return item.toString().toUpperCase();
    }

    String getValue(dynamic item) {
      if (item.runtimeType.toString() == 'AstronomicSignModel' ||
          item.runtimeType.toString() == 'Map<String, dynamic>') {
        try {
          return item.value ?? '';
        } catch (e) {
          try {
            return item['value']?.toString() ?? '';
          } catch (e) {
            return '';
          }
        }
      }
      return item.toString();
    }

    String displayHint = hint;
    if (selectedValue != null && safeItems.isNotEmpty) {
      final matchedItem = safeItems.firstWhere(
        (e) => getValue(e) == selectedValue,
        orElse: () => null,
      );
      if (matchedItem != null) {
        displayHint = getLabel(matchedItem);
      } else {
        displayHint = selectedValue;
      }
    } else if (safeItems.isEmpty) {
      displayHint = "Loading...";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label *", style: Styles.bold_arsenic_12),
        const SizedBox(height: 5),
        FormField<String>(
          initialValue: selectedValue,
          validator: (val) {
            if (selectedValue == null || selectedValue.isEmpty) {
              return "This field is required";
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Builder(
              builder: (BuildContext context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap:
                          safeItems.isEmpty
                              ? null
                              : () {
                                FocusManager.instance.primaryFocus?.unfocus();

                                final RenderBox renderBox =
                                    context.findRenderObject() as RenderBox;
                                final size = renderBox.size;
                                final position = renderBox.localToGlobal(
                                  Offset.zero,
                                );

                                showMenu<String>(
                                  context: context,
                                  color: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  position: RelativeRect.fromLTRB(
                                    position.dx + 10,
                                    position.dy + size.height + 2,
                                    MediaQuery.of(context).size.width -
                                        position.dx -
                                        size.width -
                                        0,
                                    0,
                                  ),
                                  items:
                                      safeItems.map((item) {
                                        return PopupMenuItem<String>(
                                          value: getValue(item),
                                          child: SizedBox(
                                            width: size.width - 30,
                                            child: Text(
                                              getLabel(item),
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ).then((value) {
                                  if (value != null) {
                                    onChanged(value);
                                    state.didChange(value);
                                  }
                                });
                              },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: MyTheme.solitude,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                state.hasError
                                    ? Colors.red
                                    : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                displayHint,
                                style: TextStyle(
                                  color:
                                      (selectedValue != null)
                                          ? Colors.black87
                                          : Colors.grey,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color:
                                  safeItems.isEmpty
                                      ? Colors.grey
                                      : MyTheme.gull_grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        final astronomicState =
            state.manageProfileCombineState!.astronomicState!;
        final dropdownData = astronomicState.astronomicDropdownResponse?.data;

        return Scaffold(
          appBar: CommonAppBarManageProfile(
            text: AppLocalizations.of(context)!.manage_profile_astronomic_info,
          ).build(context),
          body:
              astronomicState.isloading == true
                  ? Center(child: CommonWidget.circularIndicator)
                  : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: Const.kPaddingHorizontal,
                      vertical: Const.kPaddingVertical,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.manage_profile_your_astronomic_info,
                            style: Styles.bold_app_accent_14,
                          ),
                          const SizedBox(height: 25),

                          _buildStandardDropdown(
                            label: "Sun Sign",
                            selectedValue: _sunSignValue,
                            hint: "Select Sun Sign",
                            items: dropdownData?.sunSigns,
                            onChanged: (v) => setState(() => _sunSignValue = v),
                          ),

                          _buildStandardDropdown(
                            label: "Moon Sign",
                            selectedValue: _moonSignValue,
                            hint: "Select Moon Sign",
                            items: dropdownData?.moonSigns,
                            onChanged:
                                (v) => setState(() => _moonSignValue = v),
                          ),

                          _buildStandardDropdown(
                            label: "Nakshatra",
                            selectedValue: _nakshatraValue,
                            hint: "Select Nakshatra",
                            items: dropdownData?.nakshatras,
                            onChanged:
                                (v) => setState(() => _nakshatraValue = v),
                          ),

                          _buildStandardDropdown(
                            label: "Gana",
                            selectedValue: _ganaValue,
                            hint: "Select Gana",
                            items: dropdownData?.gana,
                            onChanged: (v) => setState(() => _ganaValue = v),
                          ),

                          _buildStandardDropdown(
                            label: "Nadi",
                            selectedValue: _nadiValue,
                            hint: "Select Nadi",
                            items: dropdownData?.nadi,
                            onChanged: (v) => setState(() => _nadiValue = v),
                          ),

                          _buildStandardDropdown(
                            label: "Manglik",
                            selectedValue: _manglikValue,
                            hint: "Select Manglik",
                            items: dropdownData?.manglik,
                            onChanged: (v) => setState(() => _manglikValue = v),
                          ),

                          buildtimeofbirth(context, state),
                          build_city_birth(context, state),

                          const SizedBox(height: 40),

                          InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState!.validate()) {
                                store.dispatch(
                                  astronomicUpdateMiddleware(
                                    sunsign: _sunSignValue,
                                    moonsign: _moonSignValue,
                                    time: _timeController.text,
                                    city:
                                        astronomicState
                                            .cityOfBirthController
                                            .text,
                                    nakshatra: _nakshatraValue,
                                    gana: _ganaValue,
                                    nadi: _nadiValue,
                                    manglik: _manglikValue,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 45,
                              width: DeviceInfo(context).width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    MyTheme.gradient_color_1,
                                    MyTheme.gradient_color_2,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child:
                                    astronomicState.pageloader == true
                                        ? CommonWidget.circularIndicator
                                        : Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.save_change_btn_text,
                                          style: Styles.bold_white_14,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }

  Widget buildtimeofbirth(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.manage_profile_time_of_birth} *",
          style: Styles.bold_arsenic_12,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _timeController,
          validator:
              (val) =>
                  val == null || val.isEmpty ? "This field is required" : null,
          decoration: InputStyle.inputDecoration_text_field(hint: "9.00 AM"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget build_city_birth(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.manage_profile_city_of_birth} *",
          style: Styles.bold_arsenic_12,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller:
              state
                  .manageProfileCombineState!
                  .astronomicState!
                  .cityOfBirthController,
          validator:
              (val) =>
                  val == null || val.isEmpty ? "This field is required" : null,
          decoration: InputStyle.inputDecoration_text_field(hint: "City"),
        ),
      ],
    );
  }
}
