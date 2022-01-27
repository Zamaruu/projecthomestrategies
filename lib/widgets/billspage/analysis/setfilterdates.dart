import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/analysis_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class AnalysisFilter extends StatelessWidget {
  const AnalysisFilter({Key? key}) : super(key: key);

  Future<void> _selectDate(
    BuildContext context,
    DateTime initialDate,
    bool isStartDate,
  ) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("de", "DE"),
        initialDate: initialDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      if (isStartDate) {
        if (picked.isBefore(context.read<AnalysisState>().endDate)) {
          context.read<AnalysisState>().setStartDate(picked);
        }
      } else {
        if (picked.isAfter(context.read<AnalysisState>().startDate)) {
          context.read<AnalysisState>().setEndDate(picked);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalysisState>(
      builder: (context, state, _) {
        return SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text("Startdatum:"),
                  TextButton(
                    onPressed: () => _selectDate(
                      context,
                      state.startDate,
                      true,
                    ),
                    child: Text(Global.datetimeToDeString(state.startDate)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Enddatum:"),
                  TextButton(
                    onPressed: () => _selectDate(
                      context,
                      state.endDate,
                      false,
                    ),
                    child: Text(Global.datetimeToDeString(state.endDate)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
