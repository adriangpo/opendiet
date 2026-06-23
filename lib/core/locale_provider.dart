import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';

/// The current app locale derived from settings, or null (device default).
final localeProvider = Provider<Locale?>((ref) {
  final settings = ref.watch(settingsControllerProvider).asData?.value;
  final code = settings?.languageCode;
  if (code == null) return null;
  return Locale(code);
});
