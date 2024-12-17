import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: RepositoryProvider<QuotesRepository>(
        lazy: true,
        create: (_) => QuotesRepository(),
        child: BlocProvider<HomeBloc>(
          lazy: false,
          create: (context) => HomeBloc(context.read<QuotesRepository>()),
          child: const MyHomePage(title: "Цитаты",),
        ),
      ),
    );
  }
}
