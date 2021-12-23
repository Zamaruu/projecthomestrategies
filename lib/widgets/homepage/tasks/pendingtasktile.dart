import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/roundcheckbox.dart';

class PendingTaskTile extends StatelessWidget {
  final String taskName;
  
  const PendingTaskTile({ Key? key, required this.taskName }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: RoundCheckbox(
          initialValue: false,
          onChanged: (newValue){
            print(newValue);
          },
        ),
        title: Text(
          taskName,
        ),
      ),
    );
  }
}