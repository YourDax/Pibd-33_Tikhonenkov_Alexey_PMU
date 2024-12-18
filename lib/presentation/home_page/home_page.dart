import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_flutter_labs/components/extensions/context_x.dart';
import 'package:pmu_flutter_labs/presentation/like_bloc/like_state.dart';
import '../../components/utils/debounce.dart';
import '../../domain/quote.dart';
import '../common/svg_objects.dart';
import '../like_bloc/like_bloc.dart';
import '../like_bloc/like_event.dart';
import '../locale_bloc/locale_bloc.dart';
import '../locale_bloc/locale_events.dart';
import '../locale_bloc/locale_state.dart';
import '/data/repositories/quotes_repository.dart';
import '/presentation/home_page/bloc/bloc.dart';
import '/presentation/home_page/bloc/events.dart';
import '/presentation/home_page/bloc/state.dart';
import 'card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  get searchController => null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(QuotesRepository())..add(const HomeLoadDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.locale.title),
              GestureDetector(
                onTap: () => context.read<LocaleBloc>().add(const ChangeLocaleEvent()),
                child: SizedBox.square(
                  dimension: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: BlocBuilder<LocaleBloc, LocaleState>(
                      builder: (context, state) {
                        return state.currentLocale.languageCode == 'ru'
                            ? const SvgRu()
                            : const SvgUk();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              child: _HomePageBody(),
            ),
          ],
        ),
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
    SvgObjects.init();
    super.initState();

    searchController.addListener(() {
      Debounce.run(() {
        context.read<HomeBloc>().add(HomeLoadDataEvent(
              search: searchController.text,
              author: authorController.text,
            ));
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
    context.read<HomeBloc>().add(const HomeLoadDataEvent());
    context.read<LikeBloc>().add(const LoadLikesEvent());
  }

  void _showSnackbar(BuildContext context, bool isLiked) {
    final message = isLiked ? context.locale.liked : context.locale.disliked;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
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
                decoration: InputDecoration(
                  labelText: context.locale.search_word,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: context.locale.search_author,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            BlocBuilder<LikeBloc, LikeState>(
              builder: (context, likeState) {
                return Expanded(
                  child: state.data == null
                      ? const Center(child: CircularProgressIndicator())
                      : FutureBuilder<List<Quote>?>(
                          future: state.data,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('${context.locale.error}: ${snapshot.error}'));
                            }
                            if (snapshot.data == null || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  context.locale.error,
                                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              );
                            }

                            final quotes = snapshot.data!;
                            final likedIds = likeState.likedIds ?? [];

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
                                  final isLiked = likedIds.contains(quote.id);

                                  return QuoteCard(
                                    quote: quote,
                                    isLiked: isLiked,
                                    onFavoriteToggle: () {
                                      context.read<LikeBloc>().add(ChangeLikeEvent(quote.id));
                                      _showSnackbar(context, !isLiked);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
