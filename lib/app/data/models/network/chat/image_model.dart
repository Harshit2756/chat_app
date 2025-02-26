import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel {
  ImageModel({required this.url, required this.halfUrl});

  final String url;

  @JsonKey(name: 'half_url')
  final String halfUrl;

  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  @override
  String toString() {
    return "$url, $halfUrl, ";
  }
}

/*
{
	"url": "https://spell.theanantkaal.com/uploads/chat/1740563792_WhatsApp Image 2025-01-14 at 10.33.07_bd719c04.jpg",
	"half_url": "uploads/chat/1740563792_WhatsApp Image 2025-01-14 at 10.33.07_bd719c04.jpg"
}*/
