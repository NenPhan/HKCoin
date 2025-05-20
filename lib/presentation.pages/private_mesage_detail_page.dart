import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/private_message_controller.dart';
import 'package:hkcoin/presentation.controllers/private_message_detail_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class PrivateMesageDetailPage extends StatefulWidget {
  const PrivateMesageDetailPage({super.key});
  static String route = "/message";

  @override
  State<PrivateMesageDetailPage> createState() => _PrivateMesageDetailPageState();
}
class _PrivateMesageDetailPageState extends State<PrivateMesageDetailPage> {
  final controller = Get.put(PrivateMessageDetailController());
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
          // Gọi mark as read khi trang chi tiết được load
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (!newsDetail.isRead!) {
          //     controller.markAsReadAndRefresh(newsDetail.id!);
          //   }
          // });
          return WillPopScope(
            onWillPop: () async {
              // Trả về true nếu tin nhắn đã được đánh dấu đọc
              Navigator.of(context).pop(newsDetail.isRead == true);
            return false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BaseAppBar(title: "Account.PrivateMessage.Detail.Title"),              
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(scrSize(context).width * 0.02),
                    margin: EdgeInsets.all(scrSize(context).width * 0.01),                 
                    child: SpacingColumn(
                      spacing: 0,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          newsDetail.subject??"",
                          style: textTheme(context).titleLarge?.copyWith(
                            fontSize: scrSize(context).width * 0.05,
                          ),
                        ),                      
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(scrSize(context).width * 0.01),
                    margin: EdgeInsets.all(scrSize(context).width * 0.01),
                    child: SpacingColumn(
                      spacing: 0,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (newsDetail.body!.isNotEmpty)
                          Html(
                            data: newsDetail.body,
                            style: {
                              '*': Style(
                                fontSize: FontSize(
                                  textTheme(context).bodyMedium!.fontSize!,
                                ),
                                color: textTheme(context).bodyMedium!.color,
                              ),
                              'img': Style(
                                margin: Margins.symmetric(vertical: 0),
                              ),
                            },
                            extensions: [
                              TagExtension(
                                tagsToExtend: {"img"},
                                builder: (context) {
                                  final src = context.attributes['src'];
                                  if (src == null || src.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 0,
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: constraints.maxWidth,
                                          ),
                                          child: Image.network(
                                            src,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Text(
                                                      'Cant not loading image!',
                                                    ),
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );         
        }),
      ),
    );
  }
}