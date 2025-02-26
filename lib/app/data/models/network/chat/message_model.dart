import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  MessageModel({required this.chatDetails, required this.userDetails});

  @JsonKey(name: 'Chat_details')
  final ChatDetails? chatDetails;

  @JsonKey(name: 'user_details')
  final UserDetails? userDetails;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  String toString() {
    return "$chatDetails, $userDetails, ";
  }
}

@JsonSerializable()
class ChatDetails {
  ChatDetails({required this.id, required this.userId, required this.image, required this.message, required this.createdAt, required this.updatedAt});

  final int id;

  @JsonKey(name: 'user_id')
  final String userId;
  final dynamic image;
  final String message;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  factory ChatDetails.fromJson(Map<String, dynamic> json) => _$ChatDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDetailsToJson(this);

  @override
  String toString() {
    return "$id, $userId, $image, $message, $createdAt, $updatedAt, ";
  }
}

@JsonSerializable()
class UserDetails {
  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String email;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String gender;
  final String address;
  final String city;
  final String state;

  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);

  @override
  String toString() {
    return "$id, $name, $email, $phoneNumber, $gender, $address, $city, $state, $dateOfBirth, $createdAt, $updatedAt, ";
  }
}

/*
{
	"Chat_details": {
		"id": 18,
		"user_id": "6",
		"image": null,
		"message": "Hiii On The Spot",
		"created_at": "2025-02-25T16:51:47.000000Z",
		"updated_at": "2025-02-25T16:51:47.000000Z"
	},
	"user_details": {
		"id": 6,
		"name": "Shyam Chauhan",
		"email": "shyam123@gmail.com",
		"phone_number": "7096827080",
		"gender": "male",
		"address": "adajan",
		"city": "surat",
		"state": "gujrat",
		"date_of_birth": "10/07/2002",
		"created_at": "2025-02-25T08:13:47.000000Z",
		"updated_at": "2025-02-25T08:13:47.000000Z"
	}
}*/
