import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:provider/provider.dart';

class EditBillBottomBar extends StatelessWidget {
  final Function editBill;

  const EditBillBottomBar({Key? key, required this.editBill}) : super(key: key);

  void _abortEditing(BuildContext ctx) {
    ctx.read<EditBillState>().setEditing(false);
    ctx.read<EditBillState>().resetEditState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<EditBillState, bool>(
      selector: (context, model) => model.isEditing,
      builder: (context, isEditing, child) {
        if (isEditing) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey.shade400),
              ),
            ),
            height: kBottomNavigationBarHeight,
            child: Selector<EditBillState, bool>(
              selector: (context, model) => model.isLoading,
              builder: (context, isLoading, _) => Row(
                children: [
                  SizedBox(
                    height: kBottomNavigationBarHeight,
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton.icon(
                      onPressed:
                          isLoading ? null : () => _abortEditing(context),
                      style: TextButton.styleFrom(
                        primary: Colors.grey.shade700,
                      ),
                      icon: const Icon(Icons.clear),
                      label: const Text("Abbrechen"),
                    ),
                  ),
                  SizedBox(
                    height: kBottomNavigationBarHeight,
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton.icon(
                      onPressed: isLoading ? null : () => editBill(),
                      style: TextButton.styleFrom(),
                      icon: const Icon(Icons.done),
                      label: const Text("Speichern"),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
