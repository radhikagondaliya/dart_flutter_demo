import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tasks/taskItem_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Task Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TaskM> taskList = [];

  Stopwatch watch = Stopwatch();
  late Timer _timer;

  String elapsedTime = '';
  String finalTime = '0';
  bool startOrStopTask = true;
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // taskList.add(TaskM(isSelectedTask: false, taskName: "task1", taskRunningStatus: "0"));
    // taskList.add(TaskM(isSelectedTask: false, taskName: "task2", taskRunningStatus: "0"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Visibility(
            visible: taskList.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                _openDialog();
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          )
        ],
      ),
      body: taskList.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: taskList[index],
                  index: index,
                  runningStatus: finalTime,
                  onTaskTap: () {
                    startOrStopTaskTimer(index: index);
                  },
                );
              },
            )
          : const Center(
              child: Text(
                "Create your task",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
      floatingActionButton: Visibility(
        visible: taskList.isEmpty,
        child: FloatingActionButton.extended(
          onPressed: () {
            _openDialog();
          },
          tooltip: 'Create Task',
          icon: const Icon(Icons.add),
          label: const Text("Create Task"),
        ),
      ),
    );
  }

  startOrStopTaskTimer({required int index}) {
    if (!taskList[index].isSelectedTask) {
      setState(() {
        taskList[index].isSelectedTask = true;
      });

      startWatch(index: index);
    } else {
      setState(() {
        taskList[index].isSelectedTask = false;
      });

      stopWatch(index: index);
      setState(() {
        taskList[index].taskRunningStatus = elapsedTime;
      });
    }
  }

  startWatch({required int index}) {
    setState(() async {
      // startOrStopTask = false;
      taskList[index].taskRunningStatus = '0';
      watch.reset();
      watch.start();
      _timer = await Timer.periodic(const Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch({required int index}) {
    setState(() {
      // startOrStopTask = true;
      watch.stop();
      setTime(index);
    });
  }

  setTime(int index) {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
      taskList[index].taskRunningStatus = elapsedTime;
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    setState(() {
      finalTime = '$hoursStr:$minutesStr:$secondsStr';
    });
    return finalTime;
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                "Add task",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller,
                maxLines: 1,
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'Task',
                  icon: Icon(
                    Icons.add_task,
                    color: Colors.grey,
                  ),
                ),
                validator: (value) => value != null && value.isEmpty ? 'Email can\'t be empty' : null,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Container(
                    height: 30,
                    width: 90,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        taskList.add(
                            TaskM(taskName: controller.text, taskRunningStatus: "0", isSelectedTask: false));
                      });

                      controller.clear();
                    }
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class TaskM {
  final String taskName;
  String taskRunningStatus;
  bool isSelectedTask;

  TaskM({required this.taskName, required this.taskRunningStatus, required this.isSelectedTask});
}
