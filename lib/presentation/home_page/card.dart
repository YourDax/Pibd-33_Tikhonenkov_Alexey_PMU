import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/quote.dart';
import '../like_bloc/like_bloc.dart';
import '../like_bloc/like_state.dart';
import 'home_page.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavoriteToggle;

  const QuoteCard({Key? key, required this.quote, required this.onFavoriteToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quote.text,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              '- ${quote.author}',
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: onFavoriteToggle,
                  icon: BlocBuilder<LikeBloc, LikeState>(
                    builder: (context, state) {
                      final isLiked = state.likedIds?.contains(quote.id) ?? false;
                      return Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      );
                    },
                  ),
                  label: BlocBuilder<LikeBloc, LikeState>(
                    builder: (context, state) {
                      final isLiked = state.likedIds?.contains(quote.id) ?? false;
                      return Text(isLiked ? 'Убрать из избранного' : 'Добавить в избранное');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteDetailScreen extends StatelessWidget {
  final Quote quote;

  const QuoteDetailScreen({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали цитаты'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                quote.imagePath,
                height: 150,
                errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Text(
                quote.text,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '- ${quote.author}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
