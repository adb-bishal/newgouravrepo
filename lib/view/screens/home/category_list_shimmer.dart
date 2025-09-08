import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/shimmer_widget/shimmer_widget.dart';

class CategoryListShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const CategoryListShimmer({
    Key? key,
    this.itemCount = 6,
    this.crossAxisCount = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisCount == 2 ? 15 : 10,
          mainAxisSpacing: crossAxisCount == 2 ? 15 : 10,
          childAspectRatio: crossAxisCount == 2 ? 1.1 : 1,
        ),
        itemBuilder: (context, index) {
          return _buildShimmerItem();
        },
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 0.2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(crossAxisCount == 2 ? 12 : 10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(crossAxisCount == 2 ? 12.0 : 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image placeholder
              Expanded(
                flex: crossAxisCount == 2 ? 3 : 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(
                      crossAxisCount == 2 ? 10.0 : 8.0,
                    ),
                  ),
                ),
              ),

              // Spacing
              SizedBox(height: crossAxisCount == 2 ? 12 : 8),

              // Title placeholder
              Expanded(
                flex: crossAxisCount == 2 ? 2 : 1,
                child: Column(
                  children: [
                    Container(
                      height: crossAxisCount == 2 ? 16 : 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    if (crossAxisCount == 2) ...[
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: double.infinity * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension ShimmerEffectExtension on ShimmerEffect {

  // Method for mobile category shimmer
  Widget categoryListShimmerForMobile({int itemCount = 6}) {
    return CategoryListShimmer(
      itemCount: itemCount,
      crossAxisCount: 3,
    );
  }

  // Method for tablet category shimmer
  Widget categoryListShimmerForTab({int itemCount = 6}) {
    return CategoryListShimmer(
      itemCount: itemCount,
      crossAxisCount: 2,
    );
  }

  // Responsive category shimmer
  Widget categoryListShimmerResponsive({int itemCount = 6}) {
    return Builder(
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        int crossAxisCount = screenWidth < 600 ? 3 : 2;

        return CategoryListShimmer(
          itemCount: itemCount,
          crossAxisCount: crossAxisCount,
        );
      },
    );
  }
}
