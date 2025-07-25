import 'package:fitnessapp/core/data/dbo/physical_activity_dbo.dart';

/// Filtered selection of physical activities
/// Activities included: bicycling (general), jogging, running, climbing, walking (for pleasure), swimming, kayaking, soccer
class PhysicalActivityDataSource {
  List<PhysicalActivityDBO> getPhysicalActivityList() => [
        // Bicycling (only general)
        PhysicalActivityDBO("01015", "bicycling", "general", 7.5, [],
            PhysicalActivityTypeDBO.bicycling),

        // Jogging
        PhysicalActivityDBO("12020", "jogging", "general", 7.0, [],
            PhysicalActivityTypeDBO.running),

        // Running
        PhysicalActivityDBO("12150", "running", "general", 8.0, [],
            PhysicalActivityTypeDBO.running),

        // Climbing
        PhysicalActivityDBO("15533", "climbing", "rock or mountain climbing",
            8.0, [], PhysicalActivityTypeDBO.sport),

        // Walking (for pleasure only)
        PhysicalActivityDBO("17160", "walking", "for pleasure", 3.5, [],
            PhysicalActivityTypeDBO.sport),

        // Swimming
        PhysicalActivityDBO(
            "18350",
            "swimming",
            "treading water, moderate effort, general",
            3.5,
            [],
            PhysicalActivityTypeDBO.waterActivities),

        // Kayaking
        PhysicalActivityDBO("18100", "kayaking", "moderate effort", 5.0, [],
            PhysicalActivityTypeDBO.waterActivities),

        // Soccer
        PhysicalActivityDBO("15610", "soccer", "casual, general", 7.0, [],
            PhysicalActivityTypeDBO.sport),
      ];
}
