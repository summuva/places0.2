import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/place_model.dart';
import '../models/tag_model.dart';
import '../providers/map_provider.dart';
import '../utils/tag_helpers.dart';

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
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<MapProvider>(),
        child: CreatePlaceDialog(position: position),
      ),
    );
  }

  @override
  State<CreatePlaceDialog> createState() => _CreatePlaceDialogState();
}

class _CreatePlaceDialogState extends State<CreatePlaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();
  final Set<Tag> _selectedTags = {};
  File? _photo;

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
        photoPath: _photo?.path,
      );
      Navigator.of(context).pop(place);
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
    context.read<MapProvider>().cancelAddingPlace();
  }

  Future<void> _showPhotoOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Elegir de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_photo != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar foto', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _photo = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _photo = File(picked.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
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

            // Título + Foto
            Row(
              children: [
                // Título y coordenadas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nuevo lugar',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📍 ${widget.position.latitude.toStringAsFixed(5)}, ${widget.position.longitude.toStringAsFixed(5)}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Botón de foto
                GestureDetector(
                  onTap: _showPhotoOptions,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                      image: _photo != null
                          ? DecorationImage(
                              image: FileImage(_photo!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _photo == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.grey.shade400,
                            size: 28,
                          )
                        : null,
                  ),
                ),
              ],
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
                  label: Text(TagHelpers.labelForCategory(category)),
                  avatar: Icon(
                    TagHelpers.iconForCategory(category),
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
                    onPressed: _cancel,
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