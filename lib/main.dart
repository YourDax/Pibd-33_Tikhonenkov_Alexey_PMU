import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_flutter_labs/presentation/home_page/bloc/events.dart';
import 'package:pmu_flutter_labs/presentation/like_bloc/like_bloc.dart';
import 'package:pmu_flutter_labs/presentation/locale_bloc/locale_bloc.dart';
import 'package:pmu_flutter_labs/presentation/locale_bloc/locale_state.dart';
import 'components/locale/l10n/app_locale.dart';
import 'data/repositories/quotes_repository.dart';
import '/presentation/home_page/bloc/bloc.dart';
import '/presentation/home_page/home_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      lazy: false,
      create:(context) => LocaleBloc(Locale(Platform.localeName)),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Цитаты',
            locale: state.currentLocale,
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
            ),
            home: RepositoryProvider<QuotesRepository>(
              lazy: true,
              create: (_) => QuotesRepository(),
              child: BlocProvider<LikeBloc>(
                lazy: false,
                create: (context) => LikeBloc(), // Add LikeBloc here
                child: BlocProvider<HomeBloc>(
                  lazy: false,
                  create: (context) => HomeBloc(context.read<QuotesRepository>()),
                  child: const MyHomePage(title: "Цитаты"),
                ),
              ),
            ),
          );
        }
    ),
    );
  }
}

