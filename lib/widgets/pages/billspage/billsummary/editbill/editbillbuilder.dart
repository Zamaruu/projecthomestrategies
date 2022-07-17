import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/utils/token_provider.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/errorpage.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbilldialog.dart';
import 'package:provider/provider.dart';

class EditBillBuilder extends StatelessWidget {
  final int billId;
  final List<BillCategoryModel> categories;

  const EditBillBuilder(
      {Key? key, required this.billId, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TokenProvider(tokenBuilder: (token) {
      return FutureBuilder<ApiResponseModel>(
        future: BillingService(token).getBill(billId, true),
        builder:
            (BuildContext context, AsyncSnapshot<ApiResponseModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return ErrorPageHandler(error: snapshot.error.toString());
          } else {
            var response = snapshot.data;
            if (response!.hasError!) {
              return ErrorPageHandler(error: response.message!);
            } else {
              var bill = snapshot.data!.object as BillModel;
              var categoryIndex = categories.indexWhere(
                (c) => c.billCategoryId == bill.category!.billCategoryId!,
              );

              return ChangeNotifierProvider(
                create: (context) => EditBillState(bill, categoryIndex),
                child: EditBillDialog(
                  billCategories: categories,
                ),
              );
            }
          }
        },
      );
    });
  }
}
