import 'dart:convert';

class Workout {
  late int? id;
  late int? time;
  late String? weekDay;
  late String? userId;

  Workout({
    this.id,
    this.time,
    this.weekDay,
    this.userId,
  });

  Map<String, Object?> toJson() => {
        "id": id,
        "time": time,
        "weekDay": weekDay,
        "userId": userId
      };

  static Workout fromJson(Map<String, dynamic> json) => Workout(
        id: json["id"] as int,
        time: json["time"] as int,
        weekDay: json["weekDay"] as String,
        userId: json["userId"] as String,
      );
}

List<Workout> workoutFromJsonList(String str) =>
    List<Workout>.from(json.decode(str).map((x) => Workout.fromJson(x)));

Map<String, dynamic> workoutFromJson(String str) {
  Map<String, dynamic> jsonMap = json.decode(str);
  return jsonMap;
}

String workoutToJson(Workout workout) => json.encode(workout.toJson());