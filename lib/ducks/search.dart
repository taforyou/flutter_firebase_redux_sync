import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux_epics/redux_epics.dart';
import 'package:redux/redux.dart';

import 'state.dart';

// -- Data Type --

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

// -- Actions --

class SearchAction {
  final String query;

  SearchAction(this.query);
}

class SetPostsAction {
  final List<Post> data;

  SetPostsAction(this.data);
}

// -- Reducer --

final queryReducer = new TypedReducer<String, SearchAction>(_setSearchReducer);
final postsReducer =
    new TypedReducer<List<Post>, SetPostsAction>(_setPostsReducer);

String _setSearchReducer(state, SearchAction action) {
  return action.query;
}

List<Post> _setPostsReducer(List<Post> response, SetPostsAction action) {
  print("First Title is ${action.data[0].title}");

  return action.data;
}

// -- Helper --

Future<List<Post>> fetchPost() async {
  final url = 'https://5b9a3ca9d203ad0014619c71.mockapi.io/posts';
  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Failed to load post');
  }

  List list = json.decode(response.body);

  return list.map((p) => Post.fromJson(p)).toList();
}

// -- Epic --
// ถ้ามี Action ใหม่เข้ามา ให้เรียก Function นี้
// โดยที่ Function นี้ มี Side Effect
// เช่น ดึงข้อมูล, เซ็ตข้อมูลใน Firestore

Stream<dynamic> searchEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  print("Search Epic");

  return actions
      .where((action) => action is SearchAction)
      .asyncMap((action) => fetchPost())
      .map((data) => new SetPostsAction(data));
}
