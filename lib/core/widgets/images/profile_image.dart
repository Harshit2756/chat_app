import 'package:flutter/material.dart';

import 'image.dart';

class ProfileImage extends StatelessWidget {
  final String? imageSource;
  final double radius;
  final Color? backgroundColor;
  final Widget? placeholder;

  const ProfileImage({
    super.key,
    this.imageSource,
    this.radius = 50,
    this.backgroundColor,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      child: ClipOval(
        child: HImageWidget(
          source: imageSource,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: placeholder,
        ),
      ),
    );
  }
}
