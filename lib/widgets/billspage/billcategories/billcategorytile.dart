import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/billspage/billcategories/editbillcategory.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/confirmationdialog.dart';
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

  Future<void> deleteBillCategory(BuildContext ctx) async {
    var result = await showDialog<bool>(
      context: ctx,
      builder: (context) {
        return ConfirmationDialog(
          title: "Kategorie löschen",
          content:
              "Wollen Sie die Kategorie ${billCategory.billCategoryName} wirklich löschen?",
          confirmText: "Löschen",
          icon: Icons.delete,
        );
      },
    );

    if (result != null) {
      if (result) {
        var token = ctx.read<AuthenticationState>().token;
        var response = await BillingService(token)
            .deleteBillCategory(billCategory.billCategoryId!);

        if (response.statusCode == 200) {
          ctx.read<BillingState>().removeBillCategory(billCategory);
        }

        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: response,
        ).showSnackbar();
      }
    }
  }

  PopupMenuButton categoryMenu(BuildContext ctx) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey.shade700,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text("Ändern"),
          value: 1,
        ),
        const PopupMenuItem(
          child: Text("Löschen"),
          value: 2,
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          editBillCategory(ctx);
        } else if (value == 2) {
          deleteBillCategory(ctx);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(billCategory.billCategoryName!),
      trailing: categoryMenu(context),
      // trailing: IconButton(
      //   splashRadius: Global.splashRadius,
      //   onPressed: () => editBillCategory(context),
      //   icon: const Icon(Icons.edit),
      // ),
    );
  }
}
