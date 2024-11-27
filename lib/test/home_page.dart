import 'package:flutter/material.dart';
import './quote_card.dart';

class Quote {
  final String text;
  final String author;
  final String imagePath;
  bool isFavorite;

  Quote(this.text, this.author, this.imagePath, [this.isFavorite = false]);

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController quoteTextController = TextEditingController();
  final TextEditingController quoteAuthorController = TextEditingController();

  final List<Quote> _quotes = [];
  final String defaultImagePath =
      'https://cdn-icons-png.flaticon.com/128/17818/17818874.png';

  @override
  void initState() {
    super.initState();
    _quotes.addAll([
      Quote(
        'Сила воли — это ключ к успеху.',
        'Аноним',
        'https://cdn-icons-png.flaticon.com/128/17818/17818880.png',
      ),
      Quote(
        'Вера в себя — это первый шаг к победе.',
        'Аноним',
        'https://cdn-icons-png.flaticon.com/128/17818/17818889.png',
      ),
      Quote(
        'Не бойся быть отличным, бойся быть обычным.',
        'Аноним',
        'https://cdn-icons-png.flaticon.com/128/17818/17818899.png',
      ),
    ]);
  }

  void _addQuote() {
    setState(() {
      final newQuote = Quote(
        quoteTextController.text.addQuotesIfMissing().capitalize(),
        quoteAuthorController.text.capitalize(),
        defaultImagePath,
      );
      _quotes.add(newQuote);
      quoteTextController.clear();
      quoteAuthorController.clear();
    });
  }

  void _removeQuote(int index) {
    setState(() {
      _quotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цитаты'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Список цитат',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: _quotes.isEmpty
                ? const Center(
              child: Text(
                'Нет добавленных цитат. Добавьте первую!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                return QuoteCard(
                  quote: _quotes[index],
                  onDelete: () => _removeQuote(index),
                  onFavoriteToggle: () {
                    setState(() {
                      _quotes[index].toggleFavorite();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Новая цитата'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: quoteTextController,
                      decoration: const InputDecoration(
                        hintText: 'Введите текст цитаты',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: quoteAuthorController,
                      decoration: const InputDecoration(
                        hintText: 'Введите автора цитаты',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _addQuote();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Добавить'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Добавить цитату',
        child: const Icon(Icons.format_quote),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
      return word;
    }).join(' ');
  }

  String addQuotesIfMissing() {
    if (startsWith('\"') && endsWith('\"')) return this;
    if (startsWith('\"') && !endsWith('\"')) return '$this\"';
    if (endsWith('\"') && !startsWith('\"')) return '\"$this';
    return '\"$this\"';
  }
}
