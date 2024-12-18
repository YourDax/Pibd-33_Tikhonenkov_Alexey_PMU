import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocaleRu extends AppLocale {
  AppLocaleRu([String locale = 'ru']) : super(locale);

  @override
  String get search => 'Поиск';

  @override
  String get liked => 'Круто :)';

  @override
  String get disliked => 'Не круто :с';

  @override
  String get arbEnding => '';
}
