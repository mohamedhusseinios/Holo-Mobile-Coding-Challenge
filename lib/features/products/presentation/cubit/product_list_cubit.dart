import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

enum ProductListStatus { initial, loading, success, failure }

class ProductListState extends Equatable {
  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.message,
  });

  final ProductListStatus status;
  final List<Product> products;
  final String? message;

  bool get isLoading => status == ProductListStatus.loading;

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    String? message,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, products, message];
}

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit(this._getProducts) : super(const ProductListState());

  final GetProducts _getProducts;

  Future<void> fetchProducts() async {
    emit(state.copyWith(status: ProductListStatus.loading));
    final result = await _getProducts(const NoParams());
    result.when(
      success: (products) {
        emit(
          state.copyWith(
            status: ProductListStatus.success,
            products: products,
            message: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: ProductListStatus.failure,
            message: failure.message,
          ),
        );
      },
    );
  }

  Future<void> refresh() => fetchProducts();
}
