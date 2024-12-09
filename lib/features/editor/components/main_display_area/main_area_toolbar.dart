// Toolbar overlay
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainAreaToolbar extends ConsumerWidget {
  const MainAreaToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 16,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () {},
                tooltip: 'Zoom In',
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () {},
                tooltip: 'Zoom Out',
              ),
              IconButton(
                icon: const Icon(Icons.fit_screen),
                onPressed: () {},
                tooltip: 'Fit to Screen',
              ),
              const SizedBox(width: 8),
              const VerticalDivider(),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {},
                tooltip: 'Export',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
