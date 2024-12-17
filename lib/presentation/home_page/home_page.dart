import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/utils/debounce.dart';
import '../../domain/quote.dart';
import '/data/repositories/quotes_repository.dart';
import '/presentation/home_page/bloc/bloc.dart';
import '/presentation/home_page/bloc/events.dart';
import '/presentation/home_page/bloc/state.dart';
import 'card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(QuotesRepository())..add(const HomeLoadDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const _HomePageBody(),
      ),
    );
  }
}

class _HomePageBody extends StatefulWidget {
  const _HomePageBody();

  @override
  State<_HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<_HomePageBody> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      Debounce.run(() {
        context.read<HomeBloc>().add(HomeLoadDataEvent(search: searchController.text));
      });
    });

    authorController.addListener(() {
      Debounce.run(() {
        context.read<HomeBloc>().add(HomeLoadDataEvent(
          search: searchController.text,
          author: authorController.text,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Поиск по цитате',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Поиск по автору',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Expanded(
              child: state.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<Quote>?>(
                future: state.data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Нет цитат для отображения.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  final quotes = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(HomeRefreshEvent(
                        search: searchController.text,
                        author: authorController.text,
                      ));
                    },
                    child: ListView.builder(
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        final quote = quotes[index];
                        return QuoteCard(
                          quote: quote,
                          onFavoriteToggle: () {
                            setState(() {
                              quote.toggleFavorite();
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
