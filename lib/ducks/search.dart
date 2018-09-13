import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux_epics/redux_epics.dart';
import 'package:redux/redux.dart';

import 'state.dart';

// -- Data Type --

class Post {
  final int userId;
  final int id;
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

class SetSearchDataAction {
  final String data;

  SetSearchDataAction(this.data);
}

// -- Reducer --

final searchReducer = combineReducers<String>([
  new TypedReducer<String, SearchAction>(_setSearchReducer),
  new TypedReducer<String, SetSearchDataAction>(_setSearchDataReducer)
]);

String _setSearchReducer(String oldText, SearchAction action) {
  return action.query;
}

String _setSearchDataReducer(String response, SetSearchDataAction action) {
  // print("Data is ${action.data}");

  return action.data;
}

// -- Helper --

Future<Post> fetchPost(EpicStore<AppState> _store) async {
  final url = 'https://jsonplaceholder.typicode.com/posts/1';
  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Failed to load post');
  }

  return Post.fromJson(json.decode(response.body));
}

// -- Epic --
// ถ้ามี Action ใหม่เข้ามา ให้เรียก Function นี้
// โดยที่ Function นี้ มี Side Effect
// เช่น ดึงข้อมูล, เซ็ตข้อมูลใน Firestore

Stream<dynamic> searchEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  print("Search Epic");

  return actions
      .where((action) => action is SearchAction)
      .asyncMap((action) => fetchPost(store))
      .map((data) => new SetSearchDataAction(data.body));
}
