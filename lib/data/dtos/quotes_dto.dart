import 'package:json_annotation/json_annotation.dart';

part 'quotes_dto.g.dart';

@JsonSerializable(createToJson: false)
class QuotesDto {
  final List<QuoteDataDto>? quotes;

  const QuotesDto({this.quotes});

  factory QuotesDto.fromJson(Map<String, dynamic> json) => _$QuotesDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class QuoteDataDto {
  final String? text;
  final String? author;
  final String? imageUrl;

  const QuoteDataDto({this.text, this.author, this.imageUrl});

  factory QuoteDataDto.fromJson(Map<String, dynamic> json) => _$QuoteDataDtoFromJson(json);
}