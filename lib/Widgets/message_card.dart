import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String sender;
  final String message;
  final String timestamp;
  final Color bgColors;

  const MessageCard({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.bgColors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColors,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timestamp,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}