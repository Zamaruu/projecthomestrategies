import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';

class BillCategoryTile extends StatelessWidget {
  final BillCategoryModel billCategory;

  const BillCategoryTile({Key? key, required this.billCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(billCategory.billCategoryName!),
      trailing: IconButton(
        splashRadius: Global.splashRadius,
        onPressed: () {},
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
