import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';

class ExpandaleButton extends StatefulWidget {
  const ExpandaleButton({super.key, required this.title, required this.items});
  final String title;
  final List<Widget> items;

  @override
  State<ExpandaleButton> createState() => _ExpandaleButtonState();
}

class _ExpandaleButtonState extends State<ExpandaleButton> {
  final ExpandableController _expandableController = ExpandableController();
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: _expandableController,
      child: Column(
        children: [
          Expandable(
            collapsed: ExpandableButton(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: scrSize(context).height * 0.02,
                ),
                child: SpacingRow(
                  spacing: 10,
                  children: [
                    const FractionalTranslation(
                      translation: Offset(0, -0.2),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Text(widget.title, style: textTheme(context).bodyLarge),
                  ],
                ),
              ),
            ),
            expanded: Column(
              children: [
                ExpandableButton(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: scrSize(context).height * 0.02,
                    ),
                    child: SpacingRow(
                      spacing: 10,
                      children: [
                        const FractionalTranslation(
                          translation: Offset(0, 0.2),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        Text(widget.title, style: textTheme(context).bodyLarge),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: scrSize(context).width * 0.05),
                  child: Column(children: widget.items),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
