import 'package:daily_news_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../service_locator.dart';
import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';
import 'local_article_state.dart';

class SaveNotifier extends StateNotifier<SaveArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  SaveNotifier(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
  ) : super(const SaveArticlesLoading()) {
    getAllArticle();
  }

  void saveArticle(ArticleEntity article) async {
    await _saveArticleUseCase(params: article);
    getAllArticle();
  }

  Future<void> getAllArticle() async {
    final articles = await _getSavedArticleUseCase();
    state = SaveArticlesDone(articles);
  }

  Future<void> removeArticle(ArticleEntity article) async {
    await _removeArticleUseCase(params: article);
    getAllArticle();
  }
}

final saveProvider =
    StateNotifierProvider<SaveNotifier, SaveArticlesState>((ref) {
  final get = sl<GetSavedArticleUseCase>();
  final put = sl<SaveArticleUseCase>();
  final del = sl<RemoveArticleUseCase>();
  return SaveNotifier(get, put, del);
});
