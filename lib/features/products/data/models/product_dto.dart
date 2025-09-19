import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/product.dart';
import 'product_rating_dto.dart';

part 'product_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductDto.fromJson(JsonMap json) => _$ProductDtoFromJson(json);

  factory ProductDto.fromDomain(Product product) => ProductDto(
    id: product.id,
    title: product.title,
    price: product.price,
    description: product.description,
    category: product.category,
    image: product.imageUrl,
    rating: ProductRatingDto(rate: product.rating, count: product.ratingCount),
  );

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final ProductRatingDto rating;

  JsonMap toJson() => _$ProductDtoToJson(this);

  Product toDomain() => Product(
    id: id,
    title: title,
    price: price,
    description: description,
    category: category,
    imageUrl: image,
    rating: rating.rate,
    ratingCount: rating.count,
  );
}
