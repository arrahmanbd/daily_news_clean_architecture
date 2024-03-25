import 'package:daily_news_clean_architecture/features/daily_news/presentation/riverpod/article/local/local_article_provider.dart';
import 'package:daily_news_clean_architecture/features/daily_news/presentation/riverpod/article/local/local_article_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class SavedArticles extends HookWidget {
  const SavedArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, child) => Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(ref),
          )),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonTapped(context),
          child: const Icon(Ionicons.chevron_back, color: Colors.black),
        ),
      ),
      title:
          const Text('Saved Articles', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildBody(WidgetRef ref) {
    final state = ref.watch(saveProvider);
    if (state is SaveArticlesLoading) {
      return const Center(child: CupertinoActivityIndicator());
    } else if (state is SaveArticlesDone) {
      return _buildArticlesList(state.articles!,ref);
    }
    return const Center(child: const Text('Something Went Wrong !'));
  }

  Widget _buildArticlesList(List<ArticleEntity> articles,WidgetRef ref) {
    if (articles.isEmpty) {
      return const Center(
          child: Text(
        'NO SAVED ARTICLES',
        style: TextStyle(color: Colors.black),
      ));
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleWidget(
          article: articles[index],
          isRemovable: true,
          onRemove: (article) => _onRemoveArticle(ref, article),
          onArticlePressed: (article) => _onArticlePressed(context, article),
        );
      },
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onRemoveArticle(WidgetRef ref, ArticleEntity article) {
    ref.read(saveProvider.notifier).removeArticle(article);
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
