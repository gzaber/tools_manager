class Tool {
  final String? id;
  final String name;
  final String date;
  final String? giver;
  final String holder;
  final String? receiver;

  Tool({
    this.id,
    required this.name,
    required this.date,
    this.giver,
    required this.holder,
    this.receiver,
  });
}
