import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/editbillcategory.dart';
import 'package:provider/provider.dart';

class BillCategoryTile extends StatelessWidget {
  final BillCategoryModel billCategory;

  const BillCategoryTile({Key? key, required this.billCategory})
      : super(key: key);

  void editBillCategory(BuildContext ctx) async {
    billCategory.household =
        ctx.read<AuthenticationState>().sessionUser.household!;
    var result = await showDialog<ApiResponseModel>(
      context: ctx,
      builder: (context) {
        return EditCategoryDialog(catgeory: billCategory);
      },
    );

    if (result != null) {
      if (result.statusCode == 200) {
        ctx
            .read<BillingState>()
            .editBillCategory(result.object as BillCategoryModel);
      } else {
        debugPrint(result.message);
        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: result,
        ).showSnackbar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(billCategory.billCategoryName!),
      trailing: IconButton(
        splashRadius: Global.splashRadius,
        onPressed: () => editBillCategory(context),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
