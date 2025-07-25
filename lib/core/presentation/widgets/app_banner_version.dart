import 'package:flutter/material.dart';
import 'package:fitnessapp/core/presentation/widgets/dynamic_ont_logo.dart';
import 'package:fitnessapp/generated/l10n.dart';

class AppBannerVersion extends StatelessWidget {
  final String versionNumber;

  const AppBannerVersion({super.key, required this.versionNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(S.of(context).appTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
