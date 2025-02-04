import 'package:uuid/uuid.dart';

int generateID() {
  var uuid = Uuid();
  return uuid.v4().hashCode;
}
