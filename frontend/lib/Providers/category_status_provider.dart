import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Widgets/custom_category_button.dart';
import 'package:frontend/Widgets/custom_status_button.dart';

final categorySelectionProvider = StateProvider<String>((ref) {
  return 'all';
});
final statusSelectionProvider = StateProvider<String>((ref) {
  return 'all';
});

class StatusList extends ConsumerWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(statusSelectionProvider);
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: Colors.grey.withAlpha(50),
      ),
      child: Row(
        children: [
          CustomStatusButton(title: 'All', isSelected: status == 'all'),
          5.horizontalSpace,
          CustomStatusButton(title: 'Active', isSelected: status == 'active'),
          5.horizontalSpace,
          CustomStatusButton(
            title: 'Completed',
            isSelected: status == 'completed',
          ),
        ],
      ),
    );
  }
}

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(categorySelectionProvider);
    return SizedBox(
      height: 50.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CustomCategoryButton(
            title: 'All',
            icon: Icons.list,
            isSelected: selectedCategory == 'all',
          ),
          10.horizontalSpace,
          CustomCategoryButton(
            title: 'Work',
            icon: Icons.work_outline,
            isSelected: selectedCategory == 'work',
          ),
          10.horizontalSpace,
          CustomCategoryButton(
            title: 'Shopping',
            icon: Icons.shopping_bag_outlined,
            isSelected: selectedCategory == 'shopping',
          ),
          10.horizontalSpace,
          CustomCategoryButton(
            title: 'Health',
            icon: Icons.health_and_safety_outlined,
            isSelected: selectedCategory == 'health',
          ),
          10.horizontalSpace,
          CustomCategoryButton(
            title: 'Personal',
            icon: Icons.person_outline,
            isSelected: selectedCategory == 'personal',
          ),
        ],
      ),
    );
  }
}
