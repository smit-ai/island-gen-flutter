import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainDisplayArea extends ConsumerWidget {
  const MainDisplayArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            // Preview area
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Preview Area',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // Toolbar overlay
            Positioned(
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
            ),
          ],
        ),
      ),
    );
  }
}
