import 'package:my_mvvm/src/helpers/error_state_helper.dart';

mixin DataStateHelper<T> on ErrorStateHelper {
  T? _data;

  T? get data => _data;

  set data(T? data) {
    _data = data;
  }

  bool get dataReady => _data != null && !hasError && !isBusy;
}
