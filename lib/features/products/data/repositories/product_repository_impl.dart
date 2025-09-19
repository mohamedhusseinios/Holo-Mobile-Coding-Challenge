import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/network/connectivity_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_dto.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required ProductLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivityService = connectivityService;

  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  @override
  ResultFuture<List<Product>> fetchProducts() async {
    try {
      final remoteProducts = await _remoteDataSource.fetchProducts();
      await _localDataSource.cacheProducts(remoteProducts);
      final products = remoteProducts.map((dto) => dto.toDomain()).toList();
      return Success(products);
    } on AppException catch (error) {
      final cached = _localDataSource.readCachedProducts();
      if (cached != null && cached.isNotEmpty) {
        return Success(cached.map((dto) => dto.toDomain()).toList());
      }
      return FailureResult(
        Failure(
          message: _mapErrorMessage(error),
          cause: error,
        ),
      );
    } catch (error) {
      return FailureResult(
        Failure(message: 'Unexpected error fetching products', cause: error),
      );
    }
  }

  @override
  ResultFuture<Product> fetchProduct(int id) async {
    try {
      final hasConnection = await _connectivityService.hasConnection;
      if (hasConnection) {
        final remoteProduct = await _remoteDataSource.fetchProduct(id);
        final cachedProducts = _localDataSource.readCachedProducts() ?? [];
        final updated = _replaceOrAppend(cachedProducts, remoteProduct);
        await _localDataSource.cacheProducts(updated);
        return Success(remoteProduct.toDomain());
      }

      final cached = _localDataSource.readCachedProduct(id);
      if (cached != null) {
        return Success(cached.toDomain());
      }
      return const FailureResult(
        Failure(message: 'Product not available offline'),
      );
    } on AppException catch (error) {
      final cached = _localDataSource.readCachedProduct(id);
      if (cached != null) {
        return Success(cached.toDomain());
      }
      return FailureResult(
        Failure(message: _mapErrorMessage(error), cause: error),
      );
    } catch (error) {
      return FailureResult(
        Failure(message: 'Unexpected error fetching product', cause: error),
      );
    }
  }

  List<ProductDto> _replaceOrAppend(
    List<ProductDto> products,
    ProductDto updated,
  ) {
    final index = products.indexWhere((item) => item.id == updated.id);
    if (index == -1) {
      return [...products, updated];
    }
    final copy = List<ProductDto>.from(products);
    copy[index] = updated;
    return copy;
  }

  String _mapErrorMessage(AppException exception) {
    if (exception.statusCode == null) {
      return 'Network error. Check your connection and try again.';
    }
    if (exception.statusCode == 404) {
      return 'Product not found.';
    }
    return 'Server error (${exception.statusCode}). Please try later.';
  }
}
