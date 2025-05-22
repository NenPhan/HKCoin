import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/check_update_datasource.dart';
import 'package:hkcoin/data.models/check_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckUpdateRepository {
  Future<Either<Failure, CheckUpdateResult>> checkVersion() async {    
    final packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    return handleRepositoryCall(
      onRemote: () async {
        var result = await CheckUpdateDatasource().checkVersion(currentVersion: currentVersion, platform: "android");
        return Right(result);
      },
    );
  }
}