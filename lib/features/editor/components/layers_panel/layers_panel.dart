import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LayersPanel extends ConsumerWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLayerButton('Base Terrain', isSelected: true),
          _buildLayerButton('Mountains'),
          _buildLayerButton('Water'),
          _buildLayerButton('Vegetation'),
          const SizedBox(height: 16),
          _buildAddLayerButton(),
        ],
      ),
    );
  }

  Widget _buildLayerButton(String text, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.layers,
              size: 16,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.visibility,
              size: 16,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddLayerButton() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        foregroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 16),
          SizedBox(width: 8),
          Text('Add Layer'),
        ],
      ),
    );
  }
}
