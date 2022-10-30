// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Habits {
  int? id;
  String? name;
  int? spent;
  int? goal;
  int started = 0;
  Habits({
    this.id,
    this.name,
    this.spent,
    this.goal,
    required this.started,
  });

  Habits copyWith({
    int? id,
    String? name,
    int? spent,
    int? goal,
    int? started,
  }) {
    return Habits(
      id: id ?? this.id,
      name: name ?? this.name,
      spent: spent ?? this.spent,
      goal: goal ?? this.goal,
      started: started ?? this.started,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'spent': spent,
      'goal': goal,
      'started': started,
    };
  }

  factory Habits.fromMap(Map<String, dynamic> map) {
    return Habits(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      spent: map['spent'] != null ? map['spent'] as int : null,
      goal: map['goal'] != null ? map['goal'] as int : null,
      started: map['started'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Habits.fromJson(String source) =>
      Habits.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Habits(id: $id, name: $name, spent: $spent, goal: $goal, started: $started)';
  }

  @override
  bool operator ==(covariant Habits other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.spent == spent &&
        other.goal == goal &&
        other.started == started;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        spent.hashCode ^
        goal.hashCode ^
        started.hashCode;
  }
}
