import 'package:dartz/dartz.dart';

import '../../../../../core/resources/api/failure_class.dart';
import '../entities/resend_code_entity.dart';
import '../entities/verify_account_entity.dart';

abstract class VerifyAccountRepo {
  Future<Either<Failure, VerifyAccountEntity>> verifyAccount(VerifyAccountEntity verifyAccountEntity);
  Future<Either<Failure, ResendCodeEntity>> resendCode(ResendCodeEntity resendCodeEntity);
}