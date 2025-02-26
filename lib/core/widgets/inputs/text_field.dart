import 'package:chat_app/core/utils/constants/extension/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../utils/media/icons_strings.dart';
import '../../utils/media/text_strings.dart';
import '../../utils/theme/widget_themes/input_decoration.dart';

class HTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextFieldType type;
  final bool? isPasswordVisible;
  final bool toValidate;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap, onIconTap;
  final String? hintText;
  final bool isStartDate;
  final TextInputType? keyboardType;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final int maxLines;
  final Widget? textflied;
  HTextField({
    super.key,
    this.focusNode,
    required this.type,
    this.validator,
    this.toValidate = true,
    this.isPasswordVisible,
    this.onFieldSubmitted,
    this.onIconTap,
    this.textflied,
    this.controller,
    this.hintText,
    this.isStartDate = true,
    this.readOnly = false,
    this.keyboardType,
    this.maxLines = 1,
    this.labelText,
    this.onTap,
  });

  final RxBool isFocused = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextInputType? keyboardType = this.keyboardType;
    String? labelText = this.labelText;
    Widget? textflied = this.textflied;
    Widget? suffixIcon;
    FormFieldValidator<String>? validator = this.validator;
    List<TextInputFormatter>? inputFormatters;

    switch (type) {
      case TextFieldType.date:
        keyboardType = TextInputType.datetime;
        labelText = labelText ?? (isStartDate ? HTexts.startDate : HTexts.endDate);
        validator = validator ?? (value) => value?.validateDate();
        break;
      case TextFieldType.email:
        keyboardType = TextInputType.emailAddress;
        labelText = labelText ?? HTexts.email;
        validator = validator ?? (value) => value?.validateEmail();
        break;
      case TextFieldType.general:
        break;
      case TextFieldType.mobile:
        labelText = labelText ?? HTexts.phoneNo;
        textflied = Obx(() {
          return Focus(
            onFocusChange: (focus) => isFocused.value = focus,
            child: IntlPhoneField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              validator: (value) => value?.number.validateNumeric(HTexts.phoneNo),
              focusNode: focusNode,
              controller: controller,
              decoration: HInputDecorations.phoneInputDecoration(hintText: HTexts.phoneNo, isFocused: isFocused.value),
              initialCountryCode: 'IN',
              onSubmitted: onFieldSubmitted,
            ),
          );
        });
        break;

      case TextFieldType.name:
        keyboardType = TextInputType.name;
        labelText = labelText ?? HTexts.fullName;
        validator = validator ?? (value) => value?.validateAlphaWithSpace(HTexts.fullName);

        break;
      case TextFieldType.password:
        keyboardType = TextInputType.visiblePassword;
        labelText = labelText ?? HTexts.password;

        suffixIcon = IconButton(icon: Icon(isPasswordVisible ?? false ? HIcons.visibility : HIcons.visibilityOff), onPressed: onIconTap);
        validator = toValidate ? validator ?? (value) => value?.validatePassword() : null;
        break;
      case TextFieldType.pinCode:
        inputFormatters = [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)];
        keyboardType = TextInputType.number;
        labelText = labelText ?? HTexts.postalCode;
        validator = validator ?? (value) => value?.validateNumeric(labelText ?? HTexts.postalCode);

        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText ?? '', style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),

        textflied ??
            Obx(
              () => Focus(
                onFocusChange: (focus) => isFocused.value = focus,
                child: TextFormField(
                  onTap: onTap,
                  readOnly: readOnly,
                  maxLines: maxLines,
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: keyboardType,
                  onFieldSubmitted: onFieldSubmitted,
                  inputFormatters: inputFormatters,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: toValidate ? validator : null,
                  obscureText: type == TextFieldType.password && !(isPasswordVisible ?? false),
                  obscuringCharacter: '●',
                  decoration: HInputDecorations.defaultDecoration(hintText: hintText ?? labelText, suffixIcon: suffixIcon, isFocused: isFocused.value),
                ),
              ),
            ),
      ],
    );
  }
}

enum TextFieldType { date, email, general, mobile, name, password, pinCode }
