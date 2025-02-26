import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return "$id, $name, $email, $phoneNumber, $gender, $address, $city, $state, $dateOfBirth, $createdAt, $updatedAt, ";
  }
}

/*
{
	"id": 1,
	"name": "Vraj2",
	"email": "Vraj883@gmail.com",
	"phone_number": "1234567880",
	"gender": "male",
	"address": "nvnmbhv",
	"city": "surat",
	"state": "gujrat",
	"date_of_birth": "01/01/2001",
	"created_at": "2025-02-22T06:34:26.000000Z",
	"updated_at": "2025-02-22T06:40:09.000000Z"
}*/
