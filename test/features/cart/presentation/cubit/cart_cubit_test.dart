import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:holo_mobile_coding_challenge/core/errors/failure.dart';
import 'package:holo_mobile_coding_challenge/core/utils/result.dart';
import 'package:holo_mobile_coding_challenge/core/utils/usecase.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/entities/cart_item.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/usecases/add_to_cart.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/usecases/clear_cart.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/usecases/get_cart.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:holo_mobile_coding_challenge/features/cart/presentation/cubit/cart_cubit.dart';

import '../../../../support/test_data.dart';

class _MockGetCart extends Mock implements GetCart {}

class _MockAddToCart extends Mock implements AddToCart {}

class _MockUpdateCartItemQuantity extends Mock
    implements UpdateCartItemQuantity {}

class _MockRemoveCartItem extends Mock implements RemoveCartItem {}

class _MockClearCart extends Mock implements ClearCart {}

void main() {
  late _MockGetCart getCart;
  late _MockAddToCart addToCart;
  late _MockUpdateCartItemQuantity updateQuantity;
  late _MockRemoveCartItem removeCartItem;
  late _MockClearCart clearCart;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(AddToCartParams(product: makeProduct(), quantity: 1));
    registerFallbackValue(
      UpdateCartItemQuantityParams(productId: 1, quantity: 1),
    );
    registerFallbackValue(RemoveCartItemParams(1));
  });

  setUp(() {
    getCart = _MockGetCart();
    addToCart = _MockAddToCart();
    updateQuantity = _MockUpdateCartItemQuantity();
    removeCartItem = _MockRemoveCartItem();
    clearCart = _MockClearCart();
  });

  CartCubit buildCubit() => CartCubit(
    getCart: getCart,
    addToCart: addToCart,
    updateQuantity: updateQuantity,
    removeCartItem: removeCartItem,
    clearCart: clearCart,
  );

  final cartItems = [makeCartItem(id: 1, quantity: 2)];

  blocTest<CartCubit, CartState>(
    'loadCart emits loading then success',
    build: () {
      when(
        () => getCart(any<NoParams>()),
      ).thenAnswer((_) async => Success<List<CartItem>>(cartItems));
      return buildCubit();
    },
    act: (cubit) => cubit.loadCart(),
    expect: () => [
      const CartState(status: CartStatus.loading),
      CartState(status: CartStatus.success, items: cartItems),
    ],
  );

  blocTest<CartCubit, CartState>(
    'addItem emits loading then success with updated items',
    build: () {
      when(
        () => getCart(any<NoParams>()),
      ).thenAnswer((_) async => Success<List<CartItem>>(cartItems));
      when(
        () => addToCart(any<AddToCartParams>()),
      ).thenAnswer((_) async => Success<List<CartItem>>(cartItems));
      return buildCubit();
    },
    act: (cubit) => cubit.addItem(makeProduct()),
    expect: () => [
      const CartState(status: CartStatus.loading),
      CartState(status: CartStatus.success, items: cartItems),
    ],
  );

  blocTest<CartCubit, CartState>(
    'updateQuantity emits failure when usecase fails',
    build: () {
      when(
        () => updateQuantity(any<UpdateCartItemQuantityParams>()),
      ).thenAnswer(
        (_) async =>
            const FailureResult<List<CartItem>>(Failure(message: 'error')),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.updateQuantity(1, 2),
    expect: () => [
      const CartState(status: CartStatus.loading),
      const CartState(status: CartStatus.failure, message: 'error'),
    ],
  );

  blocTest<CartCubit, CartState>(
    'clear emits loading then success with empty list',
    build: () {
      when(
        () => clearCart(any<NoParams>()),
      ).thenAnswer((_) async => const Success<List<CartItem>>([]));
      return buildCubit();
    },
    act: (cubit) => cubit.clear(),
    expect: () => [
      const CartState(status: CartStatus.loading),
      const CartState(status: CartStatus.success, items: []),
    ],
  );
}
