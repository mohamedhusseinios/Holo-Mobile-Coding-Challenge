import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/state_message.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = 'cart';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('cartTitle')),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state.isEmpty
                    ? null
                    : () => context.read<CartCubit>().clear(),
                child: Text(l10n.translate('clearCart')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CartStatus.failure) {
            return StateMessage(
              message: state.message ?? l10n.translate('genericError'),
            );
          }
          if (state.isEmpty) {
            return StateMessage(
              message: l10n.translate('emptyCart'),
              icon: Icons.remove_shopping_cart_outlined,
            );
          }
          final currency = NumberFormat.simpleCurrency();
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return CartItemTile(item: item, currency: currency);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                ),
              ),
              CartSummary(total: currency.format(state.total)),
            ],
          );
        },
      ),
    );
  }
}
