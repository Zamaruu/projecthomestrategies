import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/filter_bills_state.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';

class FilterUsersSection extends StatelessWidget {
  const FilterUsersSection({Key? key}) : super(key: key);

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
          PanelHeading(
            heading: "Benutzer",
            padding: 15,
            trailing: Text(
              context.watch<BillFilterState>().getCurrentUserFilterCount(),
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            child: Consumer<BillFilterState>(
              builder: (context, filterState, _) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filterState.users.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    title: Text(
                      "${filterState.users[index].firstname} ${filterState.users[index].surname}",
                    ),
                    value: filterState.selectedUsersContainsId(
                      filterState.users[index].userId!,
                    ),
                    onChanged: (ticked) => filterState.setFilterForUser(
                      filterState.users[index].userId!,
                      context,
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
