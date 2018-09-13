import 'dart:async';

import 'package:redux_epics/redux_epics.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './state.dart';

class IncrementCounterAction {}

class TestCounterAction {}

class CounterDataPushedAction {}

class RequestCounterDataEventsAction {
  // @override
  // String toString() => 'RequestCounterDataEventsAction{test:}';
}

class CancelCounterDataEventsAction {}

class CounterOnDataEventAction {
  final int counter;

  CounterOnDataEventAction(this.counter);

  @override
  String toString() => 'CounterOnDataEventAction{counter: $counter}';
}

class CounterOnErrorEventAction {
  final dynamic error;

  CounterOnErrorEventAction(this.error);

  @override
  String toString() => 'CounterOnErrorEventAction{error: $error}';
}

final counterReducer = combineReducers<int>([
  new TypedReducer<int, CounterOnDataEventAction>(_setCounter),
]);

Stream<dynamic> incrementEpic(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<IncrementCounterAction>())
      .flatMap((_) {
    return new Observable.fromFuture(Firestore.instance
        .collection('users')
        .document('tudor')
        .updateData({'counter': store.state.counter + 1})
        .then((_) => new CounterDataPushedAction())
        .catchError((error) => new CounterOnErrorEventAction(error)));
  });
}

Stream<dynamic> counterEpic(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions) // 1
      .ofType(new TypeToken<RequestCounterDataEventsAction>()) // 2
      .switchMap((RequestCounterDataEventsAction requestAction) {
    // 3R
    return getUserClicks() // 4
        .map((counter) => new CounterOnDataEventAction(counter)) // 7
        .takeUntil(actions
            .where((action) => action is CancelCounterDataEventsAction)); // 8
  });
}

Observable<int> getUserClicks() {
  // print('Trigger Once Why ??? น่าจะเพราะ OnInit เรียกมั้ง ???');

  return new Observable(Firestore.instance
          .collection('users')
          .document('tudor')
          .snapshots()) // 5
      .map((DocumentSnapshot doc) => doc['counter'] as int); // 6
}

int _setCounter(int oldCounter, CounterOnDataEventAction action) {
  // print(action);
  // เริ่มต้นมา oldCounter เป็น 0 นร้าาา
  // print(oldCounter);
  return action.counter;
}
