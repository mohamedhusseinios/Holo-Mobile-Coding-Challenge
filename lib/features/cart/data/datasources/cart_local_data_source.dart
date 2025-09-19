import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage/shared_preferences_storage.dart';
import '../models/cart_item_dto.dart';

abstract interface class CartLocalDataSource {
  Future<void> cacheCart(List<CartItemDto> items);
  List<CartItemDto> readCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(this._storage);

  final SharedPreferencesStorage _storage;

  @override
  Future<void> cacheCart(List<CartItemDto> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.writeJson(StorageKeys.cachedCart, jsonList);
  }

  @override
  List<CartItemDto> readCart() {
    final jsonList = _storage.readJsonList(StorageKeys.cachedCart);
    if (jsonList == null) return [];
    return jsonList
        .cast<Map<String, dynamic>>()
        .map(CartItemDto.fromJson)
        .toList();
  }
}
