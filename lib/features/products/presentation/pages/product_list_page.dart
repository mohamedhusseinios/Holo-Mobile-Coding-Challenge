import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/di/locator.dart';
import '../../../../app/theme/theme_cubit.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/state_message.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_list_cubit.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  static const routeName = 'products';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductListCubit>()..fetchProducts(),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('productsTitle')),
        actions: const [_ThemeToggleButton(), SizedBox(width: 8), _CartIcon()],
      ),
      body: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const _ProductGridShimmer();
          }
          if (state.status == ProductListStatus.failure) {
            return StateMessage(
              message: state.message ?? l10n.translate('genericError'),
              actionLabel: l10n.translate('retry'),
              onActionPressed: () =>
                  context.read<ProductListCubit>().fetchProducts(),
            );
          }
          if (state.products.isEmpty) {
            return StateMessage(
              message: l10n.translate('emptyProducts'),
              icon: Icons.search_off,
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ProductListCubit>().refresh(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = state.products[index];
                return _ProductCard(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final price = NumberFormat.simpleCurrency().format(product.price);
    return Card(
      child: InkWell(
        onTap: () => context.goNamed(
          ProductDetailPage.routeName,
          pathParameters: {'id': product.id.toString()},
          extra: product,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: const ColoredBox(color: Colors.white30),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.add_shopping_cart_outlined),
                      label: Text(l10n.translate('addToCart')),
                      onPressed: () =>
                          context.read<CartCubit>().addItem(product),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.brightness_6_outlined),
      onPressed: () => context.read<ThemeCubit>().toggle(),
      tooltip: context.l10n.translate('toggleTheme'),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final count = state.itemCount;
        return IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart_outlined),
              if (count > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count.toString(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          tooltip: context.l10n.translate('cartTitle'),
          onPressed: () => context.goNamed(CartPage.routeName),
        );
      },
    );
  }
}

class _ProductGridShimmer extends StatelessWidget {
  const _ProductGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            child: Column(
              children: const [
                Expanded(child: ColoredBox(color: Colors.white30)),
                SizedBox(height: 12),
                ColoredBox(
                  color: Colors.white30,
                  child: SizedBox(height: 16, width: 100),
                ),
                SizedBox(height: 8),
                ColoredBox(
                  color: Colors.white30,
                  child: SizedBox(height: 12, width: 60),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
