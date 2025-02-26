import 'package:chat_app/core/utils/constants/sizes.dart';
import 'package:chat_app/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? bgColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? prefix;
  final Widget? suffix;
  final bool isSecondaryButton;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.bgColor,
    this.padding,
    this.margin,
    this.prefix,
    this.suffix,
    this.isSecondaryButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonContent =
        isLoading
            ? const SizedBox(
              height: HSizes.circularProgressIndicatorSize20,
              width: HSizes.circularProgressIndicatorSize20,
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(HColors.black), strokeWidth: HSizes.circularProgressIndicatorStrokeWidth2),
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefix != null) ...[prefix!, const SizedBox(width: HSizes.sm8)],
                Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: isSecondaryButton ? HColors.black : HColors.white)),
                if (suffix != null) ...[const SizedBox(width: HSizes.sm8), suffix!],
              ],
            );

    // Button style
    final buttonStyle = Theme.of(context).elevatedButtonTheme.style?.copyWith(
      side: WidgetStateProperty.all(BorderSide(color: borderColor ?? (isSecondaryButton ? (bgColor ?? HColors.primary) : HColors.transparent), width: 1.5)),
      backgroundColor: WidgetStateProperty.all(isSecondaryButton ? HColors.white : (bgColor ?? HColors.primary)),
      padding: WidgetStateProperty.all(padding),
    );

    // Base button
    Widget button = SizedBox(width: width ?? double.infinity, height: height, child: ElevatedButton(onPressed: isLoading ? null : onPressed, style: buttonStyle, child: buttonContent));

    // Apply margin if specified
    if (margin != null) {
      button = Padding(padding: margin!, child: button);
    }

    return button;
  }
}
