import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/product_list_page.dart';

class AppRouter {
  AppRouter();

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: ProductListPage.routeName,
        path: '/',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ProductListPage()),
        routes: [
          GoRoute(
            name: ProductDetailPage.routeName,
            path: 'product/:id',
            pageBuilder: (context, state) {
              final idParam = state.pathParameters['id'];
              final id = int.tryParse(idParam ?? '');
              if (id == null) {
                return const NoTransitionPage(child: ProductListPage());
              }
              final seedProduct = state.extra is Product
                  ? state.extra as Product
                  : null;
              return MaterialPage(
                key: state.pageKey,
                child: ProductDetailPage(
                  productId: id,
                  seedProduct: seedProduct,
                ),
              );
            },
          ),
          GoRoute(
            name: CartPage.routeName,
            path: 'cart',
            pageBuilder: (context, state) =>
                MaterialPage(key: state.pageKey, child: const CartPage()),
          ),
        ],
      ),
    ],
  );
}
