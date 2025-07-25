import 'package:fitnessapp/core/data/repository/intake_repository.dart';
import 'package:fitnessapp/core/domain/entity/intake_entity.dart';

class DeleteIntakeUsecase {
  final IntakeRepository _intakeRepository;

  DeleteIntakeUsecase(this._intakeRepository);

  Future<void> deleteIntake(IntakeEntity intakeEntity) async {
    await _intakeRepository.deleteIntake(intakeEntity);
  }
}
