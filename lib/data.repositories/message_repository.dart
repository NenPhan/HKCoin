import 'package:dartz/dartz.dart';
import 'package:hkcoin/core/err/failures.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.datasources/message_datasource.dart';
import 'package:hkcoin/data.models/private_message.dart';

class MessageRepository {
  Future<Either<Failure, int?>> messageCount() {
    return handleRepositoryCall(
      onRemote: () async {
        int? id = await MessageDatasource().messageCount();
        return Right(id);
      },
    );
  }
   Future<Either<Failure, PrivateMessagePagination>> getPrivateMessages({
    bool isRead = false,
    int page = 1,
    int limit = 10,
  }) {
    return handleRepositoryCall(
      onRemote: () async {
        return Right(
          await MessageDatasource().getPrivateMessagesData(isRead: isRead, page: page, limit: limit),
        );
      },
    );
  }
  Future<Either<Failure, PrivateMessage>> getPrivateMessageDetail(int id) {
    return handleRepositoryCall(
      onRemote: () async {
        var result = await MessageDatasource().getPrivateMessageDetail(id);
        return Right(result);
      },
    );
  }
}