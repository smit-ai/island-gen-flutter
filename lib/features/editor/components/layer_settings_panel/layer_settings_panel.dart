import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';
import 'package:island_gen_flutter/models/layer.dart';

class LayerSettingsPanel extends ConsumerWidget {
  const LayerSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayer = ref.watch(globalStateProvider.select((value) => value.selectedLayer));

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
          if (selectedLayer == null)
            const Text('No layer selected')
          else
            Expanded(
              child: SingleChildScrollView(
                child: Builder(builder: (BuildContext context) {
                  final layer = ref.watch(layerControllerProvider(selectedLayer.id));
                  final controller = ref.watch(layerControllerProvider(selectedLayer.id).notifier);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Layer Settings
                      _buildSection(
                        'Basic Settings',
                        Column(
                          children: [
                            _buildTextField(
                              'Name',
                              layer.name,
                              (value) => controller.updateName(value),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown<LayerBlendMode>(
                              'Blend Mode',
                              layer.blendMode,
                              LayerBlendMode.values,
                              (value) => controller.updateBlendMode(value),
                            ),
                            const SizedBox(height: 8),
                            _buildSlider(
                              'Influence',
                              layer.influence,
                              0.0,
                              1.0,
                              (value) => controller.updateInfluence(value),
                              displayPercent: true,
                            ),
                          ],
                        ),
                      ),

                      // Noise Type Settings
                      _buildSection(
                        'Noise Settings',
                        Column(
                          children: [
                            _buildDropdown<LayerNoiseType>(
                              'Type',
                              layer.noiseParams.type,
                              LayerNoiseType.values,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(type: value)),
                            ),
                            const SizedBox(height: 16),
                            _buildSlider(
                              'Scale',
                              layer.noiseParams.scale,
                              0.1,
                              10.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(scale: value)),
                            ),
                            _buildSlider(
                              'Frequency',
                              layer.noiseParams.frequency,
                              0.1,
                              10.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(frequency: value)),
                            ),
                            _buildIntSlider(
                              'Octaves',
                              layer.noiseParams.octaves,
                              1,
                              8,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(octaves: value)),
                            ),
                            _buildSlider(
                              'Persistence',
                              layer.noiseParams.persistence,
                              0.0,
                              1.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(persistence: value)),
                            ),
                            _buildSlider(
                              'Lacunarity',
                              layer.noiseParams.lacunarity,
                              1.0,
                              4.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(lacunarity: value)),
                            ),
                          ],
                        ),
                      ),

                      // Transform Settings
                      _buildSection(
                        'Transform',
                        Column(
                          children: [
                            _buildSlider(
                              'Offset X',
                              layer.noiseParams.offsetX,
                              -100.0,
                              100.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(offsetX: value)),
                            ),
                            _buildSlider(
                              'Offset Y',
                              layer.noiseParams.offsetY,
                              -100.0,
                              100.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(offsetY: value)),
                            ),
                            _buildSlider(
                              'Rotation',
                              layer.noiseParams.rotation,
                              0.0,
                              360.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(rotation: value)),
                            ),
                          ],
                        ),
                      ),

                      // Range Settings
                      _buildSection(
                        'Range',
                        Column(
                          children: [
                            _buildSlider(
                              'Clamp Min',
                              layer.noiseParams.clampMin,
                              0.0,
                              1.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(clampMin: value)),
                            ),
                            _buildSlider(
                              'Clamp Max',
                              layer.noiseParams.clampMax,
                              0.0,
                              1.0,
                              (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(clampMax: value)),
                            ),
                            CheckboxListTile(
                              title: const Text('Invert'),
                              value: layer.noiseParams.invert,
                              onChanged: (value) => controller.updateNoiseParams(layer.noiseParams.copyWith(invert: value ?? false)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: content,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onSubmitted: onChanged,
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    bool displayPercent = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(displayPercent ? '${(value * 100).round()}%' : value.toStringAsFixed(3)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildIntSlider(
    String label,
    int value,
    int min,
    int max,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toString()),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>(
    String label,
    T value,
    List<T> items,
    Function(T) onChanged,
  ) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.map((T item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.toString().split('.').last),
        );
      }).toList(),
      onChanged: (T? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}
