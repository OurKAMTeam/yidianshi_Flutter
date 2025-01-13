// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ScoreStatics extends StatelessWidget {
  final double avgScore;
  final double avgGPA;
  final double selectedAvgScore;
  final double selectedAvgGPA;
  final double selectedCredit;
  final double totalCredit;

  const ScoreStatics({
    super.key,
    required this.avgScore,
    required this.avgGPA,
    required this.selectedAvgScore,
    required this.selectedAvgGPA,
    required this.selectedCredit,
    required this.totalCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FlutterI18n.translate(context, "score.statistics"),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn(
                  context,
                  FlutterI18n.translate(context, "score.overall"),
                  avgScore.toStringAsFixed(2),
                  avgGPA.toStringAsFixed(2),
                  totalCredit.toStringAsFixed(1),
                ),
                _buildStatColumn(
                  context,
                  FlutterI18n.translate(context, "score.selected"),
                  selectedAvgScore.toStringAsFixed(2),
                  selectedAvgGPA.toStringAsFixed(2),
                  selectedCredit.toStringAsFixed(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String title,
    String avgScore,
    String avgGPA,
    String credit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildStatRow(context, "score.avg_score", avgScore),
        _buildStatRow(context, "score.avg_gpa", avgGPA),
        _buildStatRow(context, "score.credit", credit),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "${FlutterI18n.translate(context, label)}: ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
