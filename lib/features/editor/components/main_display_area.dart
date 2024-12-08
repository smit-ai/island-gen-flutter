import 'package:flutter/material.dart';

class MainDisplayArea extends StatelessWidget {
  const MainDisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black87,
        child: const Center(
          child: Text(
            'Preview Area',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
