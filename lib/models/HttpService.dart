import 'dart:convert';
import 'package:big_in_japan/models/users.dart';
import 'package:http/http.dart';

class HttpService {
  Future<List<User>> getPosts() async {
    final String userURL = 'http://localhost:3000/users';
    Response res = await get(Uri.parse(userURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<User> users = body
          .map(
            (dynamic item) => User.fromJson(item),
          )
          .toList();

      return users;
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}
