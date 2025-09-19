import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCart extends UseCase<List<CartItem>, AddToCartParams> {
  AddToCart(this._repository);

  final CartRepository _repository;

  @override
  ResultFuture<List<CartItem>> call(AddToCartParams params) {
    return _repository.addItem(params.product, quantity: params.quantity);
  }
}

class AddToCartParams {
  const AddToCartParams({required this.product, this.quantity = 1});

  final Product product;
  final int quantity;
}
