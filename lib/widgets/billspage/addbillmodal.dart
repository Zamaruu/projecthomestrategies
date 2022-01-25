import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/billcategory_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';

class AddBillModal extends StatefulWidget {
  final List<BillCategoryModel> billCategories;

  const AddBillModal({Key? key, required this.billCategories})
      : super(key: key);

  @override
  State<AddBillModal> createState() => _AddBillModalState();
}

class _AddBillModalState extends State<AddBillModal> {
  late TextEditingController moneySumController;
  late TextEditingController selectedDateController;
  late int categorySelection;
  late DateTime selectedDate;

  @override
  void initState() {
    moneySumController = TextEditingController();
    categorySelection = 0;
    selectedDate = DateTime.now().toLocal();
    selectedDateController = TextEditingController();
    selectedDateController.text = Global.datetimeToDeString(selectedDate);
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("de", "DE"),
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateController.text = Global.datetimeToDeString(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rechnung erstellen"),
      content: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: moneySumController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text("Rechnungsbetrag"),
                hintText: "12,34 €",
              ),
            ),
            DropdownButton<int>(
              value: categorySelection,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: Theme.of(context).primaryColor),
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (int? newValue) {
                setState(() {
                  categorySelection = newValue!;
                });
              },
              items: List.generate(
                widget.billCategories.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(widget.billCategories[index].billCategoryName!),
                ),
              ),
              // widget.billCategories.map<DropdownMenuItem<int>>((BillCategoryModel value) {
              //   return DropdownMenuItem<int>(
              //     value: value.billCategoryId,
              //     child: Text(value.billCategoryName!),
              //   );
              // }).toList(),
            ),
            TextFormField(
              onTap: () => _selectDate(context),
              controller: selectedDateController,
              keyboardType: TextInputType.none,
              decoration: const InputDecoration(
                label: Text("Rechnungsdatum"),
              ),
            ),
          ],
        ),
      ),
      actions: [
        CancelButton(onCancel: () => Navigator.of(context).pop()),
        PrimaryButton(
            onPressed: () => Navigator.of(context).pop(),
            text: "Erstellen",
            icon: Icons.add)
      ],
    );
  }
}
