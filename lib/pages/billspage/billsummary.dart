import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/billspage/thirtydayretro.dart';

class BillsSummary extends StatelessWidget {
  const BillsSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BillRetrospect.withSampleData(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Neue Rechnung erstellen",
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
