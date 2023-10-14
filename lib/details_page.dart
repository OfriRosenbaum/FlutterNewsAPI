import 'package:flutter/material.dart';

import 'news_card.dart';

class DetailsPage extends StatelessWidget {
  final NewsCard newsCard;
  const DetailsPage({super.key, required this.newsCard});

  //Since there is always '[+number chars]' at the end of the content, we can replace it with ellipsis
  String getFixedContent() {
    if (newsCard.content != null) {
      return newsCard.content!.replaceAll(RegExp(r'\[.*?\]'), '...');
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    Widget image;
    if (newsCard.urlToImage != null) {
      try {
        image = Image.network(
          newsCard.urlToImage!,
          width: screenWidth * 0.5,
          height: screenHeight * 0.5,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: screenWidth * 0.5),
        );
      } catch (e) {
        image = Icon(Icons.image_not_supported, size: screenWidth * 0.5);
      }
    } else {
      image = Icon(Icons.image_not_supported, size: screenWidth * 0.5);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: Text(newsCard.title ?? 'No title'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            image,
            Text(newsCard.description ?? ''),
          ],
        ),
      ),
    );
  }
}
