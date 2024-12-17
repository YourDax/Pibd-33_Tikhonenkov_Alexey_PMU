import '../../domain/quote.dart';
import '/data/dtos/quotes_dto.dart';
import '/presentation/home_page/home_page.dart';

const _imagePlaceholder =
    'https://cdn-icons-png.flaticon.com/128/17818/17818874.png';

extension QuoteDtoToModel on QuoteDataDto {
  Quote toDomain() => Quote(
    body ?? 'Без текста',
    author ?? 'Неизвестный автор',
    imageUrl ?? _imagePlaceholder,
  );
}