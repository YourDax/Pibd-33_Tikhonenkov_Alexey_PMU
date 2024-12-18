import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_flutter_labs/presentation/home_page/bloc/events.dart';
import 'package:pmu_flutter_labs/presentation/like_bloc/like_bloc.dart';
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
    return MaterialApp(
      title: 'Цитаты',
      localizationsDelegates: AppLocale.localizationsDelegates,
      supportedLocales: AppLocale.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: RepositoryProvider<QuotesRepository>(
        lazy: true,
        create: (_) => QuotesRepository(),
        child: BlocProvider(
          create: (context) => LikeBloc(),  // Add LikeBloc here
          child: BlocProvider(
            create: (context) => HomeBloc(context.read<QuotesRepository>())
              ..add(const HomeLoadDataEvent()),  // Ensure initial load
            child: const MyHomePage(title: "Цитаты"),
          ),
        ),
      ),
    );
  }
}

