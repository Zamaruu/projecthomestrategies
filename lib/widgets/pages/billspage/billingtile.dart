import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/editbilldialog.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/confirmationdialog.dart';
import 'package:provider/provider.dart';

class BillingTile extends StatelessWidget {
  final BillModel bill;
  final bool showMenu;
  final Function? onTap;

  const BillingTile({
    Key? key,
    required this.bill,
    this.showMenu = false,
    this.onTap,
  }) : super(key: key);

  Future editBill(BuildContext ctx) async {
    var response = await showDialog<ApiResponseModel>(
      context: ctx,
      builder: (context) {
        return EditBillModal(
          billCategories: ctx.read<BillingState>().billCategories,
          state: ctx.read<BillingState>(),
          billToEdit: bill,
        );
      },
    );
    if (response != null) {
      ApiResponseHandlerService(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  Future deleteBill(BuildContext ctx) async {
    var response = await showDialog<bool>(
      context: ctx,
      builder: (context) {
        return ConfirmationDialog(
          title: "Rechnung löschen",
          content:
              "Wollen Sie die Rechnung vom ${Global.datetimeToDeString(bill.date!)} über ${bill.amount} € wirklich löschen?",
          confirmText: "Löschen",
          icon: Icons.delete,
        );
      },
    );
    if (response != null) {
      if (response) {
        var token = ctx.read<AuthenticationState>().token;
        var response = await BillingService(token).deleteBill(bill.billId!);

        if (response.statusCode == 200) {
          ctx.read<BillingState>().removeBill(bill);
        }

        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: response,
        ).showSnackbar();
      }
    }
    // if (response != null) {
    //   ApiResponseHandlerService(
    //     context: ctx,
    //     response: response,
    //   ).showSnackbar();
    // }
  }

  PopupMenuButton billMenu(BuildContext ctx) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey.shade700,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text("Bearbeiten"),
          value: 1,
        ),
        const PopupMenuItem(
          child: Text("Löschen"),
          value: 2,
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          editBill(ctx);
        } else if (value == 2) {
          deleteBill(ctx);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListTile(
        onTap: onTap != null ? () => onTap!() : null,
        leading: Text(
          "${bill.amount!.toStringAsFixed(2)} €",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text(
          "Bezahlt für ${bill.category!.billCategoryName!}",
        ),
        subtitle: Text(
          "am ${Global.datetimeToDeString(bill.date!)} von ${bill.buyer!.email!}",
        ),
        trailing: showMenu ? billMenu(context) : null,
      ),
    );
  }
}
