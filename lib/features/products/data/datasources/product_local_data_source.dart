import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage/shared_preferences_storage.dart';
import '../models/product_dto.dart';

abstract interface class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductDto> products);
  List<ProductDto>? readCachedProducts();
  ProductDto? readCachedProduct(int id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._storage);

  final SharedPreferencesStorage _storage;

  @override
  Future<void> cacheProducts(List<ProductDto> products) async {
    final jsonList = products.map((product) => product.toJson()).toList();
    await _storage.writeJson(StorageKeys.cachedProducts, jsonList);
  }

  @override
  List<ProductDto>? readCachedProducts() {
    final jsonList = _storage.readJsonList(StorageKeys.cachedProducts);
    if (jsonList == null) return null;
    return jsonList
        .cast<Map<String, dynamic>>()
        .map(ProductDto.fromJson)
        .toList();
  }

  @override
  ProductDto? readCachedProduct(int id) {
    final items = readCachedProducts();
    if (items == null) return null;
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
