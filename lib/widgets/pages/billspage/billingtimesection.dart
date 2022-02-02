import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/bill_model.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billingtile.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';

class BillingTimeSection extends StatelessWidget {
  final String label;
  final List<BillModel> bills;

  const BillingTimeSection({Key? key, required this.label, required this.bills})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: PanelHeading(heading: label),
        ),
        ListView.builder(
          itemCount: bills.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return BillingTile(
              bill: bills[index],
              showMenu: true,
            );
          },
        ),
      ],
    );
  }
}
