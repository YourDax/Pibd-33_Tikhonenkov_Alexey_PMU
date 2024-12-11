import 'package:dio/dio.dart';
import '/data/dtos/quotes_dto.dart';
import '/data/mappers/quotes_mapper.dart';
import '/data/repositories/api_interface.dart';
import '/main.dart';
import '/data/presentation/dialogs/show_dialog.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class QuotesRepository extends ApiInterface {
  static final Dio _dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ))
    ..options.headers = {
      'Authorization': 'Bearer 82ccaa45c8344de4ac008b2487d33361', // Add the API key here
    };

  static const String _baseUrl = 'https://favqs.com/api';

  @override
  Future<List<Quote>?> loadData({String? q, OnErrorCallback? onError}) async {
    try {
      const String url = '$_baseUrl/quotes';

      final Response<dynamic> response = await _dio.get<Map<dynamic, dynamic>>(
        url,
        queryParameters: q != null ? {'filter[text_cont]': q} : null,
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
