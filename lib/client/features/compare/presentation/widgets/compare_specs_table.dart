import 'package:flutter/material.dart';

class CompareSpecsTable extends StatelessWidget {
  final List<Map<String, String>> specs;

  const CompareSpecsTable({
    super.key,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade300,
      ),
      columnWidths: const {
        0: FixedColumnWidth(120),
      },
      children: [
        _row(
          "Processor",
          specs.map((e) => e["processor"] ?? "-").toList(),
        ),
        _row(
          "Graphics",
          specs.map((e) => e["gpu"] ?? "-").toList(),
        ),
        _row(
          "Memory",
          specs.map((e) => e["memory"] ?? "-").toList(),
        ),
        _row(
          "Storage",
          specs.map((e) => e["storage"] ?? "-").toList(),
        ),
        _row(
          "Weight",
          specs.map((e) => e["weight"] ?? "-").toList(),
        ),
      ],
    );
  }

  TableRow _row(
    String label,
    List<String> values,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...values.map(
          (e) => Padding(
            padding: const EdgeInsets.all(12),
            child: Text(e),
          ),
        ),
      ],
    );
  }
}