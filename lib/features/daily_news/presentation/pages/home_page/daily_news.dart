
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/article.dart';
import '../../riverpod/article/remote/article_provider.dart';
import '../../riverpod/article/remote/article_state.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        'DailyNews',
      ),
      actions: [
        GestureDetector(
          onTap: () => _onShowSavedArticlesViewTapped(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              Icons.bookmark,
            ),
          ),
        ),
      ],
    );
  }

//Riverpod state management
  _buildBody() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(articleProvider);
        //Refreshing function
        Future<void> refresh() async =>
            ref.read(articleProvider.notifier).fetchArticles();
        if (state is RemoteArticlesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is RemoteArticlesDone) {
          return ListView.builder(
            itemCount: state.articles!.length,
            itemBuilder: (context, index) {
              final article = state.articles![index];
              return ArticleWidget(
                article: article,
                onArticlePressed: (article) =>
                    _onArticlePressed(context, article),
              );
            },
          );
        } else {
          return Center(
            child: Column(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.refresh_sharp)),
                const SizedBox(height: 10.0),
                Text('Error: ${state.error!.message}'),
              ],
            ),
          );
        }
      },
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }
}
