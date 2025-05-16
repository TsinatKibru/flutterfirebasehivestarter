import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerGrid extends StatelessWidget {
  const ProductShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const SizedBox(height: 24),
            _buildSearchAndFilter(),
            const SizedBox(height: 32),
            _buildCategorySection(),
            const SizedBox(height: 32),
            _buildCategorySection(),
            const SizedBox(height: 32),
            _buildCategorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: _roundBox(),
        ),
        const SizedBox(width: 12),
        Container(
          height: 18,
          width: 100,
          decoration: _roundBox(),
        ),
        const Spacer(),
        Container(
          height: 36,
          width: 100,
          decoration: _pillBox(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: _roundBox(radius: 12),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 44,
          width: 44,
          decoration: _roundBox(radius: 12),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        _buildHorizontalProductList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          height: 16,
          width: 120,
          decoration: _roundBox(),
        ),
        const Spacer(),
        Container(
          height: 14,
          width: 50,
          decoration: _roundBox(),
        ),
      ],
    );
  }

  Widget _buildHorizontalProductList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        padding: const EdgeInsets.only(right: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 16),
            child: Container(
              width: 160,
              decoration: _roundBox(radius: 16),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: _roundBox(radius: 12),
                  ),
                  const Spacer(),
                  Container(
                    height: 10,
                    width: 100,
                    decoration: _roundBox(),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 60,
                    decoration: _roundBox(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _roundBox({double radius = 8}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  BoxDecoration _pillBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    );
  }
}
