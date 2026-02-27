import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/tag_model.dart';

class TagCarousel extends StatefulWidget {
  final Set<TagCategory> selectedCategories;
  final ValueChanged<TagCategory> onCategoryToggled;

  const TagCarousel({
    super.key,
    required this.selectedCategories,
    required this.onCategoryToggled,
  });

  @override
  State<TagCarousel> createState() => _TagCarouselState();
}

class _TagCarouselState extends State<TagCarousel> {
  late List<TagCategory> _orderedCategories;

  @override
  void initState() {
    super.initState();
    _orderedCategories = List.from(TagCategory.values);
  }

  IconData _iconForCategory(TagCategory category) {
    switch (category) {
      case TagCategory.bar:
        return Icons.local_bar;
      case TagCategory.afterOffice:
        return Icons.work_off;
      case TagCategory.parque:
        return Icons.park;
      case TagCategory.gastronomia:
        return Icons.restaurant;
      case TagCategory.recital:
        return Icons.music_note;
      case TagCategory.universidad:
        return Icons.school;
      case TagCategory.coworking:
        return Icons.laptop;
    }
  }

  String _labelForCategory(TagCategory category) {
    switch (category) {
      case TagCategory.bar:
        return 'Bares';
      case TagCategory.afterOffice:
        return 'After Office';
      case TagCategory.parque:
        return 'Parques';
      case TagCategory.gastronomia:
        return 'Gastronomía';
      case TagCategory.recital:
        return 'Recitales';
      case TagCategory.universidad:
        return 'Universidad';
      case TagCategory.coworking:
        return 'Coworking';
    }
  }

  // ...existing code...

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          // Lista reordenable
          ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            itemCount: _orderedCategories.length,
            buildDefaultDragHandles: false,
            proxyDecorator: (child, index, animation) {
              return Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: animation.drive(
                    Tween(begin: 1.0, end: 1.1).chain(
                      CurveTween(curve: Curves.easeInOut),
                    ),
                  ),
                  child: child,
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _orderedCategories.removeAt(oldIndex);
                _orderedCategories.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) {
              final category = _orderedCategories[index];
              final isSelected = widget.selectedCategories.contains(category);

              return Padding(
                key: ValueKey(category),
                padding: EdgeInsets.only(
                  right: index < _orderedCategories.length - 1 ? 8 : 0,
                ),
                child: _CustomDelayedDragStartListener(
                  index: index,
                  delay: const Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: () => widget.onCategoryToggled(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black87
                            : Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _iconForCategory(category),
                            size: 16,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _labelForCategory(category),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Difuminado izquierdo
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Difuminado derecho
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ...existing code...
class _CustomDelayedDragStartListener extends ReorderableDragStartListener {
  final Duration delay;

  const _CustomDelayedDragStartListener({
    required super.index,
    required this.delay,
    required super.child,
  });

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(delay: delay);
  }
}