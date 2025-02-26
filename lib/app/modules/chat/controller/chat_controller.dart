import 'dart:io';

import 'package:chat_app/app/data/models/network/chat/message_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/helpers/logger.dart';
import '../../../../core/widgets/snackbar/snackbars.dart';
import '../repository/chat_repository.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find<ChatController>();

  final ChatRepository _chatRepository = Get.put(ChatRepository());
  final ImagePicker _imagePicker = ImagePicker();

  final messages = <MessageModel>[].obs;
  final showEmoji = false.obs;
  final isLoading = false.obs;
  final textController = TextEditingController();

  // For image preview before sending
  final selectedImage = Rx<File?>(null);
  final isImagePickerOpen = false.obs;

  /// Functions
  /// Send Message
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty && selectedImage.value == null) return;

    try {
      isLoading.value = true;

      // If there's an image to send
      if (selectedImage.value != null) {
        await sendImageMessage(selectedImage.value!, message);
        selectedImage.value = null;
        return;
      }

      // Otherwise, send text message
      final response = await _chatRepository.sendMessage(message);
      HLoggerHelper.info('Message sent: $message');

      if (response.success && response.data != null) {
        HLoggerHelper.info('Message sent successfully');
        getAllMessages();
        HLoggerHelper.info('Messages: ${messages.length}');
      }
    } catch (e) {
      HLoggerHelper.error('Error sending message: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to send message');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get All Messages
  Future<void> getAllMessages() async {
    try {
      isLoading.value = true;
      final response = await _chatRepository.getMessages();

      if (response.data != null) {
        messages.value = response.data as List<MessageModel>;
        messages.sort((a, b) {
          final aDate = a.chatDetails?.createdAt;
          final bDate = b.chatDetails?.createdAt;
          if (aDate == null || bDate == null) return 0;
          return bDate.compareTo(aDate);
        });
      }

      HLoggerHelper.info('Messages: ${messages.length}');
    } catch (e) {
      HLoggerHelper.error('Error fetching messages: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to fetch messages');
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick Image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70, // Reduce image quality to save bandwidth
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        HLoggerHelper.info('Image selected: ${pickedFile.path}');
      }
    } catch (e) {
      HLoggerHelper.error('Error picking image: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to pick image');
    } finally {
      isImagePickerOpen.value = false;
    }
  }

  /// Send Image Message
  Future<void> sendImageMessage(File imageFile, [String message = '']) async {
    try {
      isLoading.value = true;
      final response = await _chatRepository.sendImage(imageFile, message);

      if (response.success) {
        HLoggerHelper.info('Image sent successfully');
        HSnackbars.showSnackbar(type: SnackbarType.success, message: 'Image sent successfully ');
        textController.clear();
        getAllMessages();
      } else {
        HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to send image: ${response.message}');
      }
    } catch (e) {
      HLoggerHelper.error('Error sending image: $e');
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to send image');
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear selected image
  void clearSelectedImage() {
    selectedImage.value = null;
  }

  @override
  void onInit() {
    super.onInit();
    getAllMessages();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
