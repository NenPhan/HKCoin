import 'package:flutter/material.dart';
import 'package:hkcoin/data.models/slide.dart';

class HomeSlideWidget extends StatefulWidget {
  const HomeSlideWidget({
    super.key,
    this.isLoading = false,
    required this.slides,
  });
  final bool isLoading;
  final List<Slide> slides;

  @override
  State<HomeSlideWidget> createState() => _HomeSlideWidgetState();
}

class _HomeSlideWidgetState extends State<HomeSlideWidget> {
  PageController controller = PageController(viewportFraction: 1);

  @override
  void initState() {
    if (widget.slides.length > 1) {
      controller = PageController(viewportFraction: 0.9);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView(
        controller: controller,
        allowImplicitScrolling: true,
        padEnds: false,

        children: List.generate(widget.slides.length, (index) {
          String url = widget.slides[index].image?.thumbUrl ?? "";
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                // width: 150,
                // height: 150,
                child: Image.network(
                  url.contains("http") ? url : "https:$url",
                  fit: BoxFit.cover,
                  // errorBuilder:
                  //     (context, error, stackTrace) => Container(
                  //       color: Colors.grey[900],
                  //       child: Center(
                  //         child: Text(
                  //           "Banner",
                  //           style: textTheme(context).bodyLarge,
                  //         ),
                  //       ),
                  //     ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
