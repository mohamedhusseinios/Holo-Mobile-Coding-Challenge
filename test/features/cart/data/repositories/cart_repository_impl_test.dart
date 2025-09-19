import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:holo_mobile_coding_challenge/core/errors/failure.dart';
import 'package:holo_mobile_coding_challenge/core/utils/result.dart';
import 'package:holo_mobile_coding_challenge/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:holo_mobile_coding_challenge/features/cart/data/models/cart_item_dto.dart';
import 'package:holo_mobile_coding_challenge/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:holo_mobile_coding_challenge/features/cart/domain/entities/cart_item.dart';
import 'package:holo_mobile_coding_challenge/features/products/domain/entities/product.dart';

import '../../../../support/test_data.dart';

class _MockCartLocalDataSource extends Mock implements CartLocalDataSource {}

void main() {
  late CartRepositoryImpl repository;
  late _MockCartLocalDataSource localDataSource;

  setUp(() {
    localDataSource = _MockCartLocalDataSource();
    repository = CartRepositoryImpl(localDataSource: localDataSource);
  });

  group('getCart', () {
    test('returns items from storage', () async {
      final dtoItems = [makeCartItemDto(id: 1, quantity: 2)];
      when(() => localDataSource.readCart()).thenReturn(dtoItems);

      final result = await repository.getCart();

      expect(result, isA<Success<List<CartItem>>>());
      final success = result as Success<List<CartItem>>;
      expect(success.data.first.quantity, 2);
    });

    test('returns failure when storage throws', () async {
      when(() => localDataSource.readCart()).thenThrow(Exception('oops'));

      final result = await repository.getCart();

      expect(result, isA<FailureResult<List<CartItem>>>());
      final failure = result as FailureResult<List<CartItem>>;
      expect(failure.failure, isA<Failure>());
    });
  });

  group('mutations', () {
    setUp(() {
      when(
        () => localDataSource.cacheCart(any<List<CartItemDto>>()),
      ).thenAnswer((_) async {});
    });

    test('addItem inserts new cart entry', () async {
      when(() => localDataSource.readCart()).thenReturn([]);

      final product = makeProduct();
      final result = await repository.addItem(product, quantity: 1);

      expect(result, isA<Success<List<CartItem>>>());
      verify(
        () => localDataSource.cacheCart(any<List<CartItemDto>>()),
      ).called(1);
    });

    test('addItem increments when item exists', () async {
      final existing = makeCartItemDto(id: 1, quantity: 1);
      when(() => localDataSource.readCart()).thenReturn([existing]);

      final product = existing.product.toDomain();
      final result = await repository.addItem(product, quantity: 2);

      final success = result as Success<List<CartItem>>;
      expect(success.data.first.quantity, 3);
    });

    test('updateQuantity replaces quantity', () async {
      final existing = makeCartItemDto(id: 1, quantity: 1);
      when(() => localDataSource.readCart()).thenReturn([existing]);

      final result = await repository.updateQuantity(1, 4);
      final success = result as Success<List<CartItem>>;
      expect(success.data.first.quantity, 4);
    });

    test('updateQuantity removes when quantity <= 0', () async {
      final existing = makeCartItemDto(id: 1, quantity: 1);
      when(() => localDataSource.readCart()).thenReturn([existing]);

      final result = await repository.updateQuantity(1, 0);
      final success = result as Success<List<CartItem>>;
      expect(success.data, isEmpty);
    });

    test('removeItem deletes entry', () async {
      final existing = makeCartItemDto(id: 1, quantity: 1);
      when(() => localDataSource.readCart()).thenReturn([existing]);

      final result = await repository.removeItem(1);
      final success = result as Success<List<CartItem>>;
      expect(success.data, isEmpty);
    });

    test('clear empties cart', () async {
      final result = await repository.clear();
      final success = result as Success<List<CartItem>>;
      expect(success.data, isEmpty);
    });
  });
}
