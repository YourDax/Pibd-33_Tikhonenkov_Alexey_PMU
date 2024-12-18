import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocaleEn extends AppLocale {
  AppLocaleEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Quotes';

  @override
  String get search_word => 'Search by word';

  @override
  String get search_author => 'Search by author';

  @override
  String get liked => 'Like :)';

  @override
  String get disliked => 'Dislike :(';

  @override
  String get error => 'Error :C';

  @override
  String get details => 'Details of quote';

  @override
  String get arbEnding => '';
}
