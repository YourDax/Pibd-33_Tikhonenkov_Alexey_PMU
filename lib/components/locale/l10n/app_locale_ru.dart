import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocaleRu extends AppLocale {
  AppLocaleRu([String locale = 'ru']) : super(locale);

  @override
  String get title => 'Цитаты';

  @override
  String get search_word => 'Поиск по слову';

  @override
  String get search_author => 'Поиск по автору';

  @override
  String get liked => 'Лайк :)';

  @override
  String get disliked => 'Дизлайк :(';

  @override
  String get error => 'Ошибка :C';

  @override
  String get details => 'Детали цитаты';

  @override
  String get arbEnding => '';
}
