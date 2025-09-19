import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/di/locator.dart';
import 'app/theme/theme_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  final storage = await _buildHydratedStorage();

  HydratedBlocOverrides.runZoned(
    () => runApp(const AppBootstrap()),
    storage: storage,
  );
}

Future<HydratedStorage> _buildHydratedStorage() async {
  Directory appDir;
  if (Platform.isIOS || Platform.isMacOS) {
    appDir = await getApplicationSupportDirectory();
  } else {
    appDir = await getApplicationDocumentsDirectory();
  }
  return HydratedStorage.build(storageDirectory: appDir);
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
        BlocProvider<CartCubit>(
          create: (_) => sl<CartCubit>()..loadCart(),
        ),
      ],
      child: HoloApp(),
    );
  }
}
