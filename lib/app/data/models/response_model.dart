import 'pagination_model.dart';

/// Generic API response model
///
/// Purpose:
/// - Standardize API responses
/// - Handle success/error states
/// - Parse API data
/// - Handle pagination data

class ResponseModel<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  final PaginationModel? pagination;

  ResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.pagination,
  });

  factory ResponseModel.error(String message, [int? statusCode]) => ResponseModel(
        success: false,
        message: message,
        statusCode: statusCode,
      );

  factory ResponseModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      statusCode: json['status_code'],
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : null,
      pagination: json['pagination'] != null ? PaginationModel.fromJson(json['pagination']) : null,
    );
  }

  factory ResponseModel.success(T data, String message) => ResponseModel(
        success: true,
        data: data,
        message: message,
        statusCode: 200,
      );
}
