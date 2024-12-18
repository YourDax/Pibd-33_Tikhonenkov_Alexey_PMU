import 'package:flutter/material.dart';
import 'package:pmu_flutter_labs/components/extensions/context_x.dart';
import '../../domain/quote.dart';
import 'home_page.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavoriteToggle;
  final bool isLiked;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.onFavoriteToggle,
    required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 10.0,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: SizedBox(
          width: 50.0,
          child: Image.network(
            quote.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.red),
          ),
        ),
        title: Text(
          quote.text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Text('- ${quote.author}'),
        trailing: IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuoteDetailScreen(quote: quote),
            ),
          );
        },
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
        title: Text(context.locale.details),
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
