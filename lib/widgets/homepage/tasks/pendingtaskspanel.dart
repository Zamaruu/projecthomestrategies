import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/homepage/tasks/pendingtasktile.dart';

class PendingTasksPanel extends StatefulWidget {
  const PendingTasksPanel({ Key? key }) : super(key: key);

  @override
  _PendingTasksPanelState createState() => _PendingTasksPanelState();
}

class _PendingTasksPanelState extends State<PendingTasksPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return PendingTaskTile(taskName: "Aufgabe $index");
        },
      ),
    );
  }
}