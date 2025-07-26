// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _devoichieght;
  //  _devoicwidth;
  String? _newtaskcontent;
  _HomePageState();
  Box? _box;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _devoichieght = MediaQuery.of(context).size.height;
    // _devoicwidth = MediaQuery.of(context).size.width;
    print("Input Value: $_newtaskcontent");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        toolbarHeight: _devoichieght * 0.15,
        title: const Text(
          "Taskly",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
        future: Hive.openBox('tasks'),
        // future: Future.delayed(const Duration(seconds: 1)),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            _box = _snapshot.data;
            return _tasklist();
          } else {
            return  Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _tasklist() {
    // Task _newTask =
    //     Task(content: 'Eat Pizza', temestamp: DateTime.now(), done: false);
    // _box?.add(_newTask.toMap());
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var task = Task.froMap(tasks[index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(task.timestamp.toString()),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: Colors.red,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(
              index,
              task.toMap(),
            );
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            decoration: InputDecoration(hintText: "Enter task..."),
            onChanged: (_value) {
              setState(() {
                _newtaskcontent = _value;
              });
            },
            onSubmitted: (_value) {
              if (_value.trim().isNotEmpty) {
                var _task = Task(
                  content: _value.trim(),
                  timestamp: DateTime.now(),
                  done: false,
                );
                _box!.add(_task.toMap());
                Navigator.pop(context); // Close dialog
                setState(() {
                  _newtaskcontent = _value;
                });
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_newtaskcontent != null && _newtaskcontent!.trim().isNotEmpty) {
                  var _task = Task(
                    content: _newtaskcontent!.trim(),
                    timestamp: DateTime.now(),
                    done: false,
                  );
                  _box!.add(_task.toMap());
                  Navigator.pop(context);
                  setState(() {
                    _newtaskcontent = null;
                  });
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

// void _displayTaskPopup() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext _context) {
  //         return AlertDialog(
  //           title: const Text("Add New Task"),
  //           content: TextField(
  //             onSubmitted: (_value) {
  //               if (_newtaskcontent != null) {
  //                 var _task = Task(
  //                     content: _newtaskcontent!,
  //                     timestamp: DateTime.now(),
  //                     done: false);
  //                 _box!.add(_task.toMap());
  //                 Navigator.pop(context);
  //               }
  //             },
  //             onChanged: (_value) {
  //               setState(() {
  //                 _newtaskcontent = _value;
  //                 // Navigator.pop(context);
  //               });
  //             },
  //           ),
  //         );
  //       });
  // }
}
