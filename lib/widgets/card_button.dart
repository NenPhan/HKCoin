import 'package:flutter/material.dart';

class _buildAssetItem extends StatefulWidget {
  final String title;
  final String amount;
  final IconData icon;
  
  const _buildAssetItem({
    required this.title,
    required this.amount,
    required this.icon,
  });

  @override
  State<_buildAssetItem> createState() => _buildAssetItemState();
}

class _buildAssetItemState extends State<_buildAssetItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
            _isExpanded ? _controller.forward() : _controller.reverse();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar with gradient
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.blue.shade300, Colors.blue.shade700],
                      ),
                    ),
                    child: Icon(widget.icon, size: 22, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, 
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.amount, 
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  // Animated arrow
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
              // Additional content when expanded
              if (_isExpanded)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text("Additional details appear here"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}