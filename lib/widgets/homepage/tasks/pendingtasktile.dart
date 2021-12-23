import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/roundcheckbox.dart';

class PendingTaskTile extends StatefulWidget {
  final int listIndex;
  final String taskName;
  final Function onTaskFinished;

  const PendingTaskTile({ Key? key, required this.listIndex ,required this.taskName, required this.onTaskFinished }) : super(key: key);

  @override
  State<PendingTaskTile> createState() => _PendingTaskTileState();
}

class _PendingTaskTileState extends State<PendingTaskTile> {
  late bool dismissed;

  @override
  void initState() {
    dismissed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: dismissed? 0.0: 1.0,
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: RoundCheckbox(
            initialValue: false,
            onChanged: (newValue){
              if(newValue){
                setState(() {
                  dismissed = true;
                });
                Future.delayed(const Duration(milliseconds: 700), () => widget.onTaskFinished(widget.listIndex));
              }
            },
          ),
          title: Text(
            widget.taskName,
          ),
          subtitle: const Text(
            "Von SP, fällig um 14.00 Uhr"
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
      ),
    );
  }
}