import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_redux_sync/redux/actions.dart';
import 'package:firebase_redux_sync/redux/app_state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
// เอา fetch มาใช้
// ลอง Mockaoi.io
// ลอง เอาอากาศ
// ลอง เอาค่าเงิน Bitcoin
// ลองเอาเบียร์ punk.io อะไรสักอย่างของพี่ปุ้ย
// https://jsonplaceholder.typicode.com/
import 'package:http/http.dart' as http;



final allEpics = combineEpics<AppState>([counterEpic, incrementEpic, searchEpic]);

Stream<dynamic> searchEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
    .where((action) => action is RequestSearchDataEventsAction)
    .asyncMap((action) => fetchPost(store));
    // พังอ่า งงหว่ะ ???
    //.asyncMap((action) => fetchPost(store).then((_temp) => new RequestSearchDataEventsAction(_temp.toString())));
}

Stream<dynamic> incrementEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<IncrementCounterAction>())
      .flatMap((_) {
    return new Observable.fromFuture(Firestore.instance.collection('users').document('tudor')
        .updateData({'counter': store.state.counter + 1})
        .then((_) => new CounterDataPushedAction())
        .catchError((error) => new CounterOnErrorEventAction(error)));
  });
}

Stream<dynamic> counterEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions) // 1
      .ofType(new TypeToken<RequestCounterDataEventsAction>()) // 2
      .switchMap((RequestCounterDataEventsAction requestAction) { // 3R
    return getUserClicks() // 4
        .map((counter) => new CounterOnDataEventAction(counter)) // 7
        .takeUntil(actions.where((action) => action is CancelCounterDataEventsAction)); // 8
  });
}
// จะมั่วมามั่วตรงนี้ #0
//Stream<dynamic> _search(String term) async* 
Stream<dynamic> testEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions) // 1
      .ofType(new TypeToken<TestCounterAction>()) // 2
      .switchMap((TestCounterAction requestAction) { // 3R
    return getTestCount() // 4
        .map((counter) => new CounterOnDataEventAction(counter)) // 7
        .takeUntil(actions.where((action) => action is CancelCounterDataEventsAction)); // 8
  });
}

Observable<int> getUserClicks() {
  print('Trigger Once Why ??? น่าจะเพราะ OnInit เรียกมั้ง ???');
  return new Observable(Firestore.instance.collection('users').document('tudor').snapshots()) // 5
      .map((DocumentSnapshot doc) => doc['counter'] as int); // 6
}
// มั่วต่อ
Observable<int> getTestCount() {
  //print('Trigger Once Why ???');
  return new Observable(Firestore.instance.collection('users').document('tudor').snapshots()) // 5
      .map((DocumentSnapshot doc) => doc['counter'] as int); // 6
}



Future<Post> fetchPost(EpicStore<AppState> _store) async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    // ได้ล่ะ งง มากกกก แต่ช่างมันสายโหดต้องอดทน !!!
    // print(response.body.toString());
    // print(_store.state.counter);
    //_store.state.testFetch = '112233';
    //return _store.state.testFetch = '11233';

    // เป้าหมาย
    //return RequestSearchDataEventsAction('111');
    //return Post.fromJson(json.decode(response.body));
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

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
