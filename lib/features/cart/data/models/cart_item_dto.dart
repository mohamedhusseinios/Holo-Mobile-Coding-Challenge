import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/typedefs.dart';
import '../../../products/data/models/product_dto.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_item_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemDto {
  const CartItemDto({required this.product, required this.quantity});

  factory CartItemDto.fromJson(JsonMap json) => _$CartItemDtoFromJson(json);

  factory CartItemDto.fromDomain(CartItem item) => CartItemDto(
        product: ProductDto.fromDomain(item.product),
        quantity: item.quantity,
      );

  final ProductDto product;
  final int quantity;

  JsonMap toJson() => _$CartItemDtoToJson(this);

  CartItem toDomain() => CartItem(
        product: product.toDomain(),
        quantity: quantity,
      );
}
