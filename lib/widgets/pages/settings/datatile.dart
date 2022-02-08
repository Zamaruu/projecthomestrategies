import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class DataTile extends StatelessWidget {
  final String data;
  final Function? onTap;

  const DataTile({Key? key, required this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data),
      trailing: onTap != null
          ? IconButton(
              tooltip: "Bearbeiten",
              onPressed: () => onTap!(),
              splashRadius: Global.splashRadius,
              icon: const Icon(Icons.edit),
            )
          : null,
    );
  }
}
