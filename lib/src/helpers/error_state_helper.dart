import 'dart:collection';

import 'package:flutter/foundation.dart';

mixin ErrorStateHelper on ChangeNotifier {
  final Map<int, bool> _busyStates = <int, bool>{};

  bool busy(Object? object) => _busyStates[object.hashCode] ?? false;

  bool get isBusy => busy(this);

  bool get anyObjectsBusy => _busyStates.values.any((busy) => busy);


  void setBusyForObject(Object? object, bool value) {
    _busyStates[object.hashCode] = value;
    notifyListeners();
  }

  void setBusy(bool value) {
    setBusyForObject(this, value);
  }

  T skeletonData<T>(
      {required T? realData, required T busyData, Object? busyKey}) {

    bool isBusyKeySupplied = busyKey != null;
    if ((isBusyKeySupplied && busy(busyKey)) || realData == null) {
      return busyData;
    } else if (!isBusyKeySupplied && isBusy) {
      return busyData;
    }

    return realData;
  }

  Future<T> runBusyFuture<T>(Future<T> busyFuture,
      {Object? busyObject, bool throwException = false}) async {
    _setBusyForModelOrObject(true, busyObject: busyObject);
    try {
      var value = await runErrorFuture<T>(busyFuture,
          key: busyObject, throwException: throwException);
      return value;
    } catch (e) {
      if (throwException) rethrow;
      return Future.value();
    } finally {
      _setBusyForModelOrObject(false, busyObject: busyObject);
    }
  }

  void _setBusyForModelOrObject(bool value, {Object? busyObject}) {
    if (busyObject != null) {
      setBusyForObject(busyObject, value);
    } else {
      setBusyForObject(this, value);
    }
  }

  final LinkedHashMap<int, dynamic> _errorStates =
      LinkedHashMap<int, dynamic>();
  dynamic error(Object object) => _errorStates[object.hashCode];

  bool get hasError => error(this) != null;

  bool get hasAnyError =>
      _errorStates.entries.isNotEmpty &&
      _errorStates.entries.any((element) => element.value != null);

  dynamic get currentError => _errorStates.entries.last.value;

  dynamic get modelError => error(this);

  /// Clears all the errors
  void clearErrors() {
    _errorStates.clear();
  }

  bool hasErrorForKey(Object key) => error(key) != null;

  void setError(dynamic error) {
    setErrorForObject(this, error);
  }

  void setErrorForModelOrObject(dynamic value, {Object? key}) {
    if (key != null) {
      setErrorForObject(key, value);
    } else {
      setErrorForObject(this, value);
    }
  }

  void setErrorForObject(Object object, dynamic value) {
    _errorStates[object.hashCode] = value;
    notifyListeners();
  }

  Future<T> runErrorFuture<T>(Future<T> future,
      {Object? key, bool throwException = false}) async {
    try {
      setErrorForModelOrObject(null, key: key);
      return await future;
    } catch (e) {
      setErrorForModelOrObject(e, key: key);
      onFutureError(e, key);
      if (throwException) rethrow;
      return Future.value();
    }
  }

  void onFutureError(dynamic error, Object? key) {}
}
