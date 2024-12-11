import '/data/dtos/quotes_dto.dart';
import '/main.dart';

const _imagePlaceholder =
    'https://cdn-icons-png.flaticon.com/128/17818/17818874.png';

extension QuoteDtoToModel on QuoteDataDto {
  Quote toDomain() => Quote(
    text ?? 'Без текста',
    author ?? 'Неизвестный автор',
    imageUrl ?? _imagePlaceholder,
  );
}