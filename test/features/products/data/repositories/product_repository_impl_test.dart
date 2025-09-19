import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:holo_mobile_coding_challenge/core/errors/app_exception.dart';
import 'package:holo_mobile_coding_challenge/core/errors/failure.dart';
import 'package:holo_mobile_coding_challenge/core/services/network/connectivity_service.dart';
import 'package:holo_mobile_coding_challenge/core/utils/result.dart';
import 'package:holo_mobile_coding_challenge/features/products/data/datasources/product_local_data_source.dart';
import 'package:holo_mobile_coding_challenge/features/products/data/datasources/product_remote_data_source.dart';
import 'package:holo_mobile_coding_challenge/features/products/data/models/product_dto.dart';
import 'package:holo_mobile_coding_challenge/features/products/data/repositories/product_repository_impl.dart';
import 'package:holo_mobile_coding_challenge/features/products/domain/entities/product.dart';

import '../../../../support/test_data.dart';

class _MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

class _MockProductLocalDataSource extends Mock
    implements ProductLocalDataSource {}

class _MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late ProductRepositoryImpl repository;
  late _MockProductRemoteDataSource remoteDataSource;
  late _MockProductLocalDataSource localDataSource;
  late _MockConnectivityService connectivityService;

  setUp(() {
    remoteDataSource = _MockProductRemoteDataSource();
    localDataSource = _MockProductLocalDataSource();
    connectivityService = _MockConnectivityService();
    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      connectivityService: connectivityService,
    );
  });

  group('fetchProducts', () {
    final remoteProducts = [makeProductDto(id: 1), makeProductDto(id: 2)];

    test('returns Success when remote fetch succeeds', () async {
      when(
        () => remoteDataSource.fetchProducts(),
      ).thenAnswer((_) async => remoteProducts);
      when(
        () => localDataSource.cacheProducts(any<List<ProductDto>>()),
      ).thenAnswer((_) async {});

      final result = await repository.fetchProducts();

      expect(result, isA<Success<List<Product>>>());
      final success = result as Success<List<Product>>;
      expect(success.data.length, 2);
      verify(
        () => localDataSource.cacheProducts(any<List<ProductDto>>()),
      ).called(1);
    });

    test(
      'falls back to cache when remote throws and cache available',
      () async {
        when(
          () => remoteDataSource.fetchProducts(),
        ).thenThrow(AppException(message: 'Network error'));
        when(
          () => localDataSource.readCachedProducts(),
        ).thenReturn(remoteProducts);

        final result = await repository.fetchProducts();

        expect(result, isA<Success<List<Product>>>());
        final success = result as Success<List<Product>>;
        expect(success.data.length, 2);
      },
    );

    test('returns Failure when remote fails and cache empty', () async {
      when(
        () => remoteDataSource.fetchProducts(),
      ).thenThrow(AppException(message: 'Network error', statusCode: 500));
      when(() => localDataSource.readCachedProducts()).thenReturn(null);

      final result = await repository.fetchProducts();

      expect(result, isA<FailureResult<List<Product>>>());
      final failure = result as FailureResult<List<Product>>;
      expect(failure.failure, isA<Failure>());
    });
  });

  group('fetchProduct', () {
    const productId = 1;
    final remoteProduct = makeProductDto(id: productId);

    test('returns Success when online and remote succeeds', () async {
      when(
        () => connectivityService.hasConnection,
      ).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.fetchProduct(productId),
      ).thenAnswer((_) async => remoteProduct);
      when(() => localDataSource.readCachedProducts()).thenReturn([]);
      when(
        () => localDataSource.cacheProducts(any<List<ProductDto>>()),
      ).thenAnswer((_) async {});

      final result = await repository.fetchProduct(productId);

      expect(result, isA<Success<Product>>());
      verify(() => remoteDataSource.fetchProduct(productId)).called(1);
      verify(
        () => localDataSource.cacheProducts(any<List<ProductDto>>()),
      ).called(1);
    });

    test('returns Success from cache when offline', () async {
      when(
        () => connectivityService.hasConnection,
      ).thenAnswer((_) async => false);
      when(
        () => localDataSource.readCachedProduct(productId),
      ).thenReturn(remoteProduct);

      final result = await repository.fetchProduct(productId);

      expect(result, isA<Success<Product>>());
      verifyNever(() => remoteDataSource.fetchProduct(any<int>()));
    });

    test('returns Failure when offline and cache missing', () async {
      when(
        () => connectivityService.hasConnection,
      ).thenAnswer((_) async => false);
      when(() => localDataSource.readCachedProduct(productId)).thenReturn(null);

      final result = await repository.fetchProduct(productId);

      expect(result, isA<FailureResult<Product>>());
      final failure = result as FailureResult<Product>;
      expect(failure.failure.message, contains('offline'));
    });
  });
}
