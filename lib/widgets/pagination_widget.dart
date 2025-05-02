import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';

class PaginationWidget extends StatefulWidget {
  const PaginationWidget({
    super.key,
    required this.totalPage,
    this.initPage = 1,
    required this.onPageChange,
  });
  final int totalPage;
  final int initPage;
  final Function(int) onPageChange;

  @override
  State<PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  int currentPage = 1;
  int visiblePages = 3;
  List<int> listButtons = [];
  @override
  void initState() {
    currentPage = widget.initPage;
    updateVisibleButtons();
    super.initState();
  }

  updateVisibleButtons() {
    listButtons.clear();
    if (widget.totalPage < visiblePages) {
      listButtons.addAll(generateListButton(1, widget.totalPage));
    } else {
      if (currentPage == 1) {
        listButtons.addAll(generateListButton(currentPage, visiblePages));
      } else if (currentPage == widget.totalPage) {
        listButtons.addAll(
          generateListButton(
            widget.totalPage - visiblePages + 1,
            widget.totalPage,
          ),
        );
      } else {
        listButtons.addAll(
          generateListButton(
            (currentPage - 1).toInt(),
            (currentPage + 1).toInt(),
          ),
        );
      }
    }
  }

  List<int> generateListButton(int n1, int n2) {
    int begin, end;
    if (n1 == n2) {
      return [];
    } else if (n1 > n2) {
      begin = n2;
      end = n1;
    } else {
      begin = n1;
      end = n2;
    }
    List<int> list = [];
    for (var i = begin; i <= end; i++) {
      list.add(i);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SpacingRow(
      spacing: scrSize(context).width * 0.02,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(listButtons.length, (index) {
        int button = listButtons[index];
        return GestureDetector(
          onTap: () {
            currentPage = button;
            updateVisibleButtons();
            setState(() {});
            widget.onPageChange(button);
          },
          child: Container(
            width: scrSize(context).width * 0.12,
            height: scrSize(context).width * 0.12,
            padding: EdgeInsets.all(scrSize(context).width * 0.03),
            decoration: BoxDecoration(
              color:
                  button == currentPage ? Colors.deepOrange : Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                button.toString(),
                style: textTheme(context).bodyLarge,
              ),
            ),
          ),
        );
      }),
    );
  }
}
