import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:flutter/material.dart';

class MyExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? expandedPadding;
  final Color? backgroundColor;
  final Color? expandedBackgroundColor;
  final IconData? expandedIcon;
  final IconData? collapsedIcon;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool initiallyExpanded;
  final bool hasShadow;
  final Duration animationDuration;

  const MyExpansionTile(
      {super.key,
      required this.title,
      this.subtitle,
      required this.children,
      this.titlePadding,
      this.expandedPadding,
      this.backgroundColor = Colors.white,
      this.expandedBackgroundColor,
      this.expandedIcon = Icons.keyboard_arrow_up,
      this.collapsedIcon = Icons.keyboard_arrow_down,
      this.titleStyle,
      this.subtitleStyle,
      this.initiallyExpanded = false,
      this.animationDuration = const Duration(milliseconds: 300),
      this.hasShadow = false});

  @override
  _MyExpansionTileState createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
      color: _isExpanded
          ? widget.expandedBackgroundColor ?? widget.backgroundColor
          : widget.backgroundColor,
      borderRadius: BorderRadius.circular(12),
      padding: EdgeInsets.zero,
      hasShadow: widget.hasShadow,
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleExpansion,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: widget.titleStyle ??
                            Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                        child: widget.title,
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 4),
                        DefaultTextStyle(
                          style: widget.subtitleStyle ??
                              Theme.of(context).textTheme.bodyMedium!,
                          child: widget.subtitle!,
                        ),
                      ]
                    ],
                  ),
                ),
                Icon(
                  _isExpanded ? widget.expandedIcon : widget.collapsedIcon,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: widget.animationDuration,
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
