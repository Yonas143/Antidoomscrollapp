import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// --- Hypothetical Activity Model and Service (replace with your actual paths) ---
// You would typically have these in your lib folder, e.g.,
// import 'package:antidoomscrollapp/models/activity.dart';
// import 'package:antidoomscrollapp/services/activity_service.dart';

// Placeholder for your Activity model
class Activity {
  String id;
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  Activity({
    required this.id,
    required this.name,
    this.description = '',
    required this.date,
    this.isCompleted = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          date == other.date &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      date.hashCode ^
      isCompleted.hashCode;
}

// Placeholder for your ActivityService abstract class or interface
abstract class ActivityService {
  Future<Activity> createActivity(Activity activity);
  Future<Activity?> getActivity(String id);
  Future<List<Activity>> getAllActivities();
  Future<Activity> updateActivity(Activity activity);
  Future<void> deleteActivity(String id);
}
// --- End of Hypothetical Activity Model and Service ---

// Create a mock class for ActivityService using Mockito
class MockActivityService extends Mock implements ActivityService {}

void main() {
  group('ActivityService Unit Tests', () {
    late MockActivityService mockActivityService;

    setUp(() {
      mockActivityService = MockActivityService();
    });

    test('createActivity successfully adds a new activity', () async {
      final newActivity = Activity(
        id: '1',
        name: 'Morning Run',
        date: DateTime.now(),
      );
      when(mockActivityService.createActivity(newActivity))
          .thenAnswer((_) async => newActivity);

      final result = await mockActivityService.createActivity(newActivity);
      expect(result, newActivity);
      verify(mockActivityService.createActivity(newActivity)).called(1);
    });

    test('getActivity returns an activity if found', () async {
      final existingActivity = Activity(
        id: '2',
        name: 'Read Book',
        date: DateTime(2023, 10, 26),
      );
      when(mockActivityService.getActivity('2'))
          .thenAnswer((_) async => existingActivity);

      final result = await mockActivityService.getActivity('2');
      expect(result, existingActivity);
      verify(mockActivityService.getActivity('2')).called(1);
    });

    test('getActivity returns null if activity not found', () async {
      when(mockActivityService.getActivity('999')).thenAnswer((_) async => null);

      final result = await mockActivityService.getActivity('999');
      expect(result, isNull);
      verify(mockActivityService.getActivity('999')).called(1);
    });

    test('getAllActivities returns a list of activities', () async {
      final activities = [
        Activity(id: '1', name: 'Activity A', date: DateTime.now()),
        Activity(id: '2', name: 'Activity B', date: DateTime.now()),
      ];
      when(mockActivityService.getAllActivities()).thenAnswer((_) async => activities);

      final result = await mockActivityService.getAllActivities();
      expect(result, activities);
      expect(result.length, 2);
      verify(mockActivityService.getAllActivities()).called(1);
    });

    test('updateActivity successfully modifies an existing activity', () async {
      final originalActivity = Activity(
        id: '3',
        name: 'Work Project',
        date: DateTime(2023, 11, 1),
        isCompleted: false,
      );
      final updatedActivity = Activity(
        id: '3',
        name: 'Work Project',
        date: DateTime(2023, 11, 1),
        isCompleted: true,
      );
      when(mockActivityService.updateActivity(updatedActivity))
          .thenAnswer((_) async => updatedActivity);

      final result = await mockActivityService.updateActivity(updatedActivity);
      expect(result, updatedActivity);
      verify(mockActivityService.updateActivity(updatedActivity)).called(1);
    });

    test('deleteActivity successfully removes an activity', () async {
      when(mockActivityService.deleteActivity('4')).thenAnswer((_) async => Future.value());

      await mockActivityService.deleteActivity('4');
      verify(mockActivityService.deleteActivity('4')).called(1);
    });
  });
}
