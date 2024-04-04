import 'package:flutter/material.dart';

enum DropdownPosition {
  BELOW,
  RIGHT,
}

class OverlayContainer extends StatefulWidget {
  Widget? child;
  OverlayContainerPosition? position;
  bool? show,asWideAsParent;
  Color? materialColor;

  OverlayContainer({
    Key? key,
    @required this.show,
    @required this.child,
    this.asWideAsParent = false,
    this.position = const OverlayContainerPosition(0.0, 0.0),
    this.materialColor = Colors.transparent,
  }) : super(key: key);

  @override
  _OverlayContainerState createState() => _OverlayContainerState();
}

class _OverlayContainerState extends State<OverlayContainer>
    with WidgetsBindingObserver {
  OverlayEntry? _overlayEntry;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    if (widget.show!) {
      _show();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    // We would want to re render the overlay if any metrics
    // ever change.
    if (widget.show!) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We would want to re render the overlay if any of the dependencies
    // ever change.
    if (widget.show!) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void didUpdateWidget(OverlayContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show!) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void dispose() {
    if (widget.show!) {
      _hide();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _show() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 280));
      if (_opened) {
        _overlayEntry!.remove();
      }
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
      _opened = true;
    });
  }

  void _hide() {
    if (_opened) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry!.remove();
        _opened = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in media query such as when a device orientation changes
    // or when the keyboard is toggled.
    MediaQuery.of(context);
    return Container();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox!.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx + widget.position!.left,
          top: offset.dy - widget.position!.bottom,
          width: widget.asWideAsParent! ? size.width : null,
          // child: Material(
          //   child: widget.child,
          //   color: widget.materialColor,
          // ),
          child: widget.child!,
        );
      },
    );
  }
}

class OverlayContainerPosition {
  final double left;
  final double bottom;

  const OverlayContainerPosition(this.left, this.bottom);
}