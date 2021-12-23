import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/roundcheckbox.dart';

class PendingTaskTile extends StatelessWidget {
  final int listIndex;
  final String taskName;
  final Function onTaskFinished;

  const PendingTaskTile({ Key? key, required this.listIndex ,required this.taskName, required this.onTaskFinished }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: RoundCheckbox(
          initialValue: false,
          onChanged: (newValue){
            if(newValue){
              onTaskFinished(listIndex);
            }
          },
        ),
        title: Text(
          taskName,
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: Colors.grey.shade700,), 
          itemBuilder: (context) => [
            const PopupMenuItem(
              child: Text("Abschließen"),
              value: 1,
            ),
            const PopupMenuItem(
              child: Text("Ändern"),
              value: 2,
            ),
            const PopupMenuItem(
              child: Text("Löschen"),
              value: 2,
            ),
            const PopupMenuItem(
              child: Text("Zuweisen"),
              value: 2,
            ),
          ]
        ),
      ),
    );
  }
}