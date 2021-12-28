import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/cancelbutton.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/primarybutton.dart';

class AddBillModal extends StatefulWidget {
  final billCategories = ['Lebensmittel', 'Mode', 'Technik', 'Ausgang'];

  AddBillModal({ Key? key }) : super(key: key);

  @override
  State<AddBillModal> createState() => _AddBillModalState();
}

class _AddBillModalState extends State<AddBillModal> {
  late TextEditingController moneySumController;
  late TextEditingController selectedDateController;
  late String categorySelection;
  late DateTime selectedDate;

  @override
  void initState() {
    moneySumController = TextEditingController();
    categorySelection = widget.billCategories[0];
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
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate){
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
            DropdownButton<String>(
              value: categorySelection,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: Theme.of(context).primaryColor),
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  categorySelection = newValue!;
                });
              },
              items: widget.billCategories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
        PrimaryButton(onPressed: () => Navigator.of(context).pop(), text: "Erstellen", icon: Icons.add)
      ],
    );
  }
}