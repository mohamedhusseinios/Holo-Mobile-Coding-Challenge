import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_dto.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required CartLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final CartLocalDataSource _localDataSource;

  @override
  ResultFuture<List<CartItem>> getCart() async {
    try {
      final items = _localDataSource.readCart();
      return Success(_toDomainList(items));
    } catch (error) {
      return FailureResult(
        Failure(message: 'Failed to read cart from storage', cause: error),
      );
    }
  }

  @override
  ResultFuture<List<CartItem>> addItem(Product product, {int quantity = 1}) async {
    try {
      final items = _localDataSource.readCart();
      final index = items.indexWhere((item) => item.product.id == product.id);
      if (index == -1) {
        items.add(
          CartItemDto.fromDomain(
            CartItem(product: product, quantity: quantity),
          ),
        );
      } else {
        final existing = items[index];
        items[index] = CartItemDto(
          product: existing.product,
          quantity: existing.quantity + quantity,
        );
      }
      return Success(await _persist(items));
    } catch (error) {
      return FailureResult(
        Failure(message: 'Failed to add item to cart', cause: error),
      );
    }
  }

  @override
  ResultFuture<List<CartItem>> updateQuantity(int productId, int quantity) async {
    try {
      final items = _localDataSource.readCart();
      final index = items.indexWhere((item) => item.product.id == productId);
      if (index == -1) {
        return const FailureResult(
          Failure(message: 'Item not found in cart'),
        );
      }
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        final existing = items[index];
        items[index] = CartItemDto(
          product: existing.product,
          quantity: quantity,
        );
      }
      return Success(await _persist(items));
    } catch (error) {
      return FailureResult(
        Failure(message: 'Failed to update cart item', cause: error),
      );
    }
  }

  @override
  ResultFuture<List<CartItem>> removeItem(int productId) async {
    try {
      final items = _localDataSource.readCart();
      items.removeWhere((item) => item.product.id == productId);
      return Success(await _persist(items));
    } catch (error) {
      return FailureResult(
        Failure(message: 'Failed to remove cart item', cause: error),
      );
    }
  }

  @override
  ResultFuture<List<CartItem>> clear() async {
    try {
      return Success(await _persist(<CartItemDto>[]));
    } catch (error) {
      return FailureResult(
        Failure(message: 'Failed to clear cart', cause: error),
      );
    }
  }

  Future<List<CartItem>> _persist(List<CartItemDto> items) async {
    await _localDataSource.cacheCart(items);
    return _toDomainList(items);
  }

  List<CartItem> _toDomainList(List<CartItemDto> items) {
    return items.map((item) => item.toDomain()).toList();
  }
}
