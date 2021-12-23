import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/homepage/tasks/pendingtasktile.dart';

class PendingTasksPanel extends StatefulWidget {
  const PendingTasksPanel({ Key? key }) : super(key: key);

  @override
  _PendingTasksPanelState createState() => _PendingTasksPanelState();
}

class _PendingTasksPanelState extends State<PendingTasksPanel> {
  late List<String> tasks;

  @override
  void initState() {
    super.initState();
    tasks = List.generate(3, (index) => "Aufgabe $index");
  }

  void removeTaskFromList(int index){
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Deine austehenden Aufgaben",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          ListView.builder(
            itemCount: tasks.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return PendingTaskTile(
                key: Key(tasks[index]), //Damit die Checkboxen richtig gerendert werden wenn eine Task beendet wird! 
                listIndex: index,
                onTaskFinished: removeTaskFromList,
                taskName: tasks[index],
              );
            },
          ),
        ],
      ),
    );
  }
}