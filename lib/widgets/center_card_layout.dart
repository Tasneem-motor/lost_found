import 'package:flutter/material.dart';

class CenterCardLayout extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const CenterCardLayout({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      size: 70,
                      color: Theme.of(context).colorScheme.primary),

                  const SizedBox(height: 12),

                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 24),

                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
