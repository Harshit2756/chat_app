import 'dart:io';

import 'package:chat_app/app/data/models/network/chat/message_model.dart';
import 'package:chat_app/app/data/services/local_db/storage_keys.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../../core/utils/helpers/logger.dart';
import '../../../data/models/network/chat/image_model.dart';
import '../../../data/models/response_model.dart';
import '../../../data/repositories/base_repository.dart';
import '../../../data/services/local_db/storage_service.dart';
import '../../../data/services/network_db/api_endpoint.dart';
import '../../../data/services/network_db/api_service.dart';

class ChatRepository extends BaseRepository {
  final StorageService _storageService = Get.find<StorageService>();
  final ApiService _apiService = Get.find<ApiService>();

  /// Get Messages
  Future<ResponseModel<List<MessageModel>>> getMessages() async {
    try {
      final response = await _apiService.get<List<dynamic>>(ApiEndpoints.getMessages);

      if (response.success && response.data != null) {
        final responseData = response.data as List<dynamic>;
        final List<MessageModel> messages = transformList(responseData, MessageModel.fromJson);
        _storageService.write(StorageKeys.messageList, messages);
        HLoggerHelper.info("Messages: ${messages.length}");
        return ResponseModel.success(messages, "");
      }

      return ResponseModel.error(response.message ?? 'Failed to get messages');
    } catch (e) {
      HLoggerHelper.error("Error fetching messages: $e");
      return ResponseModel.error("Error fetching messages: $e");
    }
  }

  /// Send Message
  Future<ResponseModel> sendMessage(String message) async {
    try {
      final response = await _apiService.post<dynamic>(ApiEndpoints.sendMessage, {'message': message});
      if (response.success && response.data != null) {
        return ResponseModel.success(response.data, "");
      }
      return ResponseModel.error(response.message ?? 'Failed to send message');
    } catch (e) {
      HLoggerHelper.error("Send message failed: $e");
      return ResponseModel.error("Send message failed: $e");
    }
  }

  /// Send Image
  Future<ResponseModel<ImageModel>> sendImage(File imageFile, [String message = '']) async {
    try {
      // Create FormData for multipart request
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: fileName, contentType: DioMediaType('image', 'jpeg')),
        if (message.isNotEmpty) 'message': message,
      });

      HLoggerHelper.info("Sending image: ${imageFile.path}");

      // Send multipart request with formData
      final response = await _apiService.postFormData<dynamic>(ApiEndpoints.sendImage, formData);

      if (response.success && response.data != null) {
        HLoggerHelper.info("Image uploaded successfully: ${response.data}");
        ImageModel imageModel = ImageModel.fromJson(response.data);
        return ResponseModel.success(imageModel, "Image sent successfully");
      }

      return ResponseModel.error(response.message ?? 'Failed to send image');
    } catch (e) {
      HLoggerHelper.error("Send image failed: $e");
      return ResponseModel.error("Failed to send image: $e");
    }
  }
}
