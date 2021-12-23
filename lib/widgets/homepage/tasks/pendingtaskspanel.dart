import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:projecthomestrategies/widgets/homepage/basiclistcontainer.dart';
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
    return HomepageListContainer(
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
          tasks.isNotEmpty?
            AnimationLimiter(
              child: ListView.builder(
                itemCount: tasks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: PendingTaskTile(
                          key: Key(tasks[index]), //Damit die Checkboxen richtig gerendert werden wenn eine Task beendet wird! 
                          listIndex: index,
                          onTaskFinished: removeTaskFromList,
                          taskName: tasks[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ):
            const SizedBox(
              height: 75,
              child: Center(
                child: Text(
                  "Du hast keine ausstehenden Aufgaben.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}