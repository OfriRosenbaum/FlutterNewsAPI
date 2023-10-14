import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'news_card.dart';

class DetailsPage extends StatelessWidget {
  final NewsCard newsCard;
  const DetailsPage({super.key, required this.newsCard});

  //Since there is always '[+number chars]' at the end of the content, we can replace it with ellipsis
  String getFixedContent() {
    if (newsCard.content != null) {
      String content = newsCard.content!;
      if (content.length < 199) return content;
      return content.substring(0, content.lastIndexOf('['));
      // return newsCard.content!.replaceAll(RegExp(r'\[.*?\]'), '');
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
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: const Text(
          'News App',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                newsCard.title ?? 'No title',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Text(
                newsCard.author ?? 'No author',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              image,
              const SizedBox(height: 16.0),
              Text(newsCard.description ?? '', style: const TextStyle(fontSize: 16.0)),
              const SizedBox(height: 32.0),
              newsCard.url != null
                  ? ElevatedButton(
                      onPressed: () async {
                        Uri url = Uri.parse(newsCard.url!);
                        try {
                          await launchUrl(url);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Could not launch $url'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Text('Read more'),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
