import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/locator.dart';
import '../cubit/product_list_cubit.dart';
import '../widgets/product_list_view.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  static const routeName = 'products';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductListCubit>()..fetchProducts(),
      child: const ProductListView(),
    );
  }
}
