import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projecthomestrategies/bloc/models/apiresponse_model.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/billing_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billcategories/billcategorytile.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billcategories/newbillcategorydialog.dart';
import 'package:provider/provider.dart';

class BillCategoriesDialog extends StatelessWidget {
  const BillCategoriesDialog({Key? key}) : super(key: key);

  List<String> getCategoryNames(List<BillCategoryModel> billCategories) {
    if (billCategories.isNotEmpty) {
      return List.generate(
        billCategories.length,
        (index) => billCategories[index].billCategoryName!,
      );
    } else {
      return <String>[];
    }
  }

  Future<void> createNewCategory(BuildContext ctx) async {
    var result = await showDialog<ApiResponseModel>(
      context: ctx,
      builder: (BuildContext context) {
        return CreateBillCategoryDialog(
          existingCategories: getCategoryNames(
            ctx.read<BillingState>().billCategories,
          ),
        );
      },
    );

    if (result != null) {
      if (result.statusCode == 200) {
        ctx
            .read<BillingState>()
            .addBillCategory(result.object as BillCategoryModel);
      } else {
        ApiResponseHandlerService(response: result, context: ctx)
            .showSnackbar();
      }
    }
  }

  Future<void> refreshBillCategories(BuildContext ctx) async {
    var token = Global.getToken(ctx);
    var householdId =
        ctx.read<AuthenticationState>().sessionUser.household!.householdId!;
    var response =
        await BillingService(token).getBillCategoriesForHousehold(householdId);

    if (response.statusCode == 200) {
      ctx
          .read<BillingState>()
          .setBillCategories(response.object as List<BillCategoryModel>);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BillingState>(
        builder: (context, state, _) {
          if (state.billCategories.isEmpty) {
            return const Center(
              child: Text("Keine Kategorien"),
            );
          } else {
            return AnimationLimiter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 5),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: RefreshIndicator(
                  onRefresh: () => refreshBillCategories(context),
                  child: ListView.separated(
                    itemCount: state.billCategories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: BillCategoryTile(
                              billCategory: state.billCategories[index],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.grey.shade600,
                        height: 4,
                        indent: 15,
                        endIndent: 15,
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewCategory(context),
        tooltip: "Neue Kategorie erstellen",
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
