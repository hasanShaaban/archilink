import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/presentation/views/widgets/store_filter_chip.dart';
import 'package:flutter/material.dart';

class StoreSearchAppBar extends StatefulWidget {
  const StoreSearchAppBar({
    super.key,
    this.onSearchChanged,
    this.onFilterChanged,
    this.selectedCategories = const [],
    this.onCategoryRemoved,
    this.onCategoryOptionTap,
  });

  final ValueChanged<String>? onSearchChanged;
  final void Function({
    String? category,
    List<ProductCategoryEntity>? categories,
    String? status,
    String? minPrice,
    String? maxPrice,
  })? onFilterChanged;
  final List<ProductCategoryEntity> selectedCategories;
  final ValueChanged<ProductCategoryEntity>? onCategoryRemoved;
  final VoidCallback? onCategoryOptionTap;

  @override
  State<StoreSearchAppBar> createState() => _StoreSearchAppBarState();
}

class _StoreSearchAppBarState extends State<StoreSearchAppBar> {
  late final TextEditingController _searchController;
  bool _isFiltersOpen = false;

  String? _selectedStatus;
  String? _selectedMinPrice;
  String? _selectedMaxPrice;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _notifyFiltersChanged() {
    widget.onFilterChanged?.call(
      categories: widget.selectedCategories,
      status: _selectedStatus,
      minPrice: _selectedMinPrice,
      maxPrice: _selectedMaxPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColorsFromTheme.primaryColor(context);

    final searchBgColor = isDark
        ? const Color(0xFF242527)
        : const Color(0xFFE8E8E8);

    final String categoryLabel;
    if (widget.selectedCategories.isEmpty) {
      categoryLabel = 'Category';
    } else if (widget.selectedCategories.length == 1) {
      categoryLabel = widget.selectedCategories.first.name;
    } else {
      categoryLabel = 'Categories (${widget.selectedCategories.length})';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Search input pill + circular filter button
        Row(
          children: [
            // Search Input Pill
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: searchBgColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {});
                    widget.onSearchChanged?.call(val);
                  },
                  style: AppTextStyle.interRegular14.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for Product',
                    hintStyle: AppTextStyle.interRegular14.copyWith(
                      color: AppColorsFromTheme.grayForText(context),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                              widget.onSearchChanged?.call('');
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: AppColorsFromTheme.grayForText(context),
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Circular Filter Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isFiltersOpen = !_isFiltersOpen;
                  });
                },
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF242527) : Colors.white,
                    border: Border.all(
                      color: _isFiltersOpen
                          ? primaryColor
                          : AppColorsFromTheme.borderColor(context).withValues(
                              alpha: isDark ? 0.4 : 0.7,
                            ),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: _isFiltersOpen
                        ? primaryColor
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Expandable Filter Options Row
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  // Filter Toggle Box (Teal border with sliders icon)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isFiltersOpen = !_isFiltersOpen;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryColor,
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Category Filter Chip (opens CategorySearchBottomSheet)
                  StoreFilterChip(
                    label: categoryLabel,
                    icon: Icons.keyboard_arrow_down_rounded,
                    isHighlighted: widget.selectedCategories.isNotEmpty,
                    onTap: widget.onCategoryOptionTap,
                  ),

                  const SizedBox(width: 8),

                  // Status Filter Chip (highlighted border matching mockup)
                  StoreFilterChip(
                    label: 'Status',
                    icon: Icons.keyboard_arrow_down_rounded,
                    isHighlighted: true,
                    options: const [
                      'Available',
                      'Coming Soon',
                      'Out of Stock',
                    ],
                    selectedValue: _selectedStatus,
                    onSelected: (val) {
                      setState(() {
                        _selectedStatus = val;
                      });
                      _notifyFiltersChanged();
                    },
                  ),

                  const SizedBox(width: 8),

                  // Min Price Filter Chip (south-west diagonal arrow)
                  StoreFilterChip(
                    label: 'Min Price',
                    icon: Icons.south_west_rounded,
                    options: const [
                      '10',
                      '50',
                      '100',
                    ],
                    selectedValue: _selectedMinPrice,
                    onSelected: (val) {
                      setState(() {
                        _selectedMinPrice = _selectedMinPrice == val ? null : val;
                      });
                      _notifyFiltersChanged();
                    },
                  ),

                  const SizedBox(width: 8),

                  // Max Price Filter Chip (north-east diagonal arrow)
                  StoreFilterChip(
                    label: 'Max Price',
                    icon: Icons.north_east_rounded,
                    options: const [
                      '200',
                      '500',
                      '1000',
                    ],
                    selectedValue: _selectedMaxPrice,
                    onSelected: (val) {
                      setState(() {
                        _selectedMaxPrice = _selectedMaxPrice == val ? null : val;
                      });
                      _notifyFiltersChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
          crossFadeState: _isFiltersOpen
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),

        // Chosen Categories Chips under the filters row
        if (widget.selectedCategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: widget.selectedCategories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 6, 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2E3033)
                            : const Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: primaryColor.withValues(
                            alpha: isDark ? 0.4 : 0.6,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            category.name,
                            style: AppTextStyle.interMedium12.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => widget.onCategoryRemoved?.call(category),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: isDark
                                    ? const Color(0xFF9E9E9E)
                                    : const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
