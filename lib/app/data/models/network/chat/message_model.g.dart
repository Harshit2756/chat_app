// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  chatDetails:
      json['Chat_details'] == null
          ? null
          : ChatDetails.fromJson(json['Chat_details'] as Map<String, dynamic>),
  userDetails:
      json['user_details'] == null
          ? null
          : UserDetails.fromJson(json['user_details'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'Chat_details': instance.chatDetails,
      'user_details': instance.userDetails,
    };

ChatDetails _$ChatDetailsFromJson(Map<String, dynamic> json) => ChatDetails(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String,
  image: json['image'],
  message: json['message'] as String,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ChatDetailsToJson(ChatDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'image': instance.image,
      'message': instance.message,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phone_number'] as String,
  gender: json['gender'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  dateOfBirth: json['date_of_birth'] as String,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'gender': instance.gender,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'date_of_birth': instance.dateOfBirth,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
