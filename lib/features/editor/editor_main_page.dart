import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/components/global_settings_panel/global_settings_panel.dart';
import 'package:island_gen_flutter/features/editor/components/layers_panel/layers_panel.dart';
import 'package:island_gen_flutter/features/editor/components/layer_settings_panel/layer_settings_panel.dart';
import 'package:island_gen_flutter/features/editor/components/main_display_area/main_display_area.dart';

class EditorMainPage extends ConsumerWidget {
  const EditorMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlobalSettingsPanel(),
                LayersPanel(),
                Expanded(child: LayerSettingsPanel()),
              ],
            ),
          ),

          // Main content area
          const MainDisplayArea(),
        ],
      ),
    );
  }
}
