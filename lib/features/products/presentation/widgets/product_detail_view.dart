import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/state_message.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/product_detail_cubit.dart';
import 'product_detail_shimmer.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('productDetails'))),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.isLoading && state.product == null) {
            return const ProductDetailShimmer();
          }
          if (state.status == ProductDetailStatus.failure) {
            return StateMessage(
              message: state.message ?? l10n.translate('genericError'),
              actionLabel: l10n.translate('retry'),
              onActionPressed: () =>
                  context.read<ProductDetailCubit>().fetchProduct(productId),
            );
          }
          final product = state.product;
          if (product == null) {
            return StateMessage(
              message: l10n.translate('productUnavailable'),
              icon: Icons.warning_amber_rounded,
            );
          }
          final price = NumberFormat.simpleCurrency().format(product.price);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: const ColoredBox(color: Colors.white30),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Chip(
                      label: Text(product.category),
                      avatar: const Icon(Icons.category_outlined, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Chip(label: Text('${product.rating.toStringAsFixed(1)} ⭐')),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  price,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.translate('description'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    label: Text(l10n.translate('addToCart')),
                    onPressed: () {
                      context.read<CartCubit>().addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.translate('addedToCart'))),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
