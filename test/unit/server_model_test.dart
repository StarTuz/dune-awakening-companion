import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/servers/models/server.dart';

void main() {
  final now = DateTime.now();

  test('copyWith preserves unset fields', () {
    final server = Server(id: 's1', name: 'Test Server', createdAt: now);
    final copy = server.copyWith(name: 'Updated');
    expect(copy.id, 's1');
    expect(copy.name, 'Updated');
    expect(copy.createdAt, now);
  });
}
