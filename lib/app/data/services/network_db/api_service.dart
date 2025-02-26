/// API service for managing API communications
///
/// Purpose:
/// - Handle API configuration
/// - Manage API state
/// - Provide API utilities
library;

import 'dart:async';

import 'package:chat_app/core/utils/helpers/logger.dart';
import 'package:chat_app/core/widgets/snackbar/snackbars.dart';
import 'package:dio/dio.dart';

import '../../models/response_model.dart';
import '../base_service.dart';

class ApiService extends BaseService {
  final Duration timeout;
  final ErrorHandlerService _errorHandler = ErrorHandlerService();
  final Dio _dio;

  ApiService({this.timeout = const Duration(seconds: 90)})
    : _dio = Dio(
        BaseOptions(
          connectTimeout: timeout,
          receiveTimeout: timeout,
          sendTimeout: timeout,
          validateStatus: (status) => true,
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        ),
      );

  /// DELETE request
  Future<ResponseModel<T>> delete<T>(String endpoint) async => _performRequest(() => _dio.delete<Map<String, dynamic>>(endpoint), 'DELETE', endpoint);

  /// GET request
  Future<ResponseModel<T>> get<T>(String endpoint, {Map<String, dynamic>? queryParams}) async =>
      _performRequest(() => _dio.get<Map<String, dynamic>>(endpoint, queryParameters: queryParams), 'GET', endpoint, queryParams);

  /// POST request
  Future<ResponseModel<T>> post<T>(String endpoint, Map<String, dynamic>? body) async => _performRequest(() => _dio.post<Map<String, dynamic>>(endpoint, data: body), 'POST', endpoint, body);

  /// POST request with FormData
  Future<ResponseModel<T>> postFormData<T>(String endpoint, FormData body) async => _performRequest(() => _dio.post<Map<String, dynamic>>(endpoint, data: body), 'POST FORM', endpoint, body);

  /// PUT request
  Future<ResponseModel<T>> put<T>(String endpoint, Map<String, dynamic> body) async => _performRequest(() => _dio.put<Map<String, dynamic>>(endpoint, data: body), 'PUT', endpoint, body);

  /// PUT request with FormData
  Future<ResponseModel<T>> putFormData<T>(String endpoint, FormData body) async => _performRequest(() => _dio.put<Map<String, dynamic>>(endpoint, data: body), 'PUT FORM', endpoint, body);

  /// Handles API request execution with logging & error handling
  Future<ResponseModel<T>> _performRequest<T>(Future<Response<Map<String, dynamic>>> Function() request, String method, String endpoint, [dynamic body]) async {
    _dio.options.headers['Content-Type'] = body is FormData ? 'multipart/form-data' : 'application/json';
    HLoggerHelper.info('$method<$T> Request to URL: $endpoint \nBody: $body \nHeaders: ${_dio.options.headers}');

    try {
      final response = await request();
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Sets authentication token
  void setAuthToken(String token) {
    if (token.isEmpty) {
      HLoggerHelper.warning('Warning: Empty token provided');
      return;
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    HLoggerHelper.info('Auth token set: ${_dio.options.headers}');
  }

  /// Handles API response
  ResponseModel<T> _handleResponse<T>(Response<Map<String, dynamic>> response) {
    if ((response.statusCode ?? 500) >= 200 && (response.statusCode ?? 500) < 300) {
      HLoggerHelper.info('Successful Response Data: ${response.data}');
      final data = response.data;
      if (data == null) {
        HLoggerHelper.warning('Warning: Response data is null');
        return ResponseModel.error('Invalid response data');
      }

      // For authentication endpoints that return token
      if (data.containsKey('token')) {
        return ResponseModel(success: true, message: data['message'] as String?, data: data['token'] as T);
      }

      // For regular endpoints with data key
      final responseData = data.containsKey('data') ? data['data'] as T : data as T;
      final success = data.containsKey('status') ? data['status'] == 'true' : data.containsKey('url');
      return ResponseModel(success: success, message: data['message'] as String?, data: responseData);
    } else {
      HLoggerHelper.error('Error Response Data: ${response.data}');
      final error = _errorHandler.handleHttpError(response.statusCode ?? 500, response.data);
      HSnackbars.showSnackbar(type: SnackbarType.error, message: error);
      return ResponseModel<T>.error(error);
    }
  }

  /// Handles API errors
  Exception _handleError(dynamic error) {
    _errorHandler.logError(error);
    String errorMessage = 'An unexpected error occurred';

    if (error is DioException && error.response != null) {
      errorMessage = error.response?.data['message'] ?? errorMessage;
      HLoggerHelper.error('DioException: Type: ${error.type}, Status: ${error.response?.statusCode}, Message: $errorMessage');
    }

    HSnackbars.showSnackbar(type: SnackbarType.error, message: errorMessage);
    return Exception(errorMessage);
  }
}

/// Handles API errors and logging
class ErrorHandlerService {
  String handleHttpError(int statusCode, dynamic responseBody) {
    return responseBody['message'] ?? _defaultErrorMessages[statusCode] ?? 'An error occurred';
  }

  void logError(dynamic e) {
    if (e is DioException) {
      HLoggerHelper.error('DioException: Type: ${e.type}, Message: ${e.message}, Status: ${e.response?.statusCode}');
      if (e.response != null) {
        HLoggerHelper.error('Response Data: ${e.response?.data}, Headers: ${e.response?.headers}');
      }
    }
  }

  static const Map<int, String> _defaultErrorMessages = {400: 'Bad request', 401: 'Unauthorized', 403: 'Forbidden', 404: 'Not found', 500: 'Internal server error'};
}
