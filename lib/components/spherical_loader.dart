import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SphericalLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  SphericalLoader({
    this.size = 40.0,
    this.color = AppColors.ultramarineBlue,
    this.duration = const Duration(seconds: 1),
  });

  @override
  _SphericalLoaderState createState() => _SphericalLoaderState();
}

class _SphericalLoaderState extends State<SphericalLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: widget.size * _animation.value,
                  height: widget.size * _animation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(1.0 - _animation.value),
                  ),
                ),
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
