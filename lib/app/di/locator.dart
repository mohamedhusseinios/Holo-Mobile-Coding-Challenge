import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/api/api_client.dart';
import '../../core/services/network/connectivity_service.dart';
import '../../core/services/storage/shared_preferences_storage.dart';
import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart.dart';
import '../../features/cart/domain/usecases/clear_cart.dart';
import '../../features/cart/domain/usecases/get_cart.dart';
import '../../features/cart/domain/usecases/remove_cart_item.dart';
import '../../features/cart/domain/usecases/update_cart_item_quantity.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/products/data/datasources/product_local_data_source.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_product_detail.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/presentation/cubit/product_detail_cubit.dart';
import '../../features/products/presentation/cubit/product_list_cubit.dart';
import '../theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton(() => ApiClient())
    ..registerLazySingleton(() => ConnectivityService())
    ..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton(
      () => SharedPreferencesStorage(prefs: sl<SharedPreferences>()),
    )
    // Product
    ..registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        connectivityService: sl(),
      ),
    )
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetProductDetail(sl()))
    // Cart
    ..registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetCart(sl()))
    ..registerLazySingleton(() => AddToCart(sl()))
    ..registerLazySingleton(() => UpdateCartItemQuantity(sl()))
    ..registerLazySingleton(() => RemoveCartItem(sl()))
    ..registerLazySingleton(() => ClearCart(sl()))
    // Cubits
    ..registerFactory(() => ThemeCubit())
    ..registerFactory(
      () => CartCubit(
        getCart: sl(),
        addToCart: sl(),
        updateQuantity: sl(),
        removeCartItem: sl(),
        clearCart: sl(),
      ),
    )
    ..registerFactory(() => ProductListCubit(sl()))
    ..registerFactory(() => ProductDetailCubit(sl()));
}
