// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsCard _$NewsCardFromJson(Map<String, dynamic> json) => NewsCard(
      title: json['title'] as String?,
      author: json['author'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      urlToImage: json['urlToImage'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$NewsCardToJson(NewsCard instance) => <String, dynamic>{
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
      'content': instance.content,
      'urlToImage': instance.urlToImage,
      'url': instance.url,
    };
