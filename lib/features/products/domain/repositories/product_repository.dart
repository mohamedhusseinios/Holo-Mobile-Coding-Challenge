import '../../../../core/utils/result.dart';
import '../entities/product.dart';

abstract interface class ProductRepository {
  ResultFuture<List<Product>> fetchProducts();
  ResultFuture<Product> fetchProduct(int id);
}
