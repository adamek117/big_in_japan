class Boards {
  String? id;
  String? name;
  String? color;
  String? owner;
  List<Columns>? columns;

  Boards({this.id, this.name, this.color, this.owner, this.columns});

  Boards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    owner = json['owner'];
    if (json['columns'] != null) {
      columns = <Columns>[];
      json['columns'].forEach((v) {
        columns!.add(new Columns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['owner'] = this.owner;
    if (this.columns != null) {
      data['columns'] = this.columns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Columns {
  String? id;
  String? name;
  String? color;
  List<Tasks>? tasks;

  Columns({this.id, this.name, this.color, this.tasks});

  Columns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  String? id;
  String? name;

  Tasks({this.id, this.name});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
