import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/services/population_2027_dataset.dart';

void main() {
  const header =
      'adm2_name,adm2_name1,adm2_pcode,adm1_name,adm1_name1,adm1_pcode,adm_type,Total Estimated Population 2027';

  test('keeps population rows separate and excludes blank-P-code aggregate', () {
    final dataset = Population2027Dataset.parse(
      '$header\n'
      'District A,ولسوالی الف,AF0101,Province A,ولایت الف,AF01,District," 1,234 "\n'
      ',,,,,,,"50,489,104"\n',
    );

    expect(dataset.recordCount, 1);
    expect(dataset.findByPcode('AF0101')!.provincePcode, 'AF01');
    expect(dataset.findByPcode('AF0101')!.sourceValue('Total Estimated Population 2027'), ' 1,234 ');
    expect(dataset.findByPcode('AF9999'), isNull);
  });

  test('preserves blank cells and whitespace-padded hyphen markers', () {
    final dataset = Population2027Dataset.parse(
      '$header,Urban Total\n'
      'District A,ولسوالی الف,AF0101,Province A,ولایت الف,AF01,District,100," -   "\n'
      'District B,ولسوالی ب,AF0102,Province A,ولایت الف,AF01,District,200,\n',
    );

    expect(dataset.records[0].sourceValue('Urban Total'), ' -   ');
    expect(dataset.records[1].sourceValue('Urban Total'), '');
  });

  test('rejects duplicate stable ADM2 P-codes', () {
    expect(
      () => Population2027Dataset.parse(
        '$header\n'
        'A,الف,AF0101,P,ولایت,AF01,District,10\n'
        'B,ب,AF0101,P,ولایت,AF01,District,20\n',
      ),
      throwsFormatException,
    );
  });

  test('rejects rows whose cell count differs from the header', () {
    expect(
      () => Population2027Dataset.parse(
        '$header\n'
        'A,الف,AF0101,P,ولایت,AF01,District\n',
      ),
      throwsFormatException,
    );
  });

  test('supports quoted commas and escaped quote characters', () {
    final dataset = Population2027Dataset.parse(
      '$header,Note\n'
      'District A,ولسوالی الف,AF0101,Province A,ولایت الف,AF01,District,100,"North, \"\"old\"\""\n',
    );

    expect(dataset.records.single.sourceValue('Note'), 'North, "old"');
  });

  test('does not coerce missing parent P-code into a valid record', () {
    expect(
      () => Population2027Dataset.parse(
        '$header\n'
        'A,الف,AF0101,P,ولایت,,District,10\n',
      ),
      throwsFormatException,
    );
  });
}
