import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/theme_cubit.dart';
import '../../../../core/extensions/context_extensions.dart';

class ProductThemeToggleButton extends StatelessWidget {
  const ProductThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.brightness_6_outlined),
      onPressed: () => context.read<ThemeCubit>().toggle(),
      tooltip: context.l10n.translate('toggleTheme'),
    );
  }
}
