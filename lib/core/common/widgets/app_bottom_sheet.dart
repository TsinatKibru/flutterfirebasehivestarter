import 'package:flutter/material.dart';

class BottomSheetUtils {
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 400),
    );
  }

  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    double heightFactor = 1,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    Color backgroundColor = Colors.transparent,
    AnimationController? animationController,
    Curve curve = Curves.easeOutCubic,
    double borderRadius = 12.0,
    bool showDragHandle = true, // Added parameter to control visibility
  }) {
    final effectiveController = animationController ??
        createAnimationController(
            context.findAncestorStateOfType<TickerProviderStateMixin>()!);

    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: useSafeArea,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      transitionAnimationController: effectiveController,
      showDragHandle: false, // Disable Flutter's built-in drag handle
      builder: (context) {
        return _AnimatedBottomSheet(
          animationController: effectiveController,
          heightFactor: heightFactor,
          borderRadius: borderRadius,
          showDragHandle: showDragHandle, // Pass to our custom implementation
          child: child,
        );
      },
    );
  }
}

class _AnimatedBottomSheet extends StatelessWidget {
  final Widget child;
  final double heightFactor;
  final double borderRadius;
  final AnimationController animationController;
  final bool showDragHandle;

  const _AnimatedBottomSheet({
    required this.child,
    required this.animationController,
    this.heightFactor = 1,
    this.borderRadius = 12.0,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(
            0,
            (1 - Curves.easeOutCubic.transform(animationController.value)) *
                MediaQuery.of(context).size.height *
                0.1,
          ),
          child: Opacity(
            opacity: animationController.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showDragHandle) _buildDragHandle(),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.fromLTRB(16, 95, 16, 3),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
