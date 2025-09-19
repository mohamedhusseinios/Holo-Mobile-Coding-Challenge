import '../../../../core/utils/result.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCart extends UseCase<List<CartItem>, NoParams> {
  GetCart(this._repository);

  final CartRepository _repository;

  @override
  ResultFuture<List<CartItem>> call(NoParams params) {
    return _repository.getCart();
  }
}
