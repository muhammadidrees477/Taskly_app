class Task {
  String content;
  DateTime timestamp;
  bool done;

  Task({required this.content, required this.timestamp, required this.done});

  factory Task.froMap(Map task) {
    return Task(
      content: task["content"],
      timestamp: task["timestamp"],
      done: task["done"],
    );
  }

  Map toMap() {
    return {
      "content": content,
      "timestamp": timestamp,
      "done": done,
    };
  }
}


// class Task {
//   String content;
//   DateTime timestamp;
//   bool done;
//   Task({required this.content, required this.timestamp, required this.done});
//   factory Task.froMap(Map task) {
//     return Task(
//         content: task["content"],
//         timestamp: task["timestamp"],
//         done: task["done"]);
//   }
//   Map toMap() {
//     return {"content": content, "timestamp": timestamp, "done": done};
//   }
// }
