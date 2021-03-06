import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projecthomestrategies/bloc/models/billcategory_model.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/textinputfield.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';

class EditBillInformationSection extends StatelessWidget {
  final textfieldMargin = 8.5;
  final List<BillCategoryModel> billCategories;

  const EditBillInformationSection({Key? key, required this.billCategories})
      : super(key: key);

  Future<void> _selectDate(BuildContext ctx) async {
    final selectedDate = ctx.read<EditBillState>().selectedDate;

    final DateTime? picked = await showDatePicker(
      context: ctx,
      locale: const Locale("de", "DE"),
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      ctx.read<EditBillState>().setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditBillState>(
      builder: (context, state, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(bottom: 15),
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
            const PanelHeading(
              heading: "Rechnungsinformationen",
              padding: 0,
            ),
            TextInputField(
              verticalMargin: textfieldMargin,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.,]")),
              ],
              readonly: !state.isEditing,
              controller: state.moneySumController,
              helperText: "Rechnungsbetrag (in ???) *",
              type: TextInputType.number,
              focusNode: FocusNode(),
            ),
            TextInputField(
              verticalMargin: textfieldMargin,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
              ],
              readonly: !state.isEditing,
              onTap: () => _selectDate(context),
              controller: state.selectedDateController,
              helperText: "Rechnungsdatum *",
              type: TextInputType.none,
              focusNode: FocusNode(),
            ),
            TextInputField(
              verticalMargin: textfieldMargin,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp("[0-9a-zA-Z.,&??????????!# ]"),
                ),
              ],
              readonly: !state.isEditing,
              controller: state.descriptionController,
              helperText: "Beschreibung",
              maxChars: 160,
              type: TextInputType.multiline,
              focusNode: FocusNode(),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DropdownButton<int>(
                value: state.categorySelection,
                isExpanded: true,
                borderRadius: BorderRadius.circular(6),
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Theme.of(context).primaryColor),
                underline: Container(
                  height: 2,
                  color: state.isEditing
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                onChanged: state.isEditing
                    ? (int? newValue) {
                        state.setCategorySelection(newValue!);
                      }
                    : null,
                items: state.isEditing
                    ? List.generate(
                        billCategories.length,
                        (index) => DropdownMenuItem<int>(
                          value: index,
                          child: Text(billCategories[index].billCategoryName!),
                        ),
                      )
                    : [
                        DropdownMenuItem<int>(
                          value: state.categorySelection,
                          child: Text(billCategories[state.categorySelection]
                              .billCategoryName!),
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
