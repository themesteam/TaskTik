class Todo {
  Todo(
      {required this.id,
      required this.title,
      required this.isCompleted,
      required this.categoryId,
      required this.isImportant,
      this.description,
      this.range,
      this.lesson});
  int id;
  String title;
  bool isCompleted;
  bool isImportant;
  int categoryId;
  String? description;
  String? range;
  String? lesson;
  Map<String, dynamic> toMap() => _$TaskToMap(this);

  _$TaskToMap(Todo profile) => <String, dynamic>{
        'id': profile.id,
        'title': profile.title,
        'isCompleted': profile.isCompleted,
        'isImportant': profile.isImportant,
        'categoryId': profile.categoryId,
        'description': profile.description,
        'range': profile.range,
        'lesson': profile.lesson
      };
}
