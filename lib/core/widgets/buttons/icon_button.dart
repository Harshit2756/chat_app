import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final EdgeInsets? padding;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
    this.padding,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color ?? Theme.of(context).primaryColor,
      iconSize: size ?? 24,
      padding: padding ?? const EdgeInsets.all(8),
      tooltip: tooltip,
    );
  }
} 