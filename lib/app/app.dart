import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_constants.dart';
import 'localization/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

class HoloApp extends StatelessWidget {
  HoloApp({super.key}) : _router = AppRouter();

  final AppRouter _router;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: _router.router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}
