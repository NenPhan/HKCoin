import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/data.models/newscatergory.dart';
import 'package:hkcoin/presentation.controllers/news_category_detail_controller.dart';
import 'package:hkcoin/presentation.controllers/news_controller.dart';
import 'package:hkcoin/presentation.pages/news_details_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/nodatawidget_refresh_scroll.dart';
import 'package:hkcoin/widgets/pagination_scroll_widget.dart';

class NewsCategoryDetailPage extends StatefulWidget {
  const NewsCategoryDetailPage({super.key});
  static String route = "/newscategories-detail";

  @override
  State<NewsCategoryDetailPage> createState() => _NewsCategoryDetailPageState();
}
class _NewsCategoryDetailPageState extends State<NewsCategoryDetailPage> {
  final controller = Get.put(NewsCategoryDetailController());
  final newsController = Get.put(NewsController());
  final ScrollController _verticalScrollController = ScrollController();
  Future<void> _loadMoreData(int categoryId) async {
    if (!newsController.isLoadingMore.value &&
        (newsController.newsPagination?.hasNextPage ?? false)) {      
      await newsController.getNewsByCategories(
        catergoryId: categoryId,
        page: (newsController.newsPagination?.pageNumber ?? 0) + 1,
        isLoadMore: true,
      );
    }
  }
  // Hàm xử lý kéo xuống làm mới
  Future<void> _refreshData(int categoryId) async {    
    await newsController.getNewsByCategories(
      catergoryId: categoryId,
      page: 1,
      isLoadMore: false,
    );
  }
  @override
  void dispose() {    
    _verticalScrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
           if (controller.isLoading.value) {
            return const Center(child: LoadingWidget());
          }
          if (controller.data == null) {
            return Center(
              child: Text(
                'No news details available',
                style: textTheme(context).bodyMedium,
              ),
            );
          }
           final newsDetail = controller.data!;
           return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseAppBar(title: newsDetail.name),
                  Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(scrSize(context).width * 0.03),
                  margin: EdgeInsets.all(scrSize(context).width * 0.03),                
                  child: SpacingColumn(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       SizedBox(
                        height: 40, // Chiều cao của danh mục con
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: newsDetail.subCategories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final subCategory = newsDetail.subCategories[index];
                            return _newsCategoryChip(category: subCategory);
                          },
                        ),
                      ),                       
                      GetBuilder<NewsController>(
                        id: 'news-list-${newsDetail.id}',                
                        builder: (newsControllers) {                                  
                          if (newsController.isInitialLoading.value) {     
                            return const Center(
                              child: LoadingWidget(),
                            );                            
                          }  
                          if (newsController.newsPagination == null || 
                            newsController.newsPagination!.news == null ||
                            newsController.newsPagination!.news!.isEmpty) {
                              return NoDataWidget(
                                message: 'No data to display',
                                icon: Icons.error_outline,
                                onRefresh: () => _refreshData(newsDetail.id),
                              );
                          }   
                          return RefreshIndicator(
                            onRefresh: () => _refreshData(newsDetail.id),
                            child: PaginationScrollWidget(
                              scrollController: _verticalScrollController,
                              hasMoreData: newsController.newsPagination?.hasNextPage ?? false,
                               onLoadMore: () => _loadMoreData(newsDetail.id),
                              child: _buildNewsList(newsController.newsPagination!.news!),
                            )
                          );                                      
                        },
                      ),                                               
                    ],
                  ),
                ),
                ]
              )
           );
        }),
      ),
    );
  }
  Widget _newsCategoryChip({required NewsCategory category}) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque, 
        onTap: () {          
          Navigator.of(context).pushNamed(
            NewsCategoryDetailPage.route,
            arguments: category.id,
          );         
        },       
        child: Container(     
          alignment: Alignment.center,     
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
           decoration: BoxDecoration(
             color: Colors.grey.withOpacity(.5),
             borderRadius: BorderRadius.circular(10),
           ),
           constraints: const BoxConstraints(
              minWidth: 0, // Cho phép thu nhỏ chiều rộng tối thiểu
            ),
          child: Text(
            category.name,
            style: textTheme(context).bodyMedium?.copyWith(
              color: Colors.grey
            ),            
          ),
        ),
      );
    }  
    Widget _buildNewsList(List<News> newsList) {
      if (newsList.isEmpty) {
        return const Center(child: Text('Common.Empty'));
      }      
      return Column(
        children: [
          _FeaturedNewsItem(news: newsController.news.first),   
          const SizedBox(height: 20),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newsList.length > 1 
                ? newsList.length - 1 
                : 0,
            separatorBuilder: (_, __) => const Divider(height: 10),
            itemBuilder: (context, index) {
              // Bỏ qua item đầu tiên (đã hiển thị ở featured)              
              return _regularNewsItem(news: newsList[index]);
            },
          ),      
        ],
      );        
    }
}

class _FeaturedNewsItem extends StatelessWidget {
    final News news;
    const _FeaturedNewsItem({required this.news});
    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () => Get.toNamed(NewsDetailPage.route, arguments: news.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                news.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  height: 200,
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news.name,
              style: textTheme(context).titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              news.shortDescription,
              style: textTheme(context).bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
  }
  // Widget tin thường (ảnh trái + tiêu đề phải)
class _regularNewsItem extends StatelessWidget {
  final News news;
  
  const _regularNewsItem({required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(NewsDetailPage.route, arguments: news.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bên trái
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              news.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[300],
                width: 80,
                height: 80,
                child: const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Tiêu đề + mô tả ngắn
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.name,
                  style: textTheme(context).titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  news.shortDescription,
                  style: textTheme(context).bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class NewsItemWidget extends StatelessWidget {
  final News news;
  
  const NewsItemWidget({required this.news, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),          
        ],
      ),
    );
  }
}