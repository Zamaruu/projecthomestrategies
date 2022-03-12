import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/confirmationdialog.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingsnackbar.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbillbottombar.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbillimagesection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbillinformationsection.dart';
import 'package:provider/provider.dart';

class EditBillDialog extends StatelessWidget {
  final List<BillCategoryModel> billCategories;

  const EditBillDialog({Key? key, required this.billCategories})
      : super(key: key);

  void toggleLoading(bool newValue, BuildContext ctx, LoadingSnackbar loader) {
    ctx.read<EditBillState>().setLoading(newValue);
    if (newValue) {
      loader.showLoadingSnackbar();
    } else {
      loader.dismissSnackbar();
    }
  }

  bool _validateBillData(BuildContext ctx) {
    if (ctx.read<EditBillState>().moneySumController.text.isEmpty) {
      return false;
    }
    if (double.tryParse(
            ctx.read<EditBillState>().moneySumController.text.trim()) ==
        null) {
      return false;
    } else if (double.tryParse(
            ctx.read<EditBillState>().moneySumController.text.trim())! <=
        0) {
      return false;
    }
    if (ctx
        .read<EditBillState>()
        .selectedDate
        .isAfter(DateTime.now().toLocal())) {
      return false;
    }
    return true;
  }

  BillModel _buildBill(BuildContext ctx, EditBillState editState) {
    var currentBill = editState.bill;
    var user = ctx.read<AuthenticationState>().sessionUser;
    var amount = double.tryParse(
      editState.moneySumController.text.trim(),
    );
    var category = billCategories[editState.categorySelection];
    var description = editState.descriptionController.text.trim();
    var date = editState.selectedDate;
    var images = editState.images;

    return BillModel(
      billId: currentBill.billId,
      amount: amount,
      category: category,
      date: date,
      description: description,
      images: images,
      createdAt: currentBill.createdAt,
      buyer: currentBill.buyer,
      household: user.household!,
    );
  }

  Future<void> _editBill(BuildContext ctx) async {
    if (!_validateBillData(ctx)) {
      return;
    }

    var loader = LoadingSnackbar(ctx);
    var editState = ctx.read<EditBillState>();

    toggleLoading(true, ctx, loader);

    var token = ctx.read<AuthenticationState>().token;
    var changedBill = _buildBill(ctx, editState);
    var response = await BillingService(token).editBill(changedBill);

    var imageResponse = await _deleteBillImages(ctx);

    toggleLoading(false, ctx, loader);

    if (response.statusCode == 200 && imageResponse.statusCode == 200) {
      editState.setEditing(false);
      var editedBill = response.object as BillModel;

      ctx.read<BillingState>().editBill(editedBill);
      editState.setBillWhenEdited(editedBill);
    } else {
      if (imageResponse.statusCode != 200) {
        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: imageResponse,
        ).showSnackbar();
      } else {
        ApiResponseHandlerService.fromResponseModel(
          context: ctx,
          response: response,
        ).showSnackbar();
      }
    }
  }

  Future _deleteBill(BuildContext ctx) async {
    var bill = ctx.read<EditBillState>().bill;
    var loader = LoadingSnackbar(ctx);

    var result = await showDialog<bool>(
      context: ctx,
      builder: (context) {
        return ConfirmationDialog(
          title: "Rechnung löschen",
          content:
              "Wollen Sie die Rechnung vom ${Global.datetimeToDeString(bill.date!)} über ${bill.amount!.toStringAsFixed(2)} € wirklich löschen?",
          confirmText: "Löschen",
          icon: Icons.delete,
        );
      },
    );

    if (result != null) {
      if (result) {
        toggleLoading(true, ctx, loader);

        var token = ctx.read<AuthenticationState>().token;
        var imageResponse = await _deleteBillImages(ctx, deleteAll: true);
        var response = await BillingService(token).deleteBill(bill.billId!);

        toggleLoading(false, ctx, loader);

        if (response.statusCode == 200) {
          ctx.read<BillingState>().removeBill(bill);

          Navigator.pop(ctx);
        } else {
          if (imageResponse.statusCode != 200) {
            ApiResponseHandlerService.fromResponseModel(
              context: ctx,
              response: imageResponse,
            ).showSnackbar();
          } else {
            ApiResponseHandlerService.fromResponseModel(
              context: ctx,
              response: response,
            ).showSnackbar();
          }
        }
      }
    }
    // if (response != null) {
    //   ApiResponseHandlerService(
    //     context: ctx,
    //     response: response,
    //   ).showSnackbar();
    // }
  }

  Future<ApiResponseModel> _deleteBillImages(
    BuildContext ctx, {
    bool deleteAll = false,
  }) async {
    var token = Global.getToken(ctx);
    var deleteImages = deleteAll
        ? ctx
            .read<EditBillState>()
            .bill
            .images!
            .map((i) => i.billImageId!)
            .toList()
        : ctx.read<EditBillState>().imagesToDelete;

    if (deleteImages.isNotEmpty) {
      return await BillingService(token).deleteBillImages(deleteImages);
    } else {
      return ApiResponseModel(
        200,
        "Keine Bilder müssen gelöscht werden",
        null,
        false,
      );
    }
  }

  PopupMenuButton<int> billMenu(BuildContext ctx) {
    var isEditing = ctx.watch<EditBillState>().isEditing;

    return PopupMenuButton<int>(
      icon: const Icon(
        Icons.more_vert,
        //color: Colors.w,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text(isEditing ? "Bearbeiten beenden" : "Bearbeiten"),
          value: 1,
        ),
        const PopupMenuItem(
          child: Text("Löschen"),
          value: 2,
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          ctx.read<EditBillState>().setEditing(!isEditing);
        } else if (value == 2) {
          _deleteBill(ctx);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text("Rechnung bearbeiten"),
        actions: <Widget>[
          billMenu(context),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          EditBillInformationSection(
            billCategories: billCategories,
          ),
          const EditBillImageSection(),
        ],
      ),
      bottomNavigationBar: EditBillBottomBar(
        editBill: () => _editBill(context),
      ),
    );
  }
}
