import 'package:chat_app/core/utils/constants/sizes.dart';
import 'package:chat_app/core/widgets/buttons/custom_button.dart';
import 'package:chat_app/core/widgets/inputs/text_field.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/helpers/logger.dart';
import '../../../../core/utils/media/text_strings.dart';
import '../../../../core/utils/theme/colors.dart';
import '../controller/sign_up_controller.dart';

class SignUpFormView extends StatelessWidget {
  const SignUpFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(HSizes.md16),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sign up
                  Text('Sign Up', style: TextStyle(fontFamily: GoogleFonts.cherrySwash().fontFamily, fontWeight: FontWeight.w700, fontSize: 40, color: HColors.textPrimary)),
                  const SizedBox(height: HSizes.sm8),
                  Text('Please enter your credentials to proceed ', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: HColors.textPrimary)),
                  const SizedBox(height: HSizes.spaceBtwSections32),
                  // Name
                  HTextField(
                    type: TextFieldType.name,
                    focusNode: controller.nameFocusNode,
                    controller: controller.nameController,
                    onFieldSubmitted: (value) {
                      controller.nameFocusNode.unfocus();
                      controller.phoneFocusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),
                  // Phone Field
                  HTextField(
                    type: TextFieldType.mobile,
                    controller: controller.phoneController,
                    focusNode: controller.phoneFocusNode,
                    onFieldSubmitted: (value) {
                      controller.nameFocusNode.unfocus();
                      controller.phoneFocusNode.requestFocus();
                    },
                    // onPhoneNumberChanged: controller.onPhoneNumberChanged,
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),
                  // Email Field
                  HTextField(
                    type: TextFieldType.email,
                    focusNode: controller.emailFocusNode,
                    controller: controller.emailController,
                    onFieldSubmitted: (value) {
                      controller.emailFocusNode.unfocus();
                    },
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),
                  Obx(
                    () => HTextField(
                      type: TextFieldType.password,
                      focusNode: controller.passwordFocusNode,
                      controller: controller.passwordController,
                      isPasswordVisible: controller.hidePassword.value,
                      onIconTap: () => controller.togglePasswordVisibility(),
                      onFieldSubmitted: (value) {
                        controller.passwordFocusNode.unfocus();
                      },
                    ),
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),
                  // Address Field
                  HTextField(
                    type: TextFieldType.general,
                    hintText: HTexts.address,
                    labelText: HTexts.address,
                    maxLines: 3,
                    focusNode: controller.addressFocusNode,
                    controller: controller.addressController,
                    onFieldSubmitted: (value) {
                      controller.addressFocusNode.unfocus();
                    },
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),
                  CSCPicker(
                    showStates: true,
                    showCities: true,
                    flagState: CountryFlag.DISABLE,
                    labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w800),

                    selectedItemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.transparent, border: Border.all(color: HColors.borderSecondary)),
                    disabledDropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.transparent, border: Border.all(color: HColors.borderSecondary)),
                    countrySearchPlaceholder: "Search Country",
                    stateSearchPlaceholder: "Search State",
                    citySearchPlaceholder: "Search City",
                    countryDropdownLabel: "Country",
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",

                    // Styling
                    selectedItemStyle: TextStyle(color: HColors.textPrimary, fontWeight: FontWeight.w600),
                    unselectedItemStyle: TextStyle(color: HColors.textTertiary, fontWeight: FontWeight.w600),
                    dropdownHeadingStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: HColors.textPrimary, fontWeight: FontWeight.bold),
                    dropdownItemStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: HColors.textSecondary),
                    dropdownDialogRadius: 12.0,
                    searchBarRadius: 12.0,
                    layout: Layout.vertical,
                    onCountryChanged: (value) => controller.countryController.text = value,
                    onStateChanged: (value) => controller.stateController.text = value ?? '',
                    onCityChanged: (value) => controller.cityController.text = value ?? '',
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),
                  // PostalCode
                  HTextField(
                    type: TextFieldType.pinCode,
                    controller: controller.postalCodeController,
                    focusNode: controller.postalCodeFocusNode,
                    onFieldSubmitted: (value) {
                      controller.addressFocusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),

                  // My Date of birth:
                  HTextField(
                    type: TextFieldType.date,
                    controller: controller.birthController,
                    hintText: 'Select',
                    labelText: 'My date of birth:',
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000), // Start with year 2000
                        firstDate: DateTime(1950), // Allow dates from 1950
                        lastDate: DateTime.now(), // Up to today
                      );
                      if (picked != null) {
                        // Use DateFormat from intl package to format as dd/MM/yyyy
                        controller.birthController.text = DateFormat('dd/MM/yyyy').format(picked);
                        HLoggerHelper.info('Date: ${controller.birthController.text}');
                      }
                    },
                  ),

                  const SizedBox(height: HSizes.spaceBtwInputFields16),
                  // Gender:
                  HTextField(
                    type: TextFieldType.general,
                    labelText: 'Gender:',
                    textflied: Wrap(
                      spacing: HSizes.sm8,
                      children: [
                        // Male option
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Radio<String>(
                                value: 'Male',
                                groupValue: controller.genderValue.value,
                                onChanged: (value) {
                                  controller.genderValue.value = value!;
                                  controller.genderController.text = value;
                                },
                              ),
                            ),
                            const Text('Male'),
                          ],
                        ),
                        // Female option
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Radio<String>(
                                value: 'Female',
                                groupValue: controller.genderValue.value,
                                onChanged: (value) {
                                  controller.genderValue.value = value!;
                                  controller.genderController.text = value;
                                },
                              ),
                            ),
                            const Text('Female'),
                          ],
                        ),
                        // Prefer not to say option
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Radio<String>(
                                value: 'Prefer not to say',
                                groupValue: controller.genderValue.value,
                                onChanged: (value) {
                                  controller.genderValue.value = value!;
                                  controller.genderController.text = value;
                                },
                              ),
                            ),
                            const Text('Prefer not to say'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: HSizes.spaceBtwInputFields16),

                  Obx(() => CustomButton(text: 'Sign Up', isLoading: controller.isLoading.value, onPressed: controller.signUp)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
