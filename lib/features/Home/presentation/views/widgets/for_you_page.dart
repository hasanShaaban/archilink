
import 'package:flutter/material.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(height: 100, color: Colors.red),
        Container(height: 100, color: Colors.green),
        Container(height: 100, color: Colors.blue),
        Container(height: 100, color: Colors.yellow),
        Container(height: 100, color: Colors.red),
        Container(height: 100, color: Colors.green),
        Container(height: 100, color: Colors.blue),
        Container(height: 100, color: Colors.yellow),
      ],
    );
  }
}
