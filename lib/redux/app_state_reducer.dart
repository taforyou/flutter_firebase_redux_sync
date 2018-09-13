//import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_redux_sync/redux/actions.dart';
import 'package:firebase_redux_sync/redux/app_state.dart';
import 'package:redux/redux.dart';
//import 'package:redux_epics/redux_epics.dart';
//import 'package:rxdart/rxdart.dart';


AppState appStateReducer(AppState state, dynamic action) {
  return new AppState(
    counter: counterReducer(state.counter, action),
    testFetch: testFetchReducer(state.testFetch, action),
  );
}

final counterReducer = combineReducers<int>([
  new TypedReducer<int, CounterOnDataEventAction>(_setCounter),
]);

final testFetchReducer = combineReducers<String>([
  new TypedReducer<String, RequestSearchDataEventsAction>(_setTestFetchReducer),
]);

int _setCounter(int oldCounter, CounterOnDataEventAction action) {
  // print(action);
  // เริ่มต้นมา oldCounter เป็น 0 นร้าาา
  // print(oldCounter);
  return action.counter;
}

String _setTestFetchReducer(String oldText, RequestSearchDataEventsAction action) {
  //print(oldText);
  //print('1122334455');
  // เริ่มต้นมา oldCounter เป็น 0 นร้าาา
  //print(oldCounter);
  print(action);
  return action.testFetch;
}


