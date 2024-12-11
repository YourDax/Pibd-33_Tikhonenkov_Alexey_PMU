// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuotesDto _$QuotesDtoFromJson(Map<String, dynamic> json) => QuotesDto(
      quotes: (json['quotes'] as List<dynamic>?)
          ?.map((e) => QuoteDataDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

QuoteDataDto _$QuoteDataDtoFromJson(Map<String, dynamic> json) => QuoteDataDto(
      text: json['text'] as String?,
      author: json['author'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
