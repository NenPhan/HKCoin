import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        return SpacingColumn(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tin tức", style: textTheme(context).titleSmall),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(10, (index) {
                return SizedBox(
                  width: (cons.maxWidth - 10) / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey[900],
                      child: SpacingColumn(
                        children: [
                          Image.network(
                            "https://hakacoin.net/media/1786/file/news/HKCNews-Breaking-5.webp",
                            fit: BoxFit.fitWidth,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              scrSize(context).width * 0.03,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Monad Seeks \$200 Million Funding from Paradigm",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: textTheme(context).bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "The layer-1 blockchain project Monad is in discussions with several investment funds, including Paradigm, regarding conducting a fundraising round with a value of up to \$200 million.",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: textTheme(context).bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
