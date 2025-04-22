import 'package:flutter/material.dart';

class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({super.key});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  PageController controller = PageController(viewportFraction: 0.8);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView(
        controller: controller,
        allowImplicitScrolling: true,
        padEnds: false,

        children: List.generate(5, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  "https://sandbox.hakacoin.net/media/1251/catalog/Kem%20xoa%20b%C3%B3p%20to%C3%A0n%20th%C3%A2n-01.png?size=550",
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
