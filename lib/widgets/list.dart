import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/celebration.dart';
import '../service/service_locator.dart';
import '../service/storage/storage_service.dart';

class ListTab extends StatefulWidget {
  const ListTab({Key? key}) : super(key: key);

  @override
  _ListTabState createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  final _storageService = getIt.get<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Celebration>>(
        stream: _storageService.getAllCelebrations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final now = DateTime.now();
          final celebrations = snapshot.data!
              .where((c) => c.date.isAfter(now))
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));

          return ListView.builder(
            itemCount: celebrations.length,
            itemBuilder: (context, index) {
              final celebration = celebrations[index];

              return Column(
                children: [
                  ListTile(
                    title: Text(celebration.name),
                    subtitle: Text(
                      '${DateFormat.yMMMMd().format(celebration.date)} - ${describeEnum(celebration.type)}',
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }
}