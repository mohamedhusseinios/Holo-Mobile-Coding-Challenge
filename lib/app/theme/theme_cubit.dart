import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void setTheme(ThemeMode mode) => emit(mode);

  void toggle() {
    switch (state) {
      case ThemeMode.system:
      case ThemeMode.light:
        emit(ThemeMode.dark);
      case ThemeMode.dark:
        emit(ThemeMode.light);
    }
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final value = json['themeMode'] as String?;
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
    }
    return ThemeMode.system;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'themeMode': state.name};
  }
}
