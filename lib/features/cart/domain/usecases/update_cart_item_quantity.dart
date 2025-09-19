import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemQuantity
    extends UseCase<List<CartItem>, UpdateCartItemQuantityParams> {
  UpdateCartItemQuantity(this._repository);

  final CartRepository _repository;

  @override
  ResultFuture<List<CartItem>> call(UpdateCartItemQuantityParams params) {
    return _repository.updateQuantity(params.productId, params.quantity);
  }
}

class UpdateCartItemQuantityParams {
  const UpdateCartItemQuantityParams({
    required this.productId,
    required this.quantity,
  });

  final int productId;
  final int quantity;
}
