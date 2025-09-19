import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/locator.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_detail_cubit.dart';
import '../widgets/product_detail_view.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
    required this.productId,
    this.seedProduct,
  });

  static const routeName = 'productDetail';

  final int productId;
  final Product? seedProduct;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<ProductDetailCubit>();
        if (seedProduct != null) {
          cubit.seed(seedProduct!);
        }
        unawaited(cubit.fetchProduct(productId));
        return cubit;
      },
      child: ProductDetailView(productId: productId),
    );
  }
}
