import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../widgets/loading/shimmer/shimmer_container.dart';
import '../constants/sizes.dart';
import '../media/icons_strings.dart';
import '../theme/colors.dart';

class HHelperFunctions {
  // List<T> transformList<T>(
  //     List data, T Function(Map<String, dynamic>) fromJson) {
  //   return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  // }

  static void showImagePreview(BuildContext context, String imagePath, {bool isFile = true}) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(HSizes.cardRadiusLg16),
                    child:
                        isFile
                            ? Image.file(File(imagePath), fit: BoxFit.contain)
                            : CachedNetworkImage(
                              imageUrl: imagePath,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const ShimmerContainer.rectangular(width: double.infinity, height: double.infinity),
                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, color: HColors.error)),
                            ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(color: HColors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
                  child: IconButton(icon: const Icon(HIcons.close, color: HColors.white), onPressed: () => Navigator.pop(context), tooltip: 'Close preview'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
