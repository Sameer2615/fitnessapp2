import 'package:flutter/material.dart';
import 'package:fitnessapp/core/domain/entity/user_pal_entity.dart';
import 'package:fitnessapp/generated/l10n.dart';

class SetPALCategoryDialog extends StatelessWidget {
  const SetPALCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(S.of(context).selectPalCategoryLabel),
      children: [
        SimpleDialogOption(
          child: Text(S.of(context).palSedentaryLabel),
          onPressed: () {
            Navigator.pop(context, UserPALEntity.sedentary);
          },
        ),
        SimpleDialogOption(
          child: Text(S.of(context).palLowLActiveLabel),
          onPressed: () {
            Navigator.pop(context, UserPALEntity.lowActive);
          },
        ),
        SimpleDialogOption(
          child: Text(S.of(context).palActiveLabel),
          onPressed: () {
            Navigator.pop(context, UserPALEntity.active);
          },
        ),
        SimpleDialogOption(
          child: Text(S.of(context).palVeryActiveLabel),
          onPressed: () {
            Navigator.pop(context, UserPALEntity.veryActive);
          },
        ),
      ],
    );
  }
}
