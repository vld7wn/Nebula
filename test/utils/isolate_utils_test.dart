import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/utils/isolate_utils.dart';

void main() {
  group('IsolateUtils', () {
    group('parseJsonMap', () {
      test('parses valid JSON object', () async {
        const jsonString = '{"name": "test", "value": 123}';

        final result = await IsolateUtils.parseJsonMap(jsonString);

        expect(result['name'], 'test');
        expect(result['value'], 123);
      });

      test('parses nested JSON', () async {
        const jsonString = '{"user": {"name": "John", "age": 30}}';

        final result = await IsolateUtils.parseJsonMap(jsonString);

        expect(result['user']['name'], 'John');
        expect(result['user']['age'], 30);
      });

      test('handles arrays in JSON', () async {
        const jsonString = '{"items": [1, 2, 3], "tags": ["a", "b"]}';

        final result = await IsolateUtils.parseJsonMap(jsonString);

        expect(result['items'], [1, 2, 3]);
        expect(result['tags'], ['a', 'b']);
      });

      test('throws on invalid JSON', () async {
        const invalidJson = '{invalid json}';

        expect(() => IsolateUtils.parseJsonMap(invalidJson), throwsException);
      });
    });

    group('parseJsonList', () {
      test('parses JSON array', () async {
        const jsonString = '[1, 2, 3, 4, 5]';

        final result = await IsolateUtils.parseJsonList(jsonString);

        expect(result.length, 5);
        expect(result[0], 1);
        expect(result[4], 5);
      });

      test('parses array of objects', () async {
        const jsonString = '[{"id": 1}, {"id": 2}]';

        final result = await IsolateUtils.parseJsonList(jsonString);

        expect(result.length, 2);
        expect(result[0]['id'], 1);
      });

      test('handles empty array', () async {
        const jsonString = '[]';

        final result = await IsolateUtils.parseJsonList(jsonString);

        expect(result.isEmpty, true);
      });
    });

    group('encodeJson', () {
      test('encodes map to JSON', () async {
        final data = {'name': 'test', 'count': 42};

        final result = await IsolateUtils.encodeJson(data);

        expect(result, contains('"name":"test"'));
        expect(result, contains('"count":42'));
      });

      test('encodes list to JSON', () async {
        final data = [1, 2, 3];

        final result = await IsolateUtils.encodeJson(data);

        expect(result, '[1,2,3]');
      });

      test('encodes nested structures', () async {
        final data = {
          'users': [
            {'name': 'Alice'},
            {'name': 'Bob'},
          ],
        };

        final result = await IsolateUtils.encodeJson(data);

        expect(result, contains('Alice'));
        expect(result, contains('Bob'));
      });
    });
  });
}
