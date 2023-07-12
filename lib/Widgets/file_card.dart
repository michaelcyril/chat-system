import 'package:flutter/material.dart';

class FileCard extends StatelessWidget {
  final String fileName;
  final String fileSize;

  FileCard({required this.fileName, required this.fileSize});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  fileSize,
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
