import 'package:hive/hive.dart';

import '../core/strings.dart';

class StorageHelper {
  final Box scanRecordBox = Hive.box(boxName);

  void saveRecord(Map<String, dynamic> value) {
    scanRecordBox.put(value[scanId], value);
  }

  Iterable getAllRecord() {
    return scanRecordBox.values;
  }

  void deleteRecode(int id) {
    scanRecordBox.delete(id);
  }
}