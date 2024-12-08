import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LayerSettingsPanel extends ConsumerWidget {
  const LayerSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layer Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSlider('Scale', 0.5),
          _buildSlider('Roughness', 0.7),
          _buildSlider('Detail', 0.3),
          const SizedBox(height: 16),
          _buildColorPicker(),
          const SizedBox(height: 16),
          _buildBlendModeSelector(),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(2)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: const SliderThemeData(
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color'),
        const SizedBox(height: 8),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildBlendModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Blend Mode'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: 'Normal',
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'Normal', child: Text('Normal')),
            DropdownMenuItem(value: 'Multiply', child: Text('Multiply')),
            DropdownMenuItem(value: 'Screen', child: Text('Screen')),
            DropdownMenuItem(value: 'Overlay', child: Text('Overlay')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}
