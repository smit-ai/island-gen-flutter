import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/terrain_settings_provider/terrain_settings_provider.dart';

class GlobalSettingsPanel extends ConsumerWidget {
  const GlobalSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalSettingsProvider);
    final controller = ref.read(globalSettingsProvider.notifier);

    final terrainSettingsState = ref.watch(terrainSettingsProvider);
    final terrainSettingsController = ref.read(terrainSettingsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Global Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Resolution input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resolution'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<Resolution>(
                        value: state.presets.contains(state.resolution) ? state.resolution : null,
                        hint: const Text('Select Resolution'),
                        isExpanded: true,
                        underline: Container(), // Remove the default underline
                        items: state.presets.map((preset) {
                          return DropdownMenuItem(
                            value: preset,
                            child: Text(
                              '${preset.width.toInt()}x${preset.height.toInt()}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (Resolution? newValue) {
                          if (newValue != null) {
                            controller.updateResolution(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Terrain Resolution input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Terrain Resolution'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: terrainSettingsState.gridResolution.toString(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter resolution (10-500)',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final resolution = int.tryParse(value);
                        if (resolution != null) {
                          terrainSettingsController.setGridResolution(resolution);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
