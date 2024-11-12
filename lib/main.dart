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

// Enum
enum MessageType { noQuotes, newQuoteAdded }

// Модель цитаты
class Quote {
  final String text;
  final String author;

  Quote(this.text, this.author);
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Quote> _quotes = []; // Generics List<>
  MessageType _messageType = MessageType.noQuotes; // Enum для состояния

  // Добавление новой цитаты
  Future<void> _addQuote() async {
    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController quoteController = TextEditingController();
        final TextEditingController authorController = TextEditingController();

        return AlertDialog(
          title: const Text('Добавить цитату'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quoteController,
                decoration: const InputDecoration(labelText: 'Цитата'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Автор'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop({
                'quote': quoteController.text,
                'author': authorController.text,
              }), // Анонимная функция
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );

    if (result != null && result['quote'] != '' && result['author'] != '') {
      setState(() {
        _quotes.add(
          Quote(result['quote']!.addQuotesIfMissing(), result['author']!.capitalize()), // Применение расширения
        );
        _messageType = MessageType.newQuoteAdded; // Изменение состояния на "новая цитата добавлена"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: _messageType == MessageType.noQuotes
                ? const Text(
              'Нет добавленных цитат. Добавь первую!.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            )
                : ListView.builder(
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _quotes[index].text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text('- ${_quotes[index].author}'),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Отступы внутри контейнера
                decoration: BoxDecoration(
                  color: Colors.grey, // Полупрозрачный чёрный фон
                  borderRadius: BorderRadius.circular(15), // Закругленные углы
                  border: Border.all(//Граница
                    color: Colors.black.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Количество цитат: ${_quotes.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuote,
        tooltip: 'Добавить цитату',
        child: const Icon(Icons.format_quote),
      ),
    );
  }
}

// Расширение для форматирования текста
extension StringExtension on String {
  // Метод для заглавной буквы у каждого слова
  String capitalize() {
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
      return word;
    }).join(' ');
  }
  // Метод для добавления кавычек, если их нет или они размещены некорректно
  String addQuotesIfMissing() {
    if (startsWith('\"') && endsWith('\"')) {
      return this;
    }
    // Если начинается с кавычки, но не заканчивается на неё
    if (startsWith('\"') && !endsWith('\"')) {
      return '$this\"';
    }
    // Если заканчивается на кавычку, но не начинается с неё
    if (endsWith('\"') && !startsWith('\"')) {
      return '\"$this';
    }
    return '\"$this\"';
  }
}
