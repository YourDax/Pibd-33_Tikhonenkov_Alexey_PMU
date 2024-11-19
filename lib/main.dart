// ignore_for_file: unnecessary_string_escapes

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

// Модель цитаты
class Quote {
  final String text;
  final String author;
  final String imagePath;

  Quote(this.text, this.author, this.imagePath);
}

// Главный экран
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

    // Тестовые цитаты
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
        defaultImagePath, // Устанавливаем дефолтное изображение
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
      body: Stack(
        children: [
          Column(
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeQuote(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: QuoteCounter(count: _quotes.length),
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

// Виджет счетчика цитат
class QuoteCounter extends StatelessWidget {
  final int count;
  const QuoteCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          'Количество цитат: $count',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }
}

// Расширение для форматирования текста
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
