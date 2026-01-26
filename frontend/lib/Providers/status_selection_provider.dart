import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/l10n/app_localizations.dart';

final statusSelectionProvider = StateProvider((ref) => 'all');

Map<String, String> statuses(BuildContext context) => {
  'All': AppLocalizations.of(context)!.all,
  'Active': AppLocalizations.of(context)!.active,
  'Completed': AppLocalizations.of(context)!.completed,
};
