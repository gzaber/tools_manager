import '../../domain/entities/tool.dart';

class ToolModel extends Tool {
  ToolModel({
    String? id,
    required String name,
    required String date,
    String? giver,
    required String holder,
    String? receiver,
  }) : super(
          id: id,
          name: name,
          date: date,
          giver: giver,
          holder: holder,
          receiver: receiver,
        );

  factory ToolModel.fromMap(String id, Map<String, dynamic> map) {
    return ToolModel(
      id: id,
      name: map['name'],
      date: map['date'],
      giver: map['giver'],
      holder: map['holder'],
      receiver: map['receiver'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'giver': giver,
      'holder': holder,
      'receiver': receiver,
    };
  }
}
