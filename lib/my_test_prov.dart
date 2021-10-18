import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum MyTestStatus {
  initial,
  loading,
  success,
  error,
}

class MyTestState extends Equatable {
  final MyTestStatus status;
  MyTestState({
    required this.status,
  });

  @override
  List<Object> get props => [status];

  @override
  bool get stringify => true;

  MyTestState copyWith({
    MyTestStatus? status,
  }) {
    return MyTestState(
      status: status ?? this.status,
    );
  }
}

class MyTest with ChangeNotifier {
  MyTestState _state = MyTestState(status: MyTestStatus.initial);
  MyTestState get state => _state;

  Future<void> doSomething() async {
    _state = _state.copyWith(status: MyTestStatus.loading);
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));
    final int myRandom = Random().nextInt(100);

    print('myRandom: $myRandom');

    try {
      if (myRandom % 2 != 0) {
        throw 'Not an even, error!';
      }
      _state = _state.copyWith(status: MyTestStatus.success);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(status: MyTestStatus.error);
      notifyListeners();
    }
  }
}
