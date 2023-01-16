class Users {
  String? id;
  String? email;
  List<String>? roles;

  Users({this.id, this.email, this.roles});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['roles'] = this.roles;
    return data;
  }
}