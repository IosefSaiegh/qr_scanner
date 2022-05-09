const String tableQrResults = 'results';

class QrResultFields {
  static final List<String> values = [id, type, data, time];

  static const String id = 'id';
  static const String type = 'type';
  static const String data = 'data';
  static const String time = 'time';
}

class QrResult {
  final int? id;
  final String type;
  final String data;
  final DateTime createTime;
  const QrResult({
    this.id,
    required this.type,
    required this.data,
    required this.createTime,
  });
  QrResult copy({
    int? id,
    String? type,
    String? data,
    DateTime? createTime,
  }) =>
      QrResult(
        id: id ?? this.id,
        type: type ?? this.type,
        data: data ?? this.data,
        createTime: createTime ?? this.createTime,
      );
  Map<String, Object?> toJson() => {
        QrResultFields.id: id,
        QrResultFields.type: type,
        QrResultFields.data: data,
        QrResultFields.time: createTime.toIso8601String(),
      };
  static QrResult fromJson(Map<String, Object?> json) => QrResult(
        id: json[QrResultFields.id] as int?,
        type: json[QrResultFields.type] as String,
        data: json[QrResultFields.data] as String,
        createTime: DateTime.parse(json[QrResultFields.time] as String),
      );
}
