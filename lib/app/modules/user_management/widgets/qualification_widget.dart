import 'package:flutter/material.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../models/user_model.dart';

class QualificationWidget extends StatelessWidget {
  final Qualification qualification;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const QualificationWidget({
    super.key,
    required this.qualification,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    String resultString = '';
    if (qualification.resultType != null && qualification.result != null) {
      resultString = '${qualification.resultType}: ${qualification.result}';
    }

    return Card(
      margin: const EdgeInsets.all(MySizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(qualification.degreeName ?? 'N/A',
                style: Theme.of(context).textTheme.titleMedium),
            Text('Institution: ${qualification.institutionName ?? 'N/A'}'),
            Text('Passing Year: ${qualification.passingYear ?? 'N/A'}'),
            Text('Subject: ${qualification.majorSubject ?? 'N/A'}'),
            Text(resultString),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}