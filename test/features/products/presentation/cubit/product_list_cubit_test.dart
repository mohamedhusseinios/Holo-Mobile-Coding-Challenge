import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:holo_mobile_coding_challenge/core/errors/failure.dart';
import 'package:holo_mobile_coding_challenge/core/utils/result.dart';
import 'package:holo_mobile_coding_challenge/core/utils/usecase.dart';
import 'package:holo_mobile_coding_challenge/features/products/domain/entities/product.dart';
import 'package:holo_mobile_coding_challenge/features/products/domain/usecases/get_products.dart';
import 'package:holo_mobile_coding_challenge/features/products/presentation/cubit/product_list_cubit.dart';

import '../../../../support/test_data.dart';

class _MockGetProducts extends Mock implements GetProducts {}

void main() {
  late _MockGetProducts getProducts;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getProducts = _MockGetProducts();
  });

  final products = [makeProduct(id: 1), makeProduct(id: 2)];

  blocTest<ProductListCubit, ProductListState>(
    'emits loading then success when fetchProducts succeeds',
    build: () {
      when(
        () => getProducts(any<NoParams>()),
      ).thenAnswer((_) async => Success<List<Product>>(products));
      return ProductListCubit(getProducts);
    },
    act: (cubit) => cubit.fetchProducts(),
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      ProductListState(
        status: ProductListStatus.success,
        products: products,
        message: null,
      ),
    ],
  );

  blocTest<ProductListCubit, ProductListState>(
    'emits failure when fetchProducts fails',
    build: () {
      when(() => getProducts(any<NoParams>())).thenAnswer(
        (_) async =>
            const FailureResult<List<Product>>(Failure(message: 'error')),
      );
      return ProductListCubit(getProducts);
    },
    act: (cubit) => cubit.fetchProducts(),
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      const ProductListState(
        status: ProductListStatus.failure,
        message: 'error',
      ),
    ],
  );
}
