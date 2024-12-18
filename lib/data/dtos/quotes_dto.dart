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
  final String? body;
  final String? author;
  final String? imageUrl;
  final dynamic id;
  final bool? isLiked;

  const QuoteDataDto({this.body, this.author, this.imageUrl, this.id, this.isLiked});

  factory QuoteDataDto.fromJson(Map<String, dynamic> json) => _$QuoteDataDtoFromJson(json);
}
