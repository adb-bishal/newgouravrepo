import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MentorShimmer {
  // Default shimmer colors
  static const Color _baseColor = Color(0xFFE0E0E0);
  static const Color _highlightColor = Color(0xFFF5F5F5);
  static const Duration _animationDuration = Duration(milliseconds: 1500);

  /// Creates a shimmer effect for the entire mentor list
  /// [itemCount] - Number of shimmer cards to display
  /// [baseColor] - Base color for shimmer animation
  /// [highlightColor] - Highlight color for shimmer animation
  static Widget mentorList({
    int itemCount = 5,
    Color baseColor = _baseColor,
    Color highlightColor = _highlightColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: itemCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildMentorCard(
                baseColor: baseColor,
                highlightColor: highlightColor,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Creates a shimmer effect for individual mentor card
  static Widget mentorCard({
    Color baseColor = _baseColor,
    Color highlightColor = _highlightColor,
  }) {
    return _buildMentorCard(
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  /// Internal method to build individual mentor card shimmer
  static Widget _buildMentorCard({
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImageShimmer(baseColor, highlightColor),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildContentShimmer(baseColor, highlightColor),
                ),
              ],
            ),
          ),
          _buildButtonShimmer(baseColor, highlightColor),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Creates shimmer for profile image
  static Widget _buildProfileImageShimmer(
      Color baseColor, Color highlightColor) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: _animationDuration,
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Creates shimmer for content area
  static Widget _buildContentShimmer(Color baseColor, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name shimmer
        _buildTextShimmer(
          width: 150,
          height: 16,
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
        const SizedBox(height: 8),

        // Rating shimmer
        _buildRatingShimmer(baseColor, highlightColor),
        const SizedBox(height: 8),

        // Info rows shimmer
        ..._buildInfoRowsShimmer(baseColor, highlightColor),

        const SizedBox(height: 8),

        // Availability shimmer
        _buildTextShimmer(
          width: 90,
          height: 12,
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
      ],
    );
  }

  /// Creates shimmer for rating stars
  static Widget _buildRatingShimmer(Color baseColor, Color highlightColor) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: _animationDuration,
      child: Row(
        children: List.generate(
          5,
          (index) => Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates shimmer for info rows
  static List<Widget> _buildInfoRowsShimmer(
      Color baseColor, Color highlightColor) {
    final List<double> widths = [120, 80, 140, 100];

    return widths
        .map(
          (width) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              period: _animationDuration,
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: width,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  /// Creates shimmer for button
  static Widget _buildButtonShimmer(Color baseColor, Color highlightColor) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: _animationDuration,
      child: Container(
        width: 200,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }

  /// Creates shimmer for text elements
  static Widget _buildTextShimmer({
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: _animationDuration,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }

  /// Alternative shimmer style with single animation wrapper
  static Widget mentorListAlternative({
    int itemCount = 5,
    Color baseColor = _baseColor,
    Color highlightColor = _highlightColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: itemCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildAlternativeMentorCard(baseColor, highlightColor);
            },
          ),
        ],
      ),
    );
  }

  /// Alternative mentor card with single shimmer wrapper
  static Widget _buildAlternativeMentorCard(
      Color baseColor, Color highlightColor) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: Duration(milliseconds: 1200),
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 150, height: 16, color: Colors.white),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(right: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(width: 120, height: 12, color: Colors.white),
                        const SizedBox(height: 4),
                        Container(width: 80, height: 12, color: Colors.white),
                        const SizedBox(height: 4),
                        Container(width: 140, height: 12, color: Colors.white),
                        const SizedBox(height: 4),
                        Container(width: 100, height: 12, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(width: 90, height: 12, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// Custom shimmer implementation without external dependencies
class CustomMentorShimmer {
  static Widget mentorList({
    int itemCount = 5,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
    Duration period = const Duration(milliseconds: 1500),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: itemCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _CustomShimmerEffect(
                baseColor: baseColor,
                highlightColor: highlightColor,
                period: period,
                child: _buildMentorCardSkeleton(),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildMentorCardSkeleton() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150, height: 16, color: Colors.white),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 2),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(width: 120, height: 12, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 80, height: 12, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 140, height: 12, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 100, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 90, height: 12, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// Custom shimmer effect widget
class _CustomShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  const _CustomShimmerEffect({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    required this.period,
  });

  @override
  _CustomShimmerEffectState createState() => _CustomShimmerEffectState();
}

class _CustomShimmerEffectState extends State<_CustomShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.period,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value * 3.14159),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
