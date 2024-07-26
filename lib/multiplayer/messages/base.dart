import 'dart:convert';

abstract class MessageBase {
  String get type;

  String marshal() => jsonEncode({
        'type': type,
        ...repr(),
      });

  Map<String, dynamic> repr();

  @override
  String toString() => 'Message of type $runtimeType: ${marshal()}';
}
