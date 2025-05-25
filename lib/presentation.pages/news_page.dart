import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/data.models/newscatergory.dart';
import 'package:hkcoin/presentation.controllers/news_controller.dart';
import 'package:hkcoin/presentation.pages/news_category_detail_page.dart';
import 'package:hkcoin/presentation.pages/news_details_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});
  static String route = "/news";

  @override
  State<NewsPage> createState() => _NewsPageState();
}
class _NewsPageState extends State<NewsPage> {
  final controller = Get.put(NewsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
      id: "news-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(title: "Breadcrumb.NewsItem"),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scrSize(context).width * 0.03,
                      ),
                      child: Column(
                        children: [     
                          if (controller.news.isNotEmpty)                            
                            _FeaturedNewsItem(news: controller.news.first),                          
                          const SizedBox(height: 20),
                          // Danh sách tin thường
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.news.length > 1 
                                ? controller.news.length - 1 
                                : 0,
                            separatorBuilder: (_, __) => const Divider(height: 20),
                            itemBuilder: (context, index) {
                              // Bỏ qua item đầu tiên (đã hiển thị ở featured)
                              final newsItem = controller.news[index + 1];
                              return _RegularNewsItem(news: newsItem);
                            },
                          ),         
                          const SizedBox(height: 30),            
                          Visibility(        
                            visible: controller.categories.isNotEmpty,                                               
                            child: Column(
                                children: [                                 
                                    _buildNewsCategoriesSection(controller.categories),
                                ],
                              )
                          ) ,  
                          const SizedBox(height: 15),                       
                        ],
                      )
                    ),
                  ),
                ),
              ]
            ),
          ),
        );
      }
    );    
  }
  Widget _buildNewsCategoriesSection(List<NewsCategory> categories) {      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,        
        children: [       
          ...categories.map((category) => Container(
             decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withOpacity(0.3),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        style: textTheme(context).titleLarge,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(NewsCategoryDetailPage.route, arguments: category.id);
                      },
                      child: Text(                       
                        tr("Common.Cms.ReadMore"), // Replace with your translation key
                        style: textTheme(context).bodyMedium?.copyWith(
                            //  color: Colors.blue, // Customize the style as needed
                              fontWeight: FontWeight.w400,
                            ),                        
                      ),
                    ),
                  ],
                ),              
                const SizedBox(height: 8),              
                // Danh sách danh mục con (cuộn ngang)
                Visibility(
                  visible:  category.subCategories.isNotEmpty,
                  child: SizedBox(
                    height: 40, // Chiều cao của danh mục con
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: category.subCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final subCategory = category.subCategories[index];
                        return _newsCategoryChip(category: subCategory);
                      },
                    ),
                  ),  
                ),
                
                GetBuilder<NewsController>(
                  id: 'news-list-${category.id}',                
                  builder: (_) {                  
                      return _buildNewsListSection(category.id);                  
                  },
                ),               
                const SizedBox(height: 20),
              ],
            ),
          )),           
        ],
      );
    }
    Widget _newsCategoryChip({required NewsCategory category}) {
      return GestureDetector(
        onTap: () => Get.toNamed(NewsCategoryDetailPage.route, arguments: category.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          // decoration: BoxDecoration(
          //   color: Colors.grey[200],
          //   borderRadius: BorderRadius.circular(20),
          // ),
          child: Text(
            category.name,
            style: textTheme(context).bodyMedium?.copyWith(
              color: Colors.grey
            ),            
          ),
        ),
      );
    }
    Widget _buildNewsListSection(int categoryId) {    
      // Check if data is already loaded to avoid repeated API calls
      if (controller.newsPagination?.news != null &&
          controller.newsPagination!.news!.isNotEmpty &&
          !controller.isInitialLoading.value &&
          !controller.isLoadingMore.value) {
        return _buildNewsList(controller.newsPagination!.news!);
      } 
      WidgetsBinding.instance.addPostFrameCallback((_) {       
        controller.getNewsByCategories(catergoryId: categoryId);        
      });      
      if (controller.newsPagination?.news == null) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (controller.newsPagination?.news == null || controller.newsPagination!.news!.isEmpty) {
        return const Center(child: Text('Common.Empty'));
      }            
      return _buildNewsList(controller.newsPagination!.news!);
    }
    Widget _buildNewsList(List<News> newsList) {
      if (newsList.isEmpty) {
        return const Center(child: Text('Common.Empty'));
      }      
      return Column(
        children: [
          _FeaturedNewsItem(news: controller.news.first),   
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
              return NewsItemWidget(news: newsList[index]);
            },
          ),      
        ],
      );        
    }
  }
  
//}

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
class _RegularNewsItem extends StatelessWidget {
  final News news;
  
  const _RegularNewsItem({required this.news});

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