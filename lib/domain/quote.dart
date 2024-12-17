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
