import '../../domain/quote.dart';
import '/presentation/home_page/home_page.dart';

typedef OnErrorCallback = void Function(String? error);

abstract class ApiInterface {
  Future<List<Quote>?> loadData({OnErrorCallback? onError});
}
