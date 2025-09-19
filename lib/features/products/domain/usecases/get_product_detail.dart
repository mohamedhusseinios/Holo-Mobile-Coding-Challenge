import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetail extends UseCase<Product, ProductDetailParams> {
  GetProductDetail(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<Product> call(ProductDetailParams params) {
    return _repository.fetchProduct(params.id);
  }
}

class ProductDetailParams {
  const ProductDetailParams(this.id);

  final int id;
}
