import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Цитаты'),
    );
  }
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController quoteTextController = TextEditingController();
  final TextEditingController quoteAuthorController = TextEditingController();

  final List<Quote> _quotes = [];
  final String defaultImagePath =
      'https://cdn-icons-png.flaticon.com/128/17818/17818874.png';

  @override
  void initState() {
    super.initState();
    _quotes.add(Quote(
      'Сила воли — это ключ к успеху.',
      'Аноним',
      'https://cdn-icons-png.flaticon.com/128/17818/17818880.png',
    ));
    _quotes.add(Quote(
      'Вера в себя — это первый шаг к победе.',
      'Аноним',
      'https://cdn-icons-png.flaticon.com/128/17818/17818889.png',
    ));
    _quotes.add(Quote(
      'Не бойся быть отличным, бойся быть обычным.',
      'Аноним',
      'https://cdn-icons-png.flaticon.com/128/17818/17818899.png',
    ));
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
                final quote = _quotes[index];
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
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                    title: Text(
                      quote.text,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('- ${quote.author}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            quote.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: quote.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              quote.toggleFavorite();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(quote.isFavorite
                                    ? 'Цитата добавлена в избранное'
                                    : 'Цитата удалена из избранного'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeQuote(index);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuoteDetailScreen(quote: quote),
                        ),
                      );
                    },
                  ),

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
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.error, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Text(
                quote.text,
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
