import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/state_message.dart';
import '../cubit/product_list_cubit.dart';
import 'product_card.dart';
import 'product_cart_icon.dart';
import 'product_grid_shimmer.dart';
import 'product_theme_toggle_button.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('productsTitle')),
        actions: const [
          ProductThemeToggleButton(),
          SizedBox(width: 8),
          ProductCartIcon(),
        ],
      ),
      body: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const ProductGridShimmer();
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
                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}
