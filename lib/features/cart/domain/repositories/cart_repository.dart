import '../../../../core/utils/result.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart_item.dart';

abstract interface class CartRepository {
  ResultFuture<List<CartItem>> getCart();
  ResultFuture<List<CartItem>> addItem(Product product, {int quantity});
  ResultFuture<List<CartItem>> updateQuantity(int productId, int quantity);
  ResultFuture<List<CartItem>> removeItem(int productId);
  ResultFuture<List<CartItem>> clear();
}
