import 'package:fitnessapp/core/data/repository/user_activity_repository.dart';
import 'package:fitnessapp/core/domain/entity/user_activity_entity.dart';

class GetUserActivityUsecase {
  final UserActivityRepository _userActivityRepository;

  GetUserActivityUsecase(this._userActivityRepository);

  Future<List<UserActivityEntity>> getTodayUserActivity() {
    return _userActivityRepository.getAllUserActivityByDate(DateTime.now());
  }

  Future<List<UserActivityEntity>> getUserActivityByDay(DateTime day) {
    return _userActivityRepository.getAllUserActivityByDate(day);
  }

  Future<List<UserActivityEntity>> getRecentUserActivity() {
    return _userActivityRepository.getRecentUserActivity();
  }
}
