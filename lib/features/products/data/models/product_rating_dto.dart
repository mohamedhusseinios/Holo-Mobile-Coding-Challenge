import 'package:json_annotation/json_annotation.dart';

part 'product_rating_dto.g.dart';

@JsonSerializable()
class ProductRatingDto {
  const ProductRatingDto({required this.rate, required this.count});

  factory ProductRatingDto.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingDtoFromJson(json);

  final double rate;
  final int count;

  Map<String, dynamic> toJson() => _$ProductRatingDtoToJson(this);
}
