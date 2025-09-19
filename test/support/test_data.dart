import 'package:holo_mobile_coding_challenge/features/cart/data/models/cart_item_dto.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/entities/cart_item.dart';
import 'package:holo_mobile_coding_challenge/features/products/data/models/product_dto.dart';
import 'package:holo_mobile_coding_challenge/features/products/data/models/product_rating_dto.dart';
import 'package:holo_mobile_coding_challenge/features/products/domain/entities/product.dart';

ProductDto makeProductDto({int id = 1}) => ProductDto(
  id: id,
  title: 'Test Product $id',
  price: 29.99 + id,
  description: 'Description $id',
  category: 'category',
  image: 'https://example.com/image.png',
  rating: ProductRatingDto(rate: 4.5, count: 120),
);

Product makeProduct({int id = 1}) => makeProductDto(id: id).toDomain();

CartItemDto makeCartItemDto({int id = 1, int quantity = 1}) => CartItemDto(
  product: makeProductDto(id: id),
  quantity: quantity,
);

CartItem makeCartItem({int id = 1, int quantity = 1}) => CartItem(
  product: makeProduct(id: id),
  quantity: quantity,
);
