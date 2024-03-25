import 'package:equatable/equatable.dart';

import '../../../../domain/entities/article.dart';

abstract class SaveArticlesState extends Equatable {
  final List<ArticleEntity>? articles;

  const SaveArticlesState({this.articles});

  @override
  List<Object> get props => [articles!];
}

class SaveArticlesLoading extends SaveArticlesState {
  const SaveArticlesLoading();
}

class SaveArticlesDone extends SaveArticlesState {
  const SaveArticlesDone(List<ArticleEntity> articles)
      : super(articles: articles);
}
