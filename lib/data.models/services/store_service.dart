import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/stores/store_config.dart';
import 'package:hkcoin/data.repositories/store_respository.dart';

class StoreService extends GetxService {
  final Rxn<StoreConfig> store = Rxn<StoreConfig>();

  final StoreRepository _repo = StoreRepository();
  final Storage _storage = Storage();

  /// Load store từ API, fallback local nếu lỗi
  Future<void> loadStore() async {
    // 1️⃣ Thử load từ API
    final result = await _repo.getCurrentStore();

    final success = handleEither(result, (StoreConfig s) {
      store.value = s;

      // cache local (json)
      _storage.saveStore(s);
    });

    if (success == true) return;

    // 2️⃣ API fail → fallback local
    final localJson = _storage.getStore();
    try {
      store.value = await localJson;
    } catch (_) {
      store.value = null;
    }
  }

  /// Tiện ích lấy store hiện tại (nullable-safe)
  StoreConfig? get current => store.value;

  /// Kiểm tra đã load store chưa
  bool get isReady => store.value != null;
}
