import 'package:fitnessapp/core/data/repository/user_activity_repository.dart';
import 'package:fitnessapp/core/domain/entity/user_activity_entity.dart';

class AddUserActivityUsecase {
  final UserActivityRepository _userActivityRepository;

  AddUserActivityUsecase(this._userActivityRepository);

  Future<void> addUserActivity(UserActivityEntity userActivityEntity) async {
    return await _userActivityRepository.addUserActivity(userActivityEntity);
  }
}
