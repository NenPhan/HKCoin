import 'dart:developer';

import 'package:flutter/material.dart';

typedef LoadMoreCallback = Future<void> Function();

class PaginationScrollWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final bool hasMoreData;
  final LoadMoreCallback onLoadMore;
  final Widget? loadingWidget;
  final Widget? noMoreDataWidget;
  final EdgeInsets? padding;
  final double? loadingIndicatorSize;
  final Color? loadingIndicatorColor;

  const PaginationScrollWidget({
    super.key,
    required this.scrollController,
    required this.child,
    required this.hasMoreData,
    required this.onLoadMore,
    this.loadingWidget,
    this.noMoreDataWidget,
    this.padding,
    this.loadingIndicatorSize,
    this.loadingIndicatorColor,
  });

  @override
  State<PaginationScrollWidget> createState() => _PaginationScrollWidgetState();
}

class _PaginationScrollWidgetState extends State<PaginationScrollWidget> {
  bool _isLoadingMore = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final double scrollPosition = widget.scrollController.position.pixels;
    final double maxScrollExtent = widget.scrollController.position.maxScrollExtent;
    final double scrollThreshold = maxScrollExtent * 0.8; // Load more when 80% scrolled

    log('Scroll position: $scrollPosition, maxScrollExtent: $maxScrollExtent, threshold: $scrollThreshold');

    if (scrollPosition >= scrollThreshold && !_isLoadingMore && !_hasError && widget.hasMoreData) {
      log('Triggering load more');
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !widget.hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
      _hasError = false;
    });

    try {
      await widget.onLoadMore();
    } catch (e) {
      log('Error loading more data: $e');
      setState(() {
        _hasError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Widget _buildLoadingWidget() {
    return widget.loadingWidget ??
        Center(
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(16.0),
            child: SizedBox(
              width: widget.loadingIndicatorSize ?? 24,
              height: widget.loadingIndicatorSize ?? 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: widget.loadingIndicatorColor,
              ),
            ),
          ),
        );
  }

  Widget _buildNoMoreDataWidget(BuildContext context) {
    return widget.noMoreDataWidget ??
        Padding(
          padding: widget.padding ?? const EdgeInsets.all(16.0),
          child: Text(
            'No more data available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: [
          widget.child,
          if (_isLoadingMore) _buildLoadingWidget(),
          if (!widget.hasMoreData && !_isLoadingMore) _buildNoMoreDataWidget(context),
          if (_hasError)
            Padding(
              padding: widget.padding ?? const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Failed to load more data',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _loadMoreData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}