import 'package:daily_news_clean_architecture/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news_clean_architecture/features/daily_news/domain/usecases/get_article.dart';

import '../../../../../../core/resources/data_state.dart';
import 'article_state.dart';

class ArticleNotifier extends StateNotifier<ArticleState> {
  final GetArticleUseCase _getArticleUseCase;
  ArticleNotifier(this._getArticleUseCase)
      : super(const RemoteArticlesLoading()) {
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final dataState = await _getArticleUseCase();
      if (dataState is DataSuccess &&
          dataState.data!.isNotEmpty &&
          dataState.data != null) {
        state = RemoteArticlesDone(dataState.data!);
      }
    } catch (error) {
      state = RemoteArticlesError(error as DioError);
    }
  }
}

final articleProvider =
    StateNotifierProvider<ArticleNotifier, ArticleState>((ref) {
  final getArticleUseCase = sl<GetArticleUseCase>();
  return ArticleNotifier(getArticleUseCase);
});
