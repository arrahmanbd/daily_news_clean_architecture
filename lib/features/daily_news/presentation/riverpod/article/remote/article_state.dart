
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../../../domain/entities/article.dart';

abstract class ArticleState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioError? error;

  const ArticleState({this.articles, this.error});

  @override
  List<Object> get props => [articles!, error!];
}

class RemoteArticlesLoading extends ArticleState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends ArticleState {
  const RemoteArticlesDone(List<ArticleEntity> article)
      : super(articles: article);
}

class RemoteArticlesError extends ArticleState {
  const RemoteArticlesError(DioError error) : super(error: error);
}

