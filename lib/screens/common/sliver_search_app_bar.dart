import 'package:com_barge_idigital/screens/common/background_wave.dart';
import 'package:com_barge_idigital/screens/common/search_bar.dart';
import 'package:flutter/material.dart';

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  final String title;
  const SliverSearchAppBar(this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var adjustedShrinkOffset =
        shrinkOffset > minExtent ? minExtent : shrinkOffset;
    double offset = (minExtent - adjustedShrinkOffset) * 0.5;
    double topPadding = MediaQuery.of(context).padding.top + 16;

    return Stack(
      children: [
        const BackgroundWave(
          height: 280,
        ),
        Positioned(
          top: topPadding + offset,
          child: CSearchBar(
            title: this.title,
          ),
          left: 24,
          right: 16,
        )
      ],
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}
