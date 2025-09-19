import '../../../../core/services/api/api_client.dart';
import '../models/product_dto.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductDto>> fetchProducts();
  Future<ProductDto> fetchProduct(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<ProductDto>> fetchProducts() async {
    final jsonList = await _apiClient.getJsonList('/products');
    return jsonList.map(ProductDto.fromJson).toList();
  }

  @override
  Future<ProductDto> fetchProduct(int id) async {
    final json = await _apiClient.getJson('/products/$id');
    return ProductDto.fromJson(json);
  }
}
