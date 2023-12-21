import 'package:flutter/material.dart';

import '../../language_currency/lang_export.dart';

Future<bool> dialogNoInternetGetBackup(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.alert),
        content: Text(AppLocalizations.of(context)!.noConnection),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("Retry"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          ElevatedButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          )
        ],
      );
    },
  );
}
