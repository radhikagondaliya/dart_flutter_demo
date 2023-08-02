import 'package:flutter/material.dart';
import 'package:tasks/main.dart';

class TaskItem extends StatefulWidget {
  final TaskM task;
  final int index;
  final VoidCallback onTaskTap;
  final String runningStatus;

  const TaskItem({required this.task, required this.index, required this.onTaskTap, required this.runningStatus});

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTaskTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: widget.task.isSelectedTask
                ? Border.all(
                    color: Colors.green,
                  )
                : null,
            borderRadius: widget.task.isSelectedTask ? BorderRadius.circular(5) : null,
          ),
          child: Row(
            children: [
               Icon(
                Icons.task,
                color: widget.task.isSelectedTask ? Colors.red :Colors.green,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  widget.task.taskName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                widget.task.taskRunningStatus,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
