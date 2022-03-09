import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/filter_bills_state.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';

class FilterCategoiesSection extends StatelessWidget {
  const FilterCategoiesSection({Key? key}) : super(key: key);

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
        children: [
          const PanelHeading(
            heading: "Kategorien",
            padding: 15,
          ),
          Material(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            child: Consumer<BillFilterState>(
              builder: (context, filterState, _) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filterState.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    title: Text(
                      "${filterState.categories[index].billCategoryName}",
                    ),
                    value: filterState.selectedCategoriesContainsId(
                      filterState.categories[index].billCategoryId!,
                    ),
                    onChanged: (ticked) => filterState.setFilterForCategories(
                      filterState.categories[index].billCategoryId!,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
