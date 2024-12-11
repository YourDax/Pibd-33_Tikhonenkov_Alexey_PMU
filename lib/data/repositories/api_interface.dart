import '/main.dart';

typedef OnErrorCallback = void Function(String? error);

abstract class ApiInterface {
  Future<List<Quote>?> loadData({OnErrorCallback? onError});
}
