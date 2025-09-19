import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/remove_cart_item.dart';
import '../../domain/usecases/update_cart_item_quantity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.message,
  });

  final CartStatus status;
  final List<CartItem> items;
  final String? message;

  double get total =>
      items.fold(0, (previousValue, item) => previousValue + item.total);

  int get itemCount =>
      items.fold(0, (previousValue, item) => previousValue + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    String? message,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, items, message];
}

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required GetCart getCart,
    required AddToCart addToCart,
    required UpdateCartItemQuantity updateQuantity,
    required RemoveCartItem removeCartItem,
    required ClearCart clearCart,
  })  : _getCart = getCart,
        _addToCart = addToCart,
        _updateQuantity = updateQuantity,
        _removeCartItem = removeCartItem,
        _clearCart = clearCart,
        super(const CartState());

  final GetCart _getCart;
  final AddToCart _addToCart;
  final UpdateCartItemQuantity _updateQuantity;
  final RemoveCartItem _removeCartItem;
  final ClearCart _clearCart;

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _getCart(const NoParams());
    _handleResult(result);
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _addToCart(
      AddToCartParams(product: product, quantity: quantity),
    );
    _handleResult(result);
  }

  Future<void> increment(int productId) {
    final currentQuantity = _quantityFor(productId);
    return updateQuantity(productId, currentQuantity + 1);
  }

  Future<void> decrement(int productId) {
    final currentQuantity = _quantityFor(productId);
    return updateQuantity(productId, currentQuantity - 1);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _updateQuantity(
      UpdateCartItemQuantityParams(productId: productId, quantity: quantity),
    );
    _handleResult(result);
  }

  Future<void> remove(int productId) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _removeCartItem(RemoveCartItemParams(productId));
    _handleResult(result);
  }

  Future<void> clear() async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _clearCart(const NoParams());
    _handleResult(result);
  }

  int _quantityFor(int productId) {
    for (final item in state.items) {
      if (item.product.id == productId) {
        return item.quantity;
      }
    }
    return 0;
  }

  void _handleResult(Result<List<CartItem>> result) {
    result.when(
      success: (items) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            items: items,
            message: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: CartStatus.failure,
            message: failure.message,
          ),
        );
      },
    );
  }
}
