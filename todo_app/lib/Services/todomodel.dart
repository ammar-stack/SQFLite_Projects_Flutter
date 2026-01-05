class ToDoModel {
  int? id;
  String? todo;
  bool? isDone;

  ToDoModel({this.id, this.todo, this.isDone});

  ToDoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todo = json['todo'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['todo'] = this.todo;
    data['isDone'] = this.isDone;
    return data;
  }
}
