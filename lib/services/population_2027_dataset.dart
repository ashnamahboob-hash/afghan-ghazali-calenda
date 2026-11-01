import 'dart:collection';

import 'package:flutter/services.dart';

/// One ADM2 row from the 2027 population source.
///
/// Values remain strings exactly as represented in the CSV. In particular,
/// blank cells and source markers such as " -   " are never converted to zero.
class Population2027Record {
  final Map<String, String> _values;

  Population2027Record(Map<String, String> values)
      : _values = UnmodifiableMapView(Map<String, String>.from(values));

  String get pcode => _values['adm2_pcode']!;
  String get provincePcode => _values['adm1_pcode']!;
  String get nameEnglish => _values['adm2_name']!;
  String get nameLocal => _values['adm2_name1']!;
  String get provinceNameEnglish => _values['adm1_name']!;
  String get provinceNameLocal => _values['adm1_name1']!;
  String get administrativeType => _values['adm_type']!;

  /// Returns the unmodified source cell, including whitespace or empty text.
  String? sourceValue(String column) => _values[column];

  Map<String, String> get sourceValues => _values;
}

/// Population records are deliberately independent of the 401-unit
/// administrative selector. This dataset contains its own 2027 ADM2 rows.
class Population2027Dataset {
  static const assetPath =
      'assets/data/population/2027/afg_estimated_population_2027_dwg_202607_admin2.csv';

  static const requiredColumns = <String>[
    'adm2_name',
    'adm2_name1',
    'adm2_pcode',
    'adm1_name',
    'adm1_name1',
    'adm1_pcode',
    'adm_type',
    'Total Estimated Population 2027',
  ];

  final List<Population2027Record> records;
  /// National aggregate is kept separately and never mixed into ADM2 rows.
  final Population2027Record? nationalAggregate;
  final Map<String, Population2027Record> _byPcode;
  final Map<String, List<Population2027Record>> _byProvincePcode;

  Population2027Dataset._(
    List<Population2027Record> rows, {
    required this.nationalAggregate,
  })  : records = List.unmodifiable(rows),
        _byPcode = UnmodifiableMapView({
          for (final row in rows) row.pcode: row,
        }),
        _byProvincePcode = UnmodifiableMapView({
          for (final provincePcode in rows.map((row) => row.provincePcode).toSet())
            provincePcode: List.unmodifiable(
              rows.where((row) => row.provincePcode == provincePcode),
            ),
        });

  int get recordCount => records.length;

  /// Exact stable ADM2 P-code lookup; does not fall back to name matching.
  Population2027Record? findByPcode(String pcode) => _byPcode[pcode];

  /// Returns only population rows whose source parent ADM1 P-code matches.
  /// The returned list is immutable and retains source order.
  List<Population2027Record> recordsForProvince(String provincePcode) =>
      _byProvincePcode[provincePcode] ?? const [];

  static Future<Population2027Dataset> load() async {
    final csv = await rootBundle.loadString(assetPath);
    return parse(csv);
  }

  /// Parses the source CSV without numeric coercion or marker normalization.
  /// The blank-P-code national aggregate row is excluded from ADM2 records.
  static Population2027Dataset parse(String csv) {
    final rows = _parseCsv(csv);
    if (rows.isEmpty) {
      throw const FormatException('Population CSV is empty.');
    }

    final headers = List<String>.from(rows.first);
    if (headers.isNotEmpty && headers.first.startsWith('\uFEFF')) {
      headers[0] = headers[0].substring(1);
    }
    if (headers.toSet().length != headers.length) {
      throw const FormatException('Population CSV has duplicate column names.');
    }
    for (final column in requiredColumns) {
      if (!headers.contains(column)) {
        throw FormatException('Population CSV is missing column: $column');
      }
    }

    final records = <Population2027Record>[];
    final seenPcodes = <String>{};
    Population2027Record? nationalAggregate;

    for (var rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      if (row.length != headers.length) {
        throw FormatException(
          'CSV row ${rowIndex + 1} has ${row.length} cells; expected ${headers.length}.',
        );
      }

      final values = <String, String>{
        for (var i = 0; i < headers.length; i++) headers[i]: row[i],
      };
      final pcode = values['adm2_pcode']!;
      // Keep the source's national aggregate separately from ADM2 records.
      if (pcode.isEmpty) {
        if (nationalAggregate != null) {
          throw const FormatException(
            'Population CSV contains more than one blank-P-code aggregate row.',
          );
        }
        nationalAggregate = Population2027Record(values);
        continue;
      }
      if (pcode.trim() != pcode) {
        throw FormatException('ADM2 P-code contains surrounding whitespace: "$pcode".');
      }
      if (!seenPcodes.add(pcode)) {
        throw FormatException('Duplicate ADM2 P-code: $pcode');
      }
      if (values['adm1_pcode']!.isEmpty) {
        throw FormatException('ADM2 row $pcode has no parent ADM1 P-code.');
      }
      records.add(Population2027Record(values));
    }

    return Population2027Dataset._(
      records,
      nationalAggregate: nationalAggregate,
    );
  }

  /// Small RFC-4180-compatible parser supporting escaped quotes and newlines.
  /// It intentionally does not trim cells or parse numbers.
  static List<List<String>> _parseCsv(String input) {
    final rows = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var quoted = false;
    var justClosedQuote = false;

    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (quoted) {
        if (char == '"') {
          if (i + 1 < input.length && input[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            quoted = false;
            justClosedQuote = true;
          }
        } else {
          cell.write(char);
        }
        continue;
      }

      if (justClosedQuote && char != ',' && char != '\r' && char != '\n') {
        if (char.trim().isNotEmpty) {
          throw FormatException('Unexpected character after closing CSV quote at offset $i.');
        }
        // Whitespace outside a quoted cell is not part of the CSV value.
        continue;
      }
      if (char == '"' && cell.isEmpty) {
        quoted = true;
      } else if (char == ',') {
        row.add(cell.toString());
        cell.clear();
        justClosedQuote = false;
      } else if (char == '\n' || char == '\r') {
        if (char == '\r' && i + 1 < input.length && input[i + 1] == '\n') {
          i++;
        }
        row.add(cell.toString());
        cell.clear();
        rows.add(row);
        row = <String>[];
        justClosedQuote = false;
      } else {
        cell.write(char);
      }
    }

    if (quoted) {
      throw const FormatException('CSV ends inside a quoted cell.');
    }
    if (cell.isNotEmpty || row.isNotEmpty || justClosedQuote) {
      row.add(cell.toString());
      rows.add(row);
    }
    if (rows.isNotEmpty && rows.last.length == 1 && rows.last.first.isEmpty) {
      rows.removeLast();
    }
    return rows;
  }
}
