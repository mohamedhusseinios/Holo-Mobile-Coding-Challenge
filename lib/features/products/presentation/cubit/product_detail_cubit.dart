import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_detail.dart';

enum ProductDetailStatus { initial, loading, success, failure }

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.message,
  });

  final ProductDetailStatus status;
  final Product? product;
  final String? message;

  bool get isLoading => status == ProductDetailStatus.loading;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    String? message,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, product, message];
}

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._getProductDetail) : super(const ProductDetailState());

  final GetProductDetail _getProductDetail;

  Future<void> fetchProduct(int id) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final result = await _getProductDetail(ProductDetailParams(id));
    result.when(
      success: (product) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.success,
            product: product,
            message: null,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.failure,
            message: failure.message,
          ),
        );
      },
    );
  }
}
