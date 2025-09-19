import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItem extends UseCase<List<CartItem>, RemoveCartItemParams> {
  RemoveCartItem(this._repository);

  final CartRepository _repository;

  @override
  ResultFuture<List<CartItem>> call(RemoveCartItemParams params) {
    return _repository.removeItem(params.productId);
  }
}

class RemoveCartItemParams {
  const RemoveCartItemParams(this.productId);

  final int productId;
}
