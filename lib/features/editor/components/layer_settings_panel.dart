import 'package:flutter/material.dart';

class LayerSettingsPanel extends StatelessWidget {
  const LayerSettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
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
          _buildSlider('Setting 1'),
          _buildSlider('Setting 2'),
          _buildSlider('Setting 3'),
        ],
      ),
    );
  }

  Widget _buildSlider(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        SliderTheme(
          data: const SliderThemeData(
            trackHeight: 4,
          ),
          child: Slider(
            value: 0.5,
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
