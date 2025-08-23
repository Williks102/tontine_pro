import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class GiftPackageCarouselWidget extends StatefulWidget {
  final List<Map<String, dynamic>> giftPackages;
  final Function(Map<String, dynamic>) onPackageSelect;

  const GiftPackageCarouselWidget({
    Key? key,
    required this.giftPackages,
    required this.onPackageSelect,
  }) : super(key: key);

  @override
  State<GiftPackageCarouselWidget> createState() =>
      _GiftPackageCarouselWidgetState();
}

class _GiftPackageCarouselWidgetState extends State<GiftPackageCarouselWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'redeem',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Packages Cadeaux Disponibles',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 35.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.giftPackages.length,
            itemBuilder: (context, index) {
              final package = widget.giftPackages[index];
              final isActive = index == _currentIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                child: Card(
                  elevation: isActive ? 8 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3.w),
                            child: CustomImageWidget(
                              imageUrl: package["image"] as String,
                              width: double.infinity,
                              height: 15.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            package["name"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            package["description"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(1.w),
                                ),
                                child: Text(
                                  'Valeur: ${package["estimatedValue"]}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => widget.onPackageSelect(package),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'arrow_forward',
                                    color: Colors.white,
                                    size: 4.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.giftPackages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: index == _currentIndex ? 6.w : 2.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: index == _currentIndex
                    ? AppTheme.lightTheme.colorScheme.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
