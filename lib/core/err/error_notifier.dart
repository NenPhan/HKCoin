import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/toast.dart';

class ErrorNotifier {
  static void notify(Failure failure) {
    if (!ErrorPolicy.shouldNotify(failure)) return;
    final message = _resolveMessage(failure);

    if (message.isEmpty) return;

    Toast.showErrorToast(message);
  }

  static String _resolveMessage(Failure failure) {
    // ⭐ ƯU TIÊN ERRORS
    if (failure.errors != null && failure.errors!.isNotEmpty) {
      return failure.errors!.join('\n');
    }

    if (failure.message.isNotEmpty) {
      return failure.message;
    }

    return "Có lỗi xảy ra, vui lòng thử lại";
  }
}

class ErrorPolicy {
  static bool shouldNotify(Failure failure) {
    final code = failure.statusCode;

    // ❌ Không notify
    if (code == 401 || code == 403 || code == 404) return false;

    // ❌ Validation local / silent
    if (code == null && failure is NetworkFailure) return true;

    // ✅ Server lỗi
    if (code != null && code >= 500) return true;

    // ⚠️ Validation server
    if (code == 422 || code == 409 || code == 400) return true;

    return false;
  }
}
