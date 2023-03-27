import 'package:base_code/src/utils/enums/roles.dart';

extension RoleExtension on String {
  Role? roleFromString() {
    switch (this) {
      case 'consumer':
        return Role.consumer;
      case 'seller':
        return Role.seller;
      default:
        return null;
    }
  }
}
