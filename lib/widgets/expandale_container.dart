import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';

class ExpandaleContainer extends StatefulWidget {
  const ExpandaleContainer({
    super.key,
    required this.titleWidget,
    required this.expandedWidget,
    this.titlePadding,
  });
  final Widget titleWidget;
  final Widget expandedWidget;
  final EdgeInsets? titlePadding;

  @override
  State<ExpandaleContainer> createState() => _ExpandaleContainerState();
}

class _ExpandaleContainerState extends State<ExpandaleContainer> {
  final ExpandableController _expandableController = ExpandableController();
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: _expandableController,
      child: Container(
        padding: EdgeInsets.all(scrSize(context).width * 0.03),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expandable(
              collapsed: ExpandableButton(
                child: Padding(
                  padding:
                      widget.titlePadding ??
                      EdgeInsets.symmetric(
                        vertical: scrSize(context).height * 0.02,
                      ),
                  child: SpacingRow(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FractionalTranslation(
                        translation: Offset(0, -0.2),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      widget.titleWidget,
                    ],
                  ),
                ),
              ),
              expanded: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExpandableButton(
                    child: Padding(
                      padding:
                          widget.titlePadding ??
                          EdgeInsets.symmetric(
                            vertical: scrSize(context).height * 0.02,
                          ),
                      child: SpacingRow(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FractionalTranslation(
                            translation: Offset(0, 0.2),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                          widget.titleWidget,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: scrSize(context).width * 0.05,
                    ),
                    child: widget.expandedWidget,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
