import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/billingtile.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';

class BillingTimeSection extends StatelessWidget {
  final String label;
  final List<BillModel> bills;

  const BillingTimeSection({Key? key, required this.label, required this.bills})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PanelHeading(
              heading: label,
              trailing: Text("(${bills.length})"),
            ),
          ),
          AnimationLimiter(
            child: ListView.separated(
              itemCount: bills.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey.shade600,
                  indent: 15,
                  endIndent: 15,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: BillingTile(
                        bill: bills[index],
                        showMenu: true,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
