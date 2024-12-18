import 'package:dio/dio.dart';
import '../../domain/quote.dart';
import '/data/dtos/quotes_dto.dart';
import '/data/mappers/quotes_mapper.dart';
import '/data/repositories/api_interface.dart';
import '/presentation/home_page/home_page.dart';
import '/presentation/dialogs/show_dialog.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class QuotesRepository extends ApiInterface {
  static final Dio _dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ))
    ..options.headers = {
      'Authorization': 'Bearer 82ccaa45c8344de4ac008b2487d33361',
    };

  static const String _baseUrl = 'https://favqs.com/api';

  @override
  Future<List<Quote>?> loadData({String? q, String? author, OnErrorCallback? onError}) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (q != null && q.isNotEmpty) {
        queryParams['filter'] = q;
      }

      if (author != null && author.isNotEmpty) {
        queryParams['type'] = 'author';
        queryParams['filter'] = author;
      }

      const String url = '$_baseUrl/quotes';

      final Response<dynamic> response = await _dio.get<Map<dynamic, dynamic>>(
        url,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final QuotesDto dto = QuotesDto.fromJson(response.data as Map<String, dynamic>);
      final List<Quote>? data = dto.quotes?.map((e) => e.toDomain()).toList();
      return data;
    } on DioException catch (e) {
      onError?.call(e.response?.statusMessage);
      return null;
    }
  }
}
