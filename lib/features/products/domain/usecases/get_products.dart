import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts extends UseCase<List<Product>, NoParams> {
  GetProducts(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<Product>> call(NoParams params) {
    return _repository.fetchProducts();
  }
}
