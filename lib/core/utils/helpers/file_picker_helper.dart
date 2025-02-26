import 'dart:io' show Platform;

import 'package:chat_app/core/utils/helpers/logger.dart';
import 'package:chat_app/core/widgets/snackbar/snackbars.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerHelper {
  final TextEditingController pdfController;
  final Rx<XFile?> documentFile;
  final Function(bool)? onLoadingChanged;

  FilePickerHelper({required this.pdfController, required this.documentFile, this.onLoadingChanged});

  Future<void> pickImage(ImageSource source) async {
    HLoggerHelper.info('Attempting to pick image from $source');

    // Check platform
    if (Platform.isAndroid) {
      // Check Android version
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final androidVersion = androidInfo.version.sdkInt;

      // Request appropriate permissions based on Android version
      if (source == ImageSource.camera) {
        PermissionStatus cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          HSnackbars.showSnackbar(type: SnackbarType.warning, message: 'Camera permission denied');
          HLoggerHelper.warning('Camera permission denied');
          openAppSettings();
          return;
        }
      }

      if (source == ImageSource.gallery) {
        if (androidVersion >= 33) {
          // For Android 13 and above
          PermissionStatus photosStatus = await Permission.photos.request();
          if (!photosStatus.isGranted) {
            HSnackbars.showSnackbar(type: SnackbarType.warning, message: 'Photos permission denied');
            HLoggerHelper.warning('Photos permission denied');
            openAppSettings();
            return;
          }
        } else {
          // For Android 12 and below
          PermissionStatus storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            HSnackbars.showSnackbar(type: SnackbarType.warning, message: 'Storage permission denied');
            HLoggerHelper.warning('Storage permission denied');
            openAppSettings();
            return;
          }
        }
      }
    }

    // Updated image picking code
    final XFile? pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 90, maxHeight: 700, maxWidth: 550);

    if (pickedFile != null) {
      final int fileSize = await pickedFile.length();

      // Ensure we're using proper path separators and handling paths correctly
      final String normalizedPath = pickedFile.path.replaceAll('\\', '/');
      HLoggerHelper.info('Image picked successfully: $normalizedPath\nImage size: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      // Use basename to get just the filename
      final String fileName = normalizedPath.split('/').last;
      pdfController.text = fileName;
      documentFile.value = XFile(normalizedPath);
    } else {
      HLoggerHelper.warning('No image selected');
    }
  }
}
