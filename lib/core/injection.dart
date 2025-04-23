import 'package:hkcoin/core/presentation/storage.dart';

class Injection {
  static setup() async {
    // final dioClient = DioClient(dio: Dio(), appConfig: AppConfig());
    Storage.init();
  }
}
