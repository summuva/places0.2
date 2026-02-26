import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/place_model.dart';
import '../models/tag_model.dart';
import '../providers/map_provider.dart';

class CreatePlaceDialog extends StatefulWidget {
  final LatLng position;

  const CreatePlaceDialog({super.key, required this.position});

  static Future<Place?> show(BuildContext context, LatLng position) {
    return showModalBottomSheet<Place>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CreatePlaceDialog(position: position),
    );
  }

  @override
  State<CreatePlaceDialog> createState() => _CreatePlaceDialogState();
}

class _CreatePlaceDialogState extends State<CreatePlaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final Set<Tag> _selectedTags = {};
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final place = Place(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        lat: widget.position.latitude,
        lng: widget.position.longitude,
        tags: Set.from(_selectedTags),
      );
      Navigator.of(context).pop(place);
    }
  }
  void _cancel() {
    Navigator.of(context).pop();
    context.read<MapProvider>().cancelAddingPlace();
    
  }
  void _toggleTag(TagCategory category) {
    setState(() {
      final existing = _selectedTags.where((t) => t.category == category);
      if (existing.isNotEmpty) {
        _selectedTags.removeWhere((t) => t.category == category);
      } else {
        _selectedTags.add(Tag(
          id: category.name,
          name: category.name,
          category: category,
        ));
      }
    });
  }

  bool _isTagSelected(TagCategory category) {
    return _selectedTags.any((t) => t.category == category);
  }

  // Icono y label para cada categoría
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
        return 'Bar';
      case TagCategory.afterOffice:
        return 'After Office';
      case TagCategory.parque:
        return 'Parque';
      case TagCategory.gastronomia:
        return 'Gastronomía';
      case TagCategory.recital:
        return 'Recital';
      case TagCategory.universidad:
        return 'Universidad';
      case TagCategory.coworking:
        return 'Coworking';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Nuevo lugar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Coordinates
            Text(
              '📍 ${widget.position.latitude.toStringAsFixed(5)}, ${widget.position.longitude.toStringAsFixed(5)}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej: Mi café favorito',
                prefixIcon: Icon(Icons.label_outline),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tags section
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TagCategory.values.map((category) {
                final selected = _isTagSelected(category);
                return FilterChip(
                  selected: selected,
                  label: Text(_labelForCategory(category)),
                  avatar: Icon(
                    _iconForCategory(category),
                    size: 18,
                    color: selected ? Colors.white : Colors.grey.shade600,
                  ),
                  selectedColor: Colors.green,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade800,
                  ),
                  onSelected: (_) => _toggleTag(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _cancel(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}