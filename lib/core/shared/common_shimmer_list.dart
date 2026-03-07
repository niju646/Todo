import 'package:flutter/material.dart';
import 'package:to_do/core/shared/common_shimmer_tile.dart';

Widget commonShimmerList({double height = 60, int itemCount = 10}) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    itemCount: itemCount,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: CommonShimmerTile(height: height),
    ),
  );
}
